edges = (:DirectedEdge, :UndirectedEdge)
for e in edges
    @eval $e(lhs::VecOrMat, rhs::VecOrMat) = vec([$e(l, r) for r in rhs, l in lhs])
    @eval $e(lhs::Node, rhs::VecOrMat) = vec(broadcast($e, (lhs,), rhs))
    @eval $e(lhs::VecOrMat, rhs::Node) = vec(broadcast($e, lhs, (rhs, )))
end