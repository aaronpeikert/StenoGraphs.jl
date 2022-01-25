# both lhs or rhs may be a Symbol that should be treated as Node
# only possible for function we own
lhs_rhs_symbol_as_node = (:DirectedEdge, :UndirectedEdge)
for f in lhs_rhs_symbol_as_node
    @eval $f(lhs::Symbol, rhs::Symbol) = $f(Node(lhs), Node(rhs))
end

# either rhs or lhs Symbol should be treated as Node (both is possibly type piracy)
rhs_symbol_as_node = (:*, lhs_rhs_symbol_as_node...)
for f in rhs_symbol_as_node
    @eval $f(lhs, rhs::Symbol) = $f(lhs, Node(rhs))
end

# lhs may be a Symbol that should be treated as Node
lhs_symbol_as_node = (:ModifyingNode, rhs_symbol_as_node...)
for f in lhs_symbol_as_node
    @eval $f(lhs::Symbol, rhs) = $f(Node(lhs), rhs)
end

import Base.convert
# implicitly defines conversion for Symbols
convert(::Type{T}, x) where {T <: Node} = T(x)
# conversion of Nodes does not change anything
convert(::Type{T}, x::T) where {T <: Node} = x

import Base.promote_rule
# Symbols get promoted
promote_rule(::Type{T}, ::Type{Symbol}) where {T <: Node} = T
