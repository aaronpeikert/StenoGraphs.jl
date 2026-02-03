function StenoGraph_macro(ex, mod::Module=StenoGraphs)
    if ex isa Expr && ex.head == :let
        return StenoGraph_let_macro(ex, mod)
    elseif ex isa Expr && ex.head == :block
        exs = filter(x -> !isa(x, LineNumberNode), ex.args)
        exs = StenoGraphs.addition_to_vector!.(exs)
        exs = StenoGraphs.variable_as_node!.(exs)
        vec = Expr(:call, :vcat, exs...)
        return :(StenoGraph($vec))
    else
        StenoGraph_macro(Expr(:block, ex))
    end
end

# --- let-style @StenoGraph ---

"""
    _stenograph_let_from(mod, collections, body_expr)

Runtime helper for the splat form of `@StenoGraph let nodes... ...end`.
Builds a scoped `let` expression from the node collections and evaluates it
in the caller's module `mod` so that external variables resolve correctly.

Each node in the collections is exposed as a local variable named by its `id()`.
For duplicate ids, the last occurrence wins.
"""
function _stenograph_let_from(mod, collections, body_expr)
    bindings = Expr[]
    for col in collections
        for node in col
            # convert(AbstractNode, ...) handles both Symbol → SimpleNode
            # and preserves ModifiedNode wrappers.
            # We use QuoteNode to prevent eval from trying to look up the value.
            val = convert(AbstractNode, node)
            push!(bindings, Expr(:(=), id(val), QuoteNode(val)))
        end
    end
    let_expr = Expr(:let, Expr(:block, bindings...), body_expr)
    Base.invokelatest(mod.eval, let_expr)
end

"""
    StenoGraph_let_macro(ex)

Handle `@StenoGraph let ... end` forms. Dispatches between:
- **Inline**: `@StenoGraph let a, b; ... end` — symbols become fresh `SimpleNode`s
- **Splat**: `@StenoGraph let nodes...; ... end` — nodes from collection(s) exposed as variables
- **Mixed**: `@StenoGraph let a, nodes...; ... end` — combination of both
"""
function StenoGraph_let_macro(ex, mod::Module)
    bindings_ast = ex.args[1]
    body = ex.args[2]

    # Parse bindings into bare symbols and splat expressions
    bare_syms, splat_exprs = _parse_let_bindings(bindings_ast)

    # Transform body: apply addition_to_vector! but NOT variable_as_node!
    body_exprs = filter(x -> !isa(x, LineNumberNode), body.args)
    body_exprs = StenoGraphs.addition_to_vector!.(body_exprs)

    if isempty(splat_exprs)
        # Pure inline form: generate a compile-time let expression
        # StenoGraph and vcat resolve from the macro's module via hygiene;
        # body expressions are esc'd to resolve in the caller's scope.
        vec = Expr(:call, :vcat, esc.(body_exprs)...)
        graph_body = :(StenoGraph($vec))
        new_bindings = [Expr(:(=), esc(s), :(SimpleNode($(QuoteNode(s))))) for s in bare_syms]
        return Expr(:let, Expr(:block, new_bindings...), graph_body)
    else
        # Splat form (possibly with bare symbols mixed in):
        # Build the body expression as a QuoteNode so it can be eval'd at runtime
        # in the caller's module so external variables resolve correctly.
        # We interpolate the StenoGraph function directly so it resolves regardless
        # of whether the caller has StenoGraphs in scope.
        vec = Expr(:call, :vcat, body_exprs...)
        splat_body = Expr(:call, StenoGraph, vec)
        # Bare symbols get prepended as SimpleNode bindings at runtime too
        bare_collection = if isempty(bare_syms)
            :([])
        else
            Expr(:vcat, [:(SimpleNode($(QuoteNode(s)))) for s in bare_syms]...)
        end
        collections = Expr(:vcat, bare_collection, [esc(s) for s in splat_exprs]...)
        return :(_stenograph_let_from($(mod), [$collections], $(QuoteNode(splat_body))))
    end
end

"""
    _parse_let_bindings(bindings_ast)

Parse the bindings part of a `let` expression into bare symbols and splat expressions.
Returns `(bare_syms::Vector{Symbol}, splat_exprs::Vector)`.
"""
function _parse_let_bindings(bindings_ast)
    bare_syms = Symbol[]
    splat_exprs = Any[]

    if isa(bindings_ast, Symbol)
        # Single bare symbol: `let a`
        push!(bare_syms, bindings_ast)
    elseif isa(bindings_ast, Expr) && bindings_ast.head == Symbol("...")
        # Single splat: `let nodes...`
        push!(splat_exprs, bindings_ast.args[1])
    elseif isa(bindings_ast, Expr) && bindings_ast.head == :block
        # Multiple bindings: `let a, b, nodes...`
        for arg in bindings_ast.args
            if isa(arg, Symbol)
                push!(bare_syms, arg)
            elseif isa(arg, Expr) && arg.head == Symbol("...")
                push!(splat_exprs, arg.args[1])
            elseif isa(arg, LineNumberNode)
                continue
            else
                error("Invalid binding in @StenoGraph let: $arg")
            end
        end
    else
        error("Invalid bindings in @StenoGraph let: $bindings_ast")
    end

    return bare_syms, splat_exprs
end
"""
    @StenoGraph

The `@StenoGraph` macro allows you to refer to nodes without explicitly declaring them.

## Block form (auto-quoting)

```jldoctest
@StenoGraph begin
    # a and b are not declared anywhere but they act as `Node(:a)` & `Node(:b)`
    a → b
end

# output

a → b
```

The main downside is that you can not use regular variables inside the macro.
Had you declared `c = [Node(:a) Node(:b)]` outside the macro, inside it would nevertheless refer to `Node(:c)`.
You would need to escape it using [`_`](@ref), i.e. use it as `_(c)` within the macro.

## Let form (explicit declaration)

Alternatively, use a `let` block to explicitly declare which symbols become nodes.
All other symbols are treated as normal Julia variables — no escaping needed.
The node bindings are scoped and do not leak into the surrounding namespace.

```julia
@StenoGraph let a, b, c
    a → b → c
end

external = [Node(:y), Node(:z)]
@StenoGraph let a, b, c
    a → b
    c → external
end
```

## Let form with splat (from node collections)

Use `...` to expose all nodes from an existing collection as local variables.
Node names are extracted via [`id`](@ref). Supports multiple collections and mixing
with inline declarations.

```julia
nodes = [Node(:a), Node(:b)]
@StenoGraph let nodes...
    a → b
end
```

See also [`@declare_nodes`](@ref) & [`@declare_nodes_from`](@ref) for alternatives to escaping.

"""
macro StenoGraph(ex)
    StenoGraph_macro(ex, __module__)
end

"""
    StenoGraph(x::Vector{ <: Arrow})

Takes a vector of arrows and turns it into a vector of edges.
"""
StenoGraph(x::Vector{ <: Union{Arrow, AbstractEdge}}) = meld(vcat(unarrow.(x)...))
StenoGraph(x::Arrow...) = StenoGraph(vcat(x...))


function declare_nodes(exs::Symbol...) 
    out = [] 
    for var in exs 
        node = Expr(:call, SimpleNode, QuoteNode(var)) 
        push!(out, Expr(Symbol("="), var, node)) 
    end 
    Expr(:block, out..., nothing) 
end

"""
    @declare_nodes <node names>

Is a very handy macro to save you from typing out every node you want to use.

```jldoctest
@declare_nodes a b c

# output

```

is equivalent to:

```jldoctest
a = Node(:a)
b = Node(:b)
c = Node(:c)

# output

c
```

Please note that if you defined `c` and then use `@declare_nodes c`, `c` will be overwritten!

For programmatic use see also [`@declare_nodes_from`](@ref).
"""
macro declare_nodes(syms...)
    esc(declare_nodes(syms...))
end
 
# Function to declare nodes from a vector of symbols at runtime.
"""
    @declare_nodes_from <x::Vector{Symbol}>

Macro to declare nodes from a vector of symbols at runtime.
This comes in handy if you can create your nodes programatically.


```jldoctest
nodes = Symbol.('a':'e')

@declare_nodes_from nodes
e

# output

e
```

is equivalent to:

```jldoctest
a = Node(:a)
# ...
e = Node(:e)

# output

e
```

Please note that if you defined `c` and then use `@declare_nodes vec`, and `vec` contains `c`, `c` will be overwritten!

For non-programatic use see also [`@declare_nodes`](@ref).
"""
macro declare_nodes_from(syms)
    esc(quote
        for sym in $(syms)
            eval_expr = Expr(Symbol("="), sym, :(SimpleNode($(QuoteNode(sym)))))
            Base.invokelatest(eval, eval_expr)
        end
    end)
end
