function StenoGraph_macro(ex)
    if ex.head == :block
        exs = filter(x -> !isa(x, LineNumberNode), ex.args)
        exs = StenoGraphs.variable_as_node!.(exs)
        exs = StenoGraphs.addition_to_vector!.(exs)
        vec = Expr(:call, :vcat, exs...)
        return esc(:(StenoGraphs.StenoGraph($vec)))
    else
        StenoGraph_macro(Expr(:block, ex))
    end
end
"""
    @StenoGraph

The `@StenoGraph` macro allows you to refer to nodes without explicitly declaring them.

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

See also [`@declage_nodes`](@ref) & [`@declage_nodes_from`](@ref) for alternatives to escaping.

"""
macro StenoGraph(ex)
    StenoGraph_macro(ex)
end

"""
    StenoGraph(x::Vector{ <: Arrow})

Takes a vector of arrows and turns it into a vector of edges.
"""
StenoGraph(x::Vector{ <: Arrow}) = meld(vcat(unarrow.(x)...))
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
    @declare_nodes(x::Vector{ <: Arrow})

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

Please note that if you defined `c` and then use `@declase_nodes c`, `c` will be overwritten!

For programmatic use see also [`@declare_nodes_from`](@ref).
"""
macro declare_nodes(syms...)
    esc(declare_nodes(syms...))
end
 
# Function to declare nodes from a vector of symbols at runtime.
"""
    @declare_nodes(x::Vector{ <: Arrow})

Macro to declare nodes from a vector of symbols at runtime.
This comes in handy if you can create your nodes programatically.


```jldoctest
nodes = Symbol.('a':'e')

@declare_nodes_from(nodes)
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

Please note that if you defined `c` and then use `@declase_nodes c`, `c` will be overwritten!

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
