edges = (:DirectedEdge, :UndirectedEdge, :→, :←, :↔)
for e in edges
    @eval $e(src::VecOrMat, dst::VecOrMat) = vec([$e(l, r) for r in dst, l in src])
    @eval $e(src::Node, dst::VecOrMat) = vec(broadcast($e, (src,), dst))
    @eval $e(src::VecOrMat, dst::Node) = vec(broadcast($e, src, (dst, )))
end
