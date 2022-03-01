abstract type AbstractNode end
abstract type Node <: AbstractNode end
abstract type MetaNode <: AbstractNode end

struct SimpleNode{T <: Symbol} <: Node
    node::T
end

Node(node) = SimpleNode(node)

abstract type AbstractEdge end
abstract type Edge <: AbstractEdge end
abstract type MetaEdge <: AbstractEdge end

Edge(src, dst) = DirectedEdge(src, dst)

struct DirectedEdge{T1 <: AbstractNode, T2 <: AbstractNode} <: Edge
    src::T1
    dst::T2
end

struct UndirectedEdge{T1 <: AbstractNode, T2 <: AbstractNode} <: Edge
    src::T1
    dst::T2
end

abstract type Modifier end

struct ModifiedEdge{E <: AbstractEdge, VM <: Vector{M} where {M <: Modifier}} <: MetaEdge
    edge::E
    modifiers::VM
end

struct ModifyingNode{N <: AbstractNode, VM <: Vector{M} where {M <: Modifier}} <: MetaNode
    node::N
    modifiers::VM
end

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

struct Arrow{E <: Edge, N1 <: Node, N2 <: Node} <: MetaEdge
    edge::E
    lhs::N1
    rhs::N2
end
