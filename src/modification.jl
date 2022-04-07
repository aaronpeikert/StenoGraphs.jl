import Base.Pair
Pair(x::Modifier) = Pair{Symbol, Modifier}(nameof(typeof(x)), x)
Pair(x::NodeModifier) = Pair{Symbol, NodeModifier}(nameof(typeof(x)), x)
Pair(x::EdgeModifier) = Pair{Symbol, EdgeModifier}(nameof(typeof(x)), x)


function moddict(x::Modifier)
    Dict(Pair(x))
end

function moddict(x::Vector{M} where {M <: Modifier})
    Dict(Pair.(x)...)
end

moddict(x::Dict{Symbol, Modifier}) = x

modifiers(x) = x.modifiers

ModifiedEdge(edge::ModifiedEdge, modifier::EdgeModifier) = ModifiedEdge(edge.edge, merge(modifiers(edge), moddict(modifier)))    
ModifyingNode(node::ModifyingNode, modifier::EdgeModifier) = ModifyingNode(node.node, merge(modifiers(node), moddict(modifier)))
ModifiedNode(node::ModifiedNode, modifier::NodeModifier) = ModifiedNode(node.node, merge(modifiers(node), moddict(modifier)))

ModifiedEdge(edge::ModifiedEdge, modifier::VecOrMat{M} where {M <: EdgeModifier}) = ModifiedEdge(edge.edge, merge(modifiers(edge), moddict(vec(modifier))))    
ModifyingNode(node::ModifyingNode, modifier::VecOrMat{M} where {M <: EdgeModifier}) = ModifyingNode(node.node, merge(modifiers(node), moddict(vec(modifier))))
ModifiedNode(node::ModifyingNode, modifier::VecOrMat{M} where {M <: NodeModifier}) = ModifiedNode(node.node, merge(modifiers(node), moddict(vec(modifier))))

ModifiedEdge(edge::Edge, modifier::EdgeModifier) = ModifiedEdge(edge, moddict(modifier))
ModifyingNode(node::Node, modifier::EdgeModifier) = ModifyingNode(node, moddict(modifier))
ModifiedNode(node::Node, modifier::NodeModifier) = ModifiedNode(node, moddict(modifier))

ModifiedEdge(edge::Edge, modifier::VecOrMat{M} where {M <: EdgeModifier}) = ModifiedEdge(edge, moddict(vec(modifier)))
ModifyingNode(node::Node, modifier::VecOrMat{M} where {M <: EdgeModifier}) = ModifyingNode(node, moddict(vec(modifier)))
ModifiedNode(node::Node, modifier::VecOrMat{M} where {M <: NodeModifier}) = ModifiedNode(node, moddict(vec(modifier)))

ModifiedEdge(edge::Arrow, modifier) = Arrow(ModifiedEdge.(unarrow(edge), Ref(modifier)), edge.lhs, edge.rhs)
import Base.*

@communative function *(x::AbstractEdge, y)
    ModifiedEdge(x, y)
end

@communative function *(x::AbstractEdge, y::VecOrMat{T} where T) 
    ModifiedEdge(x, vec(y))
end

@communative function *(y::AbstractNode, x::EdgeModifier)
    ModifyingNode(y, x)
end

@communative function *(y::AbstractNode, x::NodeModifier)
    ModifiedNode(y, x)
end

@communative function *(x::AbstractNode, y::VecOrMat{T} where T) 
    ModifyingNode(x, vec(y))
end

function *(y::EdgeModifier, x::EdgeModifier)
    vec([y x])
end

@communative function *(y::EdgeModifier, x::VecOrMat{T} where {T <: EdgeModifier})
    vec([y x...])
end

function *(y::VecOrMat{M1} where {M1<:EdgeModifier}, x::VecOrMat{M2} where {M2<:EdgeModifier})
    vec([vec(y)... vec(x)...])
end

import Base.^

@communative function ^(x::AbstractNode, y::NodeModifier)
    ModifiedNode(x, y)
end

@communative function ^(x::AbstractNode, y::VecOrMat{T} where T)
    ModifiedNode(x, vec(y))
end

@communative function ^(y::NodeModifier, x::VecOrMat{T} where {T <: NodeModifier})
    vec([y x...])
end

function ^(y::NodeModifier, x::NodeModifier)
    vec([y x])
end

function ^(y::VecOrMat{M1} where {M1<:NodeModifier}, x::VecOrMat{M2} where {M2<:NodeModifier})
    vec([vec(y)... vec(x)...])
end


# Edge(Node(:a), Node(:b)) ≠ Edge(Node(:b), Node(:a)) 
# not communative

edges = (:DirectedEdge, :UndirectedEdge)
for e in edges
    @eval $e(y::AbstractNode, x::ModifyingNode) = ModifiedEdge($e(y, x.node), modifiers(x))
    @eval $e(y::ModifyingNode, x::AbstractNode) = ModifiedEdge($e(y.node, x), modifiers(y))
    @eval $e(y::ModifyingNode, x::ModifyingNode) = ModifiedEdge($e(y.node, x.node), merge(modifiers(y), modifiers(x)))
end
