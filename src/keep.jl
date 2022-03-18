abstract type Side end
struct Left <: Side end
struct Right <: Side end

abstract type SourceDestination end
struct Src <: SourceDestination end
struct Dst <: SourceDestination end

keep(x::VecOrMat, y) = keep.(x, Ref(y))
keep(x::VecOrMat, y, z) = keep.(x, Ref(y), Ref(z))

keep(x::AbstractNode, ::Type{T}) where {T <: Node} = keep(x.node, T)
keep(x::AbstractNode, ::Type{T}) where {T <: AbstractNode} = x
keep(x::Node, ::Type{T}) where {T <: Node} = x
keep(x::Node, ::Type{T}) where {T <: AbstractNode} = x

keep(x::Symbol, y, z) = keep(convert(AbstractNode, x), y, z)
keep(x::Symbol, y) = keep(convert(AbstractNode, x), y)

keep(x::AbstractEdge, ::Type{T}) where {T <: Edge} = keep(x.edge, T)
keep(x::AbstractEdge, ::Type{T}) where {T <: AbstractEdge} = keep(x.edge, T)
keep(x::Edge, ::Type{T}) where {T <: Edge} = x
keep(x::Edge, ::Type{T}) where {T <: AbstractEdge} = x

keep(x::AbstractEdge, ::Type{T}) where {T <: Src} = x.src
keep(x::AbstractEdge, ::Type{T}) where {T <: Dst} = x.dst

keep(x::Arrow, ::Type{T}) where {T <: AbstractEdge} = x.edges
keep(x::Arrow, ::Type{T}) where {T <: Edge} = keep(x.edges, T)

keep(x::Arrow, ::Type{T}) where {T <: Left} = x.lhs
keep(x::Arrow, ::Type{T}) where {T <: Right} = x.rhs

function keep(x::AbstractNode, ::Type{T1}, ::Type{T2}) where {T1 <: Union{Side, SourceDestination}, T2 <: AbstractNode}
    keep(x, T2)
end

function keep(x::Arrow, ::Type{T1}, ::Type{T2}) where {T1 <: Union{Side, SourceDestination}, T2 <: AbstractNode}
    keep(keep(x, T1), T2)
end

keep(x::Arrow, ::Type{T}) where {T <: Src} = keep(x.edges, T)
keep(x::Arrow, ::Type{T}) where {T <: Dst} = keep(x.edges, T)

keep(x::Arrow, _) = x

unmeta(x::AbstractEdge) = keep(x, Edge)
unmeta(x::AbstractNode) = keep(x, Node)

unarrow(x) = keep(x, AbstractEdge)
