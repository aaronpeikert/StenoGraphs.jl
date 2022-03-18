import Base.==
# do not fall back to === for edges
==(x::T, y::T) where T <: Edge = x == y
==(x::DirectedEdge, y::DirectedEdge) = x.dst == y.dst && x.src == y.src
==(x::UndirectedEdge, y::UndirectedEdge) = issetequal([x.src x.dst], [y.src y.dst])
==(x::ModifiedEdge, y::ModifiedEdge) = x.edge == y.edge && x.modifiers == y.modifiers

# there is no special compare method for SimpleNode, since Symbols are not mutable
==(x::ModifyingNode, y::ModifyingNode) = x.node == y.node && x.modifiers == y.modifiers
==(x::ModifiedNode, y::ModifiedNode) = x.node == y.node && x.modifiers == y.modifiers

==(x::VecOrMat{T}, y::VecOrMat{T}) where T <: Modifier = issetequal(x, y)

# compare arrows
==(x::T, y::T) where T <: Arrow = x.edges == y.edges && x.lhs == y.lhs && x.rhs == y.rhs

# required for sorting
import Base.isless
isless(x::SimpleNode, y::SimpleNode) = isless(x.node, y.node)

import Base.hash
hash(x::T, h::UInt) where {T <: UndirectedEdge} = hash(T, hash(sort([x.src, x.dst]), h))
hash(x::T, h::UInt) where {T <: ModifiedEdge} = hash(T, hash(x.edge, hash(x.modifiers, h)))
