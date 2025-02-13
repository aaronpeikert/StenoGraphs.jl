"""
    AbstractNode

At the top of the type hierarchy of `StenoGraphs`.
Anything that might resemble a node.
"""
abstract type AbstractNode end

Base.length(::AbstractNode) = 1

"""
    Node

Subtype of [`AbstractNode`](@ref).
Any subtype of `Node` must have the field `node` (and no other) that uniquily identifies the node.
"""
abstract type Node <: AbstractNode end

"""
    MetaNode

Subtype of [`AbstractNode`](@ref).
Any subtype of `MetaNode` must have a field `node` of subtype [`Node`](@ref), but may have any number of other fields containing metadata.
"""
abstract type MetaNode <: AbstractNode end

"""
    SimpleNode

Constructs a subtype of [`Node`](@ref) with a symbol as identifier.

# Example

```jldoctest
julia> SimpleNode(:a)
a
```
"""
struct SimpleNode{T <: Symbol} <: Node
    node::T
end

"""
    Node(node)

Calls either [`SimpleNode`](@ref) or [`IntNode`](@ref).

# Example

```jldoctest
julia> Node(:a)
a
julia> Node(1)
1
```
"""
Node(node) = SimpleNode(node)
Node(node::Int) = IntNode(node)

"""
    AbstractEdge

At the top of the type hierarchy of `StenoGraphs`.
Anything that might resemble an edge.
"""
abstract type AbstractEdge end

"""
    Edge

Subtype of [`AbstractEdge`](@ref).
Any subtype of `Edge` must have the fields `src` and `dst` (and no other), which must be a subtype of [`AbstractNode`](@ref).
Any implementation might be stricter about typing.
"""
abstract type Edge <: AbstractEdge end

"""
    MetaEdge

Subtype of [`AbstractEdge`](@ref).
Any subtype of `MetaEdge` must have a field `edge` of subtype [`Edge`](@ref), but may have any number of other fields containing metadata.
"""
abstract type MetaEdge <: AbstractEdge end

"""
    Edge(src, dst)

Alias for [`DirectedEdge`](@ref).

# Example

```jldoctest
julia> Edge(Node(:a), Node(:b))
a → b
```

"""
Edge(src, dst) = DirectedEdge(src, dst)


"""
    DirectedEdge(src, dst)

Subtype of [`Edge`](@ref).
Directed edge from `src` to `dst`.

# Example

```jldoctest
julia> DirectedEdge(Node(:a), Node(:b))
a → b
```
"""
struct DirectedEdge{T1 <: AbstractNode, T2 <: AbstractNode} <: Edge
    src::T1
    dst::T2
end

"""
    UndirectedEdge(src, dst)

Subtype of [`Edge`](@ref).
Undirected edge from `src` to `dst`. What is what does not matter.

# Example
```jldoctest
julia> e1 = UndirectedEdge(Node(:a), Node(:b))
a ↔ b

julia> e2 = UndirectedEdge(Node(:b), Node(:a))
b ↔ a

julia> isequal(e1, e2)
true

julia> unique([e1, e2])
a ↔ b
```
"""
struct UndirectedEdge{T1 <: AbstractNode, T2 <: AbstractNode} <: Edge
    src::T1
    dst::T2
end

"""
    Modifier

The abstract type that powers EdgeModifier and NodeModifier.
`StenoGraphs` does not implement any concrete modifiers.

"""
abstract type Modifier end


"""
    EdgeModifier

Subtype of [`Modifier`](@ref).
[`ModifiedEdge`](@ref)s require `EdgeModifier`s.
`EdgeModifier`s usually make use of `*` for creating [`ModifiedEdge`](@ref)s/[`ModifyingNode`](@ref)s.
One special application for `EdgeModifier`s is the creation of [`ModifyingNode`](@ref)s.
Since `StenoGraphs` does not implement any `EdgeModifier` users must implement them.
If these are not atomic they must take care to implement comparison methods (see examples in [`NodeModifier`](@ref))

# Example

```jldoctest
# `StenoGraphs` does not implement any `EdgeModifier`s
julia> struct Weight{N <: Number} <: EdgeModifier w::N end

julia> ModifiedEdge(Edge(Node(:a), Node(:b)), Weight(.5)) == # directly create ModifiedEdge
        Edge(Node(:a), Node(:b)) * Weight(.5) == # modify an edge
        Edge(Node(:a), Node(:b) * Weight(.5)) # modify Edge through a ModifyingNode
true

```
"""
abstract type EdgeModifier <: Modifier end

"""
    NodeModifier

Subtype of [`Modifier`](@ref).
[`ModifiedNode`](@ref)s require `NodeModifier`s.
`NodeModifier`s usually make use of `^` for creating [`ModifiedNode`](@ref)s.
Since `StenoGraphs` does not implement any `NodeModifier` users must implement them.
If these may contain any mutable fields (i.e. strings, vectors, arrays, etc.) users must take care to implement comparison methods.

# Example

```jldoctest
# `StenoGraphs` does not implement any `NodeModifier`s
julia> struct Label <: NodeModifier l end

julia> import Base.==

julia> ==(x::Label, y::Label) = x.l == y.l;

julia> ModifiedNode(Node(:a), Label("hi")) == Node(:a)^Label("hi")
true

```
"""
abstract type NodeModifier <: Modifier end
const NodeOrEdgeModifier = Union{EdgeModifier,NodeModifier}

"""
    ModifiedEdge

Subtype of [`MetaEdge`](@ref) that contains two fields (`edge` and `modifiers`).
`modifiers` is a `Dict{Symbol, EdgeModifier}` where the keys are `nameof(typeof(EdgeModifier))`.
Modifiying an edge with several modifiers of the same type will therefore overwrite old modifiers.
A `ModifiedEdge` is created by modifying an edge directly (with `*`) or via [`ModifyingNode`](@ref)s where a node is modified that than modifies the edge.

# Example
```jldoctest
julia> struct Weight{N <: Number} <: EdgeModifier w::N end

julia> struct Start{N <: Number} <: EdgeModifier s::N end

julia> ModifiedEdge(Edge(Node(:a), Node(:b)), Weight(3))
a → b * Weight{Int64}(3)

julia> ModifiedEdge(Edge(Node(:a), Node(:b)), Weight(3)) == Edge(Node(:a), Node(:b)) * Weight(3)
true

julia> ModifiedEdge(Edge(Node(:a), Node(:b)), [Weight(3), Start(2)])
a → b * [Start{Int64}(2), Weight{Int64}(3)]

julia> @StenoGraph a → b * Weight(3) * Start(2)
a → b * [Start{Int64}(2), Weight{Int64}(3)]

julia> @StenoGraph a → b * Weight(3) * Start(2) * Weight(2)
a → b * [Start{Int64}(2), Weight{Int64}(2)]
```
"""
struct ModifiedEdge{E <: AbstractEdge, DM <: AbstractDict{S, M} where {S <: Symbol, M <: EdgeModifier}} <: MetaEdge
    edge::E
    modifiers::DM
end

"""
    ModifyingNode

Subtype of [`MetaNode`](@ref) that contains two fields (`node` and `modifiers`).
`modifiers` is a `Dict{Symbol, EdgeModifier}` where the keys are `nameof(typeof(EdgeModifier))`.
Modifiying an node with several modifiers of the same type will therefore overwrite old modifiers.
A `ModifyingNode` is created by multiplying it (`*`) with an *`EdgeModifier`* since it will modify edges build upon it.
If you want to modify the node use `^` and see [`ModifiedNode`](@ref).

# Example
```jldoctest
julia> struct Weight{N <: Number} <: EdgeModifier w::N end

julia> struct Start{N <: Number} <: EdgeModifier s::N end

julia> @StenoGraph a → b * Weight(3) * Start(2)
a → b * [Start{Int64}(2), Weight{Int64}(3)]

julia> @StenoGraph a → b * Weight(3) * Start(2) * Weight(2)
a → b * [Start{Int64}(2), Weight{Int64}(2)]
```
"""
struct ModifyingNode{N <: AbstractNode, DM <: AbstractDict{S, M} where {S <: Symbol, M <: EdgeModifier}} <: MetaNode
    node::N
    modifiers::DM
end

"""
    ModifiedNode

Subtype of [`MetaNode`](@ref) that contains two fields (`node` and `modifiers`).
`modifiers` is a `Dict{Symbol, NodeModifier}` where the keys are `nameof(typeof(NodeModifier))`.
Modifiying a node with several modifiers of the same type will therefore overwrite old modifiers.

# Example

```jldoctest
julia> struct Observed <: NodeModifier end

julia> struct Label{N <: String} <: NodeModifier s::N end

julia> Node(:b) ^ Label("some label") ^ Observed()
b^[Observed(), Label{String}("some label")]

julia> Node(:b) ^ Label("some label") ^ Observed() ^ Label("some other label")
b^[Observed(), Label{String}("some other label")]
```
"""
struct ModifiedNode{N <: AbstractNode, DM <: AbstractDict{S, M} where {S <: Symbol, M <: NodeModifier}} <: MetaNode
    node::N
    modifiers::DM
end

struct Arrow{VE <: Vector{E} where {E <: AbstractEdge}} <: MetaEdge
    edges::VE
    lhs
    rhs
end

"""
IntNode(x::Int)

Constructs a subtype of [`Node`](@ref) with an integer as identifier.

See also [`SimpleNode`](@ref).

# Example

```jldoctest
julia> StenoGraphs.IntNode(1)
1
```

"""
struct IntNode{T<:Int} <: Node
    node::T
end