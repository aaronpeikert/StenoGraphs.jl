import Base.==
# do not fall back to === for edges
==(x::T, y::T) where T <: Edge = x == y
==(x::DirectedEdge, y::DirectedEdge) = keep(x, Dst) == keep(y, Dst) && keep(x, Src) == keep(y, Src)
function ==(x::UndirectedEdge, y::UndirectedEdge)
    (keep(x, Src) == keep(y, Src) && keep(x, Dst) == keep(y, Dst)) ||
    (keep(x, Src) == keep(y, Dst) && keep(x, Dst) == keep(y, Src))
end
==(x::ModifiedEdge, y::ModifiedEdge) = keep(x, Edge) == keep(y, Edge) && x.modifiers == y.modifiers

# there is no special compare method for SimpleNode, since Symbols are not mutable
==(x::ModifyingNode, y::ModifyingNode) = keep(x, Node) == keep(y, Node) && x.modifiers == y.modifiers
==(x::ModifiedNode, y::ModifiedNode) = keep(x, Node) == keep(y, Node) && x.modifiers == y.modifiers

==(x::VecOrMat{T}, y::VecOrMat{T}) where T <: Modifier = issetequal(x, y)

# compare arrows
==(x::T, y::T) where T <: Arrow = x.edges == y.edges && x.lhs == y.lhs && x.rhs == y.rhs

# required for sorting
import Base.isless
isless(x::AbstractNode, y::AbstractNode) = isless(id(x), id(y))

import Base.hash
hash(x::T, h::UInt) where {T <: UndirectedEdge} = hash(T, hash(sort([x.src, x.dst]), h))
hash(x::T, h::UInt) where {T <: ModifiedEdge} = hash(T, hash(x.edge, hash(x.modifiers, h)))
