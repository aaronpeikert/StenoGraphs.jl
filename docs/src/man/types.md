# Types

At the top of the type hierachy we have [`AbstractEdge`](@ref)s and [`AbstractNode`](@ref)s.
These are pretty abstract in the sense that they capture anything that might somehow be interpreted as an edge or node.
More concrete (but still not concrete concrete) are [`Edge`](@ref) and [`Node`](@ref).

```@docs
AbstractNode
AbstractEdge
```

## Edge/Node

Edge and Node are still not concrete but have fields of reliable types to interface with.

`StenoGraphs` implements [`DirectedEdge`](@ref) and [`UndirectedEdge`](@ref)  as concrete subtypes of [`Edge`](@ref) as well as [`SimpleNode`](@ref) as concrete subtype of [`Node`](@ref).

```@docs
Node
Edge
```

## SimpleNode/UndirectedEdge/DirectedEdge

These are the concrete [`Node`](@ref) and [`Edge`](@ref) types implemented by `StenoGraphs`.

```@docs
StenoGraphs.SimpleNode
DirectedEdge
UndirectedEdge
```

## MetaEdge/MetaNode

These types store a node/edge alongside metadata.

```@docs
MetaNode
MetaEdge
```

## Modified Nodes and Edges

These concrete types store a node/edge alongside modifiers (either [`NodeModifier`](@ref)s or [`EdgeModifier`](@ref)s) as metadata.

```@docs
ModifiedNode
ModifyingNode
ModifiedEdge
```

## Modifiers

```@docs
Modifier
NodeModifier
EdgeModifier
```