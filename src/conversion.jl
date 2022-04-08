emptymoddict(::Type{T}) where {T <: Modifier} = Dict{Symbol, T}()
emptymoddict() = emptymoddict(Modifier)

ModifiedEdge(x) = ModifiedEdge(x, emptymoddict(EdgeModifier))
ModifiedNode(x) = ModifiedNode(x, emptymoddict(NodeModifier))
import Base.convert
convert(::Type{T}, x) where {T <: AbstractNode} = T(x)
convert(::Type{T}, x::Symbol) where {T <: AbstractNode} = SimpleNode(x)
# conversion of Nodes does not change anything
convert(::Type{T}, x::T) where {T <: AbstractNode} = x

import Base.promote_rule
# Symbols get promoted
promote_rule(::Type{T}, ::Type{Symbol}) where {T <: AbstractNode} = AbstractNode
promote_rule(::Type{T}, ::Type{Symbol}) where {T <: Node} = Node
