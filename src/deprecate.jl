# use of Symbols as node is deprecated
src_dst_symbol_as_node = (:DirectedEdge, :UndirectedEdge)
for f in src_dst_symbol_as_node
    @eval @deprecate $f(src::Symbol, dst::Symbol) $f(Node(src), Node(dst))
end

dst_symbol_as_node = (:*, :^, src_dst_symbol_as_node...)
for f in dst_symbol_as_node
    @eval @deprecate $f(src, dst::Symbol) $f(src, Node(dst))
end

src_symbol_as_node = (:ModifyingNode, dst_symbol_as_node...)
for f in src_symbol_as_node
    @eval @deprecate $f(src::Symbol, dst) $f(Node(src), dst)
end

@deprecate keep(x::Symbol, y, z) keep(Node(x), y, z)
@deprecate keep(x::Symbol, y) keep(Node(x), y)
