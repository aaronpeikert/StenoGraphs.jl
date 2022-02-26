import Base.==
# do not fall back to === for edges
==(x::T, y::T) where T <: Edge = x == y
==(x::DirectedEdge, y::DirectedEdge) = x.dst == y.dst && x.src == y.src
==(x::UndirectedEdge, y::UndirectedEdge) = issetequal([x.src x.dst], [y.src y.dst])
==(x::ModifiedEdge, y::ModifiedEdge) = x.edge == y.edge && x.modifiers == y.modifiers

# there is no special compare method for SimpleNode, since Symbols are not mutable
==(x::ModifyingNode, y::ModifyingNode) = x.node == y.node && x.modifiers == y.modifiers

==(x::VecOrMat{T}, y::VecOrMat{T}) where T <: Modifier = issetequal(x, y)
