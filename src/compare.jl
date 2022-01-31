import Base.==
# do not fall back to === for edges
==(x::T, y::T) where T <: Edge = x == y
==(x::DirectedEdge, y::DirectedEdge) = x.rhs == y.rhs && x.lhs == y.lhs
==(x::UndirectedEdge, y::UndirectedEdge) = issetequal([x.lhs x.rhs], [y.lhs y.rhs])
==(x::ModifiedEdge, y::ModifiedEdge) = x.edge == y.edge && x.modifiers == y.modifiers

# there is no special compare method for SimpleNode, since Symbols are not mutable
==(x::ModifyingNode, y::ModifyingNode) = x.node == y.node && x.modifiers == y.modifiers

==(x::VecOrMat{T}, y::VecOrMat{T}) where T <: Modifier = issetequal(x, y)
