import Base.Pair
Pair(x::Modifier) = Pair(nameof(typeof(x)), x)

function moddict(x::Modifier)
    Dict{Symbol, Modifier}(Pair(x))
end

function moddict(x::Vector{M} where {M <: Modifier})
    Dict{Symbol, Modifier}(Pair.(x)...)
end

moddict(x::Dict{Symbol, Modifier}) = x

ModifiedEdge(edge::ModifiedEdge, modifier::Modifier) = ModifiedEdge(edge.edge, merge(edge.modifiers, moddict(modifier)))    
ModifyingNode(node::ModifyingNode, modifier::Modifier) = ModifyingNode(node.node, merge(node.modifiers, moddict(modifier)))

ModifiedEdge(edge::ModifiedEdge, modifier::VecOrMat{M} where {M <: Modifier}) = ModifiedEdge(edge.edge, merge(edge.modifiers, moddict(vec(modifier))))    
ModifyingNode(node::ModifyingNode, modifier::VecOrMat{M} where {M <: Modifier}) = ModifyingNode(node.node, merge(node.modifiers, moddict(vec(modifier))))

ModifiedEdge(edge::Edge, modifier::Modifier) = ModifiedEdge(edge, moddict(modifier))
ModifyingNode(node::Node, modifier::Modifier) = ModifyingNode(node, moddict(modifier))

ModifiedEdge(edge::Edge, modifier::VecOrMat{M} where {M <: Modifier}) = ModifiedEdge(edge, moddict(vec(modifier)))
ModifyingNode(node::Node, modifier::VecOrMat{M} where {M <: Modifier}) = ModifyingNode(node, moddict(vec(modifier)))

ModifiedEdge(edge::Arrow, modifier) = Arrow(ModifiedEdge.(unarrow(edge), Ref(modifier)), edge.lhs, edge.rhs)

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
    @eval $e(src::ModifyingNode, dst::ModifyingNode) = ModifiedEdge($e(src.node, dst.node), merge(src.modifiers, dst.modifiers))
end
