# Declaring and Using Nodes

```@meta
DocTestSetup = quote
    using StenoGraphs
end
```

There are several ways to declare nodes and use them in a `@StenoGraph`.
Which one fits best depends on whether your nodes are known at write-time
or computed at run-time, and whether you need to mix node variables with
ordinary Julia variables.

The table below gives a quick overview; the sections that follow explain
each approach in detail.

| Approach | Nodes known at … | Variables leak? | Escaping needed? |
|:---|:---|:---|:---|
| `@StenoGraph begin … end` | write-time | no (macro scope) | yes (`_()`) |
| `@StenoGraph let a, b; … end` | write-time | no (`let` scope) | no |
| `@StenoGraph let nodes…; … end` | run-time | no (`let` scope) | no |
| [`@declare_nodes`](@ref) | write-time | **yes** | n/a |
| [`@declare_nodes_from`](@ref) | run-time (Symbols or nodes) | **yes** | n/a |

## Block form — auto-quoting

The plain block form turns every bare symbol into a `SimpleNode`
automatically.
This is the most concise syntax when every symbol in the body is a node:

```@example nodes
using StenoGraphs # hide
@StenoGraph begin
    a → b → c
end
```

The downside is that *all* symbols are quoted.
If you need to refer to an ordinary Julia variable inside the block,
wrap it in the escape function `_( )`:

```@example nodes
target = [Node(:x), Node(:y)]
@StenoGraph begin
    a → _(target)
end
```

Without `_()`, `target` would be interpreted as `Node(:target)`.

## Let form — explicit declaration (inline)

The `let` form lists the symbols that should become nodes.
Everything else is treated as a normal Julia variable — no escaping
required.
The node bindings live in a `let` scope and do not leak into the
surrounding namespace.

```@example nodes
graph = @StenoGraph let a, b, c
    a → b → c
end
```

Because only the listed names become nodes, you can freely refer to
external variables:

```@example nodes
targets = [Node(:x), Node(:y)]
@StenoGraph let a
    a → targets          # targets is a regular variable — no _() needed
end
```

Scoping means the declared nodes do not pollute the enclosing namespace:

```@example nodes
@StenoGraph let secret_node_a, secret_node_b
    secret_node_a → secret_node_b
end
@isdefined(secret_node_a)   # false
```

## Let form — splat from collections

When nodes are created programmatically or come from an existing
collection, use the splat (`...`) syntax.
Each element of the collection is exposed as a local variable
whose name is determined by `id`:

```@example nodes
nodes = [Node(:a), Node(:b), Node(:c)]
@StenoGraph let nodes...
    a → b → c
end
```

### Multiple collections

You can splat several collections in one `let`:

```@example nodes
inputs  = [Node(:x1), Node(:x2)]
outputs = [Node(:y1), Node(:y2)]
@StenoGraph let inputs..., outputs...
    x1 → y1
    x2 → y2
end
```

### Mixing inline declarations and splats

Bare symbols and splats can be combined.
Listed symbols become fresh `SimpleNode`s; splatted collections are used
as-is:

```@example nodes
edges_nodes = [Node(:c), Node(:d)]
@StenoGraph let a, b, edges_nodes...
    a → c
    b → d
end
```

### External variables in splat form

The splat form evaluates its body at run-time, so external variables
that are visible at module scope can be used directly alongside the
splatted nodes:

```@example nodes
n1 = [Node(:a), Node(:b)]
n2 = [Node(:y), Node(:z)]
@StenoGraph let n1...
    a → b
    a → n2
end
```

### Preserving node modifiers

`convert(AbstractNode, node)` is used internally, so `ModifiedNode`s
keep their modifiers when splatted:

```@example nodes
struct Label <: NodeModifier; text::String; end
modified = [Node(:a)^Label("A"), Node(:b)]
result = @StenoGraph let modified...
    a → b
end
result[1].src   # a ModifiedNode with the Label
```

### Symbol vectors

A vector of plain `Symbol`s works too — each symbol is converted to a
`SimpleNode` automatically:

```@example nodes
names = [:p, :q]
@StenoGraph let names...
    p → q
end
```

### Duplicate ids

When the same id appears more than once (across collections or within
one), the **last** occurrence wins:

```@example nodes
struct Tag <: NodeModifier; t::String; end
dupes = [Node(:a), Node(:a)^Tag("latest"), Node(:b)]
result = @StenoGraph let dupes...
    a → b
end
result[1].src   # the tagged version
```

## `@declare_nodes` — top-level declaration

[`@declare_nodes`](@ref) creates `SimpleNode` bindings in the current
scope.
Unlike the `let` form, these bindings **do** persist after the macro
call:

```@example nodes
@declare_nodes x y z
x
```

This is handy for interactive use, but be aware that existing variables
with the same name will be overwritten.

## `@declare_nodes_from` — top-level declaration from a collection

[`@declare_nodes_from`](@ref) is the run-time counterpart.
It accepts any iterable of `Symbol`s, `AbstractNode`s, or a mix of both.
Each element is converted via `convert(AbstractNode, ...)` and bound to a
variable named by `id`. `ModifiedNode` wrappers are preserved.

```@example nodes
syms = Symbol.('a':'c')
@declare_nodes_from syms
a
```

It works equally well with a vector of nodes:

```@example nodes
struct Color <: NodeModifier; c::String; end
node_vec = [Node(:r)^Color("red"), Node(:g), Node(:b)]
@declare_nodes_from node_vec
r   # a ModifiedNode with the Color modifier
```

Symbols and nodes can even be mixed in one collection:

```@example nodes
mixed = Any[:u, Node(:v)]
@declare_nodes_from mixed
(u, v)
```

As with `@declare_nodes`, the bindings leak into the surrounding scope.

## Choosing the right approach

**Use the `let` form** when you want clean scoping and easy mixing of
nodes with regular Julia variables. Prefer the inline variant
(`let a, b`) for small, fixed sets of nodes and the splat variant
(`let nodes...`) when the node set is dynamic.

**Use the block form** (`@StenoGraph begin … end`) for quick one-off
graphs where every symbol is a node and you do not need external
variables.

**Use `@declare_nodes` / `@declare_nodes_from`** when you want the node
bindings to persist for later use outside of a single `@StenoGraph`
call.

## API Reference

```@docs
StenoGraphs.@StenoGraph
StenoGraphs.@declare_nodes
StenoGraphs.@declare_nodes_from
```
