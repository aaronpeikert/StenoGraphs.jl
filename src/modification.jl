ModifiedEdge(edge::ModifiedEdge, modifier::Modifier) = ModifiedEdge(edge.edge, [edge.modifiers..., modifier])    
ModifyingNode(node::ModifyingNode, modifier::Modifier) = ModifyingNode(node.node, [node.modifiers..., modifier])

ModifiedEdge(edge::ModifiedEdge, modifier::Matrix{M} where {M <: Modifier}) = ModifiedEdge(edge.edge, [edge.modifiers..., modifier...])    
ModifyingNode(node::ModifyingNode, modifier::Matrix{M} where {M <: Modifier}) = ModifyingNode(node.node, [node.modifiers..., modifier...])

ModifiedEdge(edge::ModifiedEdge, modifier::Vector{M} where {M <: Modifier}) = ModifiedEdge(edge.edge, [edge.modifiers..., modifier...])    
ModifyingNode(node::ModifyingNode, modifier::Vector{M} where {M <: Modifier}) = ModifyingNode(node.node, [node.modifiers..., modifier...])

ModifiedEdge(edge::Edge, modifier::Modifier) = ModifiedEdge(edge, [modifier])
ModifyingNode(node::Node, modifier::Modifier) = ModifyingNode(node, [modifier])

ModifiedEdge(edge::Edge, modifier::Matrix{M} where {M <: Modifier}) = ModifiedEdge(edge, vec(modifier))
ModifyingNode(node::Node, modifier::Matrix{M} where {M <: Modifier}) = ModifyingNode(node, vec(modifier))

import Base.*

@communative function *(src::AbstractEdge, dst::Modifier)
    ModifiedEdge(src, dst)
end

@communative function *(dst::AbstractEdge, src::VecOrMat{M} where {M<:Modifier})
    ModifiedEdge(dst, vec(src))
end

@communative function *(src::AbstractNode, dst::Modifier)
    ModifyingNode(src, dst)
end

@communative function *(dst::AbstractNode, src::VecOrMat{M} where {M<:Modifier})
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
    @eval $e(src::AbstractNode, dst::ModifyingNode) = ModifiedEdge($e(src, dst.node), dst.modifiers)
    @eval $e(src::ModifyingNode, dst::AbstractNode) = ModifiedEdge($e(src.node, dst), src.modifiers)
    @eval $e(src::ModifyingNode, dst::ModifyingNode) = ModifiedEdge($e(src.node, dst.node), [src.modifiers..., dst.modifiers...])
end
