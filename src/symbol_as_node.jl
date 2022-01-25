# both lhs or rhs may be a Symbol that should be treated as Node
# only possible for function we own
lhs_rhs_symbol_as_node = (:DirectedEdge, :UndirectedEdge)
for f in lhs_rhs_symbol_as_node
    @eval $f(lhs::Symbol, rhs::Symbol) = $f(Node(lhs), Node(rhs))
end

# either rhs or lhs Symbol should be treated as Node, both is possibly type piracy
rhs_symbol_as_node = (:*, lhs_rhs_symbol_as_node...)
for f in rhs_symbol_as_node
    @eval $f(lhs, rhs::Symbol) = $f(lhs, Node(rhs))
end

# lhs may be a Symbol that should be treated as Node
lhs_symbol_as_node = (:ModifyingNode, rhs_symbol_as_node...)
for f in lhs_symbol_as_node
    @eval $f(lhs::Symbol, rhs) = $f(Node(lhs), rhs)
end
