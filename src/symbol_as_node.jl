# both src or dst may be a Symbol that should be treated as Node
# only possible for function we own
src_dst_symbol_as_node = (:DirectedEdge, :UndirectedEdge, :→, :←, :↔)
for f in src_dst_symbol_as_node
    @eval $f(src::Symbol, dst::Symbol) = $f(Node(src), Node(dst))
end

# either dst or src Symbol should be treated as Node (both is possibly type piracy)
dst_symbol_as_node = (:*, src_dst_symbol_as_node...)
for f in dst_symbol_as_node
    @eval $f(src, dst::Symbol) = $f(src, Node(dst))
end

# src may be a Symbol that should be treated as Node
src_symbol_as_node = (:ModifyingNode, dst_symbol_as_node...)
for f in src_symbol_as_node
    @eval $f(src::Symbol, dst) = $f(Node(src), dst)
end

import Base.convert
# implicitly defines conversion for Symbols
convert(::Type{T}, x) where {T <: Node} = T(x)
# conversion of Nodes does not change anything
convert(::Type{T}, x::T) where {T <: Node} = x

import Base.promote_rule
# Symbols get promoted
promote_rule(::Type{T}, ::Type{Symbol}) where {T <: Node} = Node
