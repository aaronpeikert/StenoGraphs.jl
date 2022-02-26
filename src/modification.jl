import Base.*

@communative function *(src::Edge, dst::Modifier)
    ModifiedEdge(src, dst)
end

@communative function *(dst::Edge, src::VecOrMat{M} where {M<:Modifier})
    ModifiedEdge(dst, vec(src))
end

@communative function *(src::Node, dst::Modifier)
    ModifyingNode(src, dst)
end

@communative function *(dst::Node, src::VecOrMat{M} where {M<:Modifier})
    ModifyingNode(dst, vec(src))
end

function *(src::Modifier, dst::Modifier)
    vec([src dst])
end

function *(src::VecOrMat{M} where {M<:Modifier}, dst::VecOrMat{M} where {M<:Modifier})
    vec([vec(src)... vec(dst)...])
end


# Edge(:a, :b) ≠ Edge(:b, :a) 
# not communative


edges = (:DirectedEdge, :UndirectedEdge)
for e in edges
    @eval $e(src::Node, dst::ModifyingNode) = ModifiedEdge($e(src, dst.node), dst.modifiers)
    @eval $e(src::ModifyingNode, dst::Node) = ModifiedEdge($e(src.node, dst), src.modifiers)
    @eval $e(src::ModifyingNode, dst::ModifyingNode) = ModifiedEdge($e(src.node, dst.node), [src.modifiers..., dst.modifiers...])
end
