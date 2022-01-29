import Base.*

@communative function *(lhs::Edge, rhs::Modifier)
    ModifiedEdge(lhs, rhs)
end

@communative function *(rhs::Edge, lhs::VecOrMat{M} where {M<:Modifier})
    ModifiedEdge(rhs, vec(lhs))
end

@communative function *(lhs::Node, rhs::Modifier)
    ModifyingNode(lhs, rhs)
end

@communative function *(rhs::Node, lhs::VecOrMat{M} where {M<:Modifier})
    ModifyingNode(rhs, vec(lhs))
end

function *(lhs::Modifier, rhs::Modifier)
    vec([lhs rhs])
end

function *(lhs::VecOrMat{M} where {M<:Modifier}, rhs::VecOrMat{M} where {M<:Modifier})
    vec([vec(lhs)... vec(rhs)...])
end


# Edge(:a, :b) ≠ Edge(:b, :a) 
# not communative


edges = (:DirectedEdge, :UndirectedEdge)
for e in edges
    @eval $e(lhs::Node, rhs::ModifyingNode) = ModifiedEdge($e(lhs, rhs.node), rhs.modifiers)
    @eval $e(lhs::ModifyingNode, rhs::Node) = ModifiedEdge($e(lhs.node, rhs), lhs.modifiers)
    @eval $e(lhs::ModifyingNode, rhs::ModifyingNode) = ModifiedEdge($e(lhs.node, rhs.node), [lhs.modifiers..., rhs.modifiers...])
end
