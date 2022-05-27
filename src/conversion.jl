emptymoddict(::Type{T}) where {T <: Modifier} = Dict{Symbol, T}()
emptymoddict() = emptymoddict(Modifier)

ModifiedEdge(x) = ModifiedEdge(x, emptymoddict(EdgeModifier))
ModifiedNode(x) = ModifiedNode(x, emptymoddict(NodeModifier))
ModifyingNode(x) = ModifyingNode(x, emptymoddict(EdgeModifier))
Arrow(x) = Arrow(x, nothing, nothing)

import Base.convert
convert(::Type{T}, x) where {T <: AbstractNode} = T(x)
convert(::Type{T}, x::Symbol) where {T <: AbstractNode} = SimpleNode(x)
convert(::Type{ <: ModifiedEdge}, x::Edge) = ModifiedEdge(x)
convert(::Type{ <: Arrow}, x::Edge) = Arrow([x])
convert(::Type{ <: ModifiedNode}, x::Node) = ModifiedNode(x)
convert(::Type{ <: ModifyingNode}, x::Node) = ModifyingNode(x)

# conversion of Nodes does not change anything
convert(::Type{T}, x::T) where {T <: AbstractNode} = x

import Base.promote_rule
# Symbols get promoted
promote_rule(::Type{T}, ::Type{Symbol}) where {T <: AbstractNode} = AbstractNode
promote_rule(::Type{T}, ::Type{Symbol}) where {T <: Node} = Node
promote_rule(::Type{ <: Edge}, ::Type{T}) where {T <: MetaEdge} = T
promote_rule(::Type{ <: Node}, ::Type{T}) where {T <: MetaNode} = T
promote_rule(::Type{ <: Edge}, ::Type{T}) where {T <: ModifiedEdge} = ModifiedEdge
