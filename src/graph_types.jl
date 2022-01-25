abstract type Node end

struct SimpleNode{T <: Symbol} <: Node
    node::T
end

function Node(node)
    SimpleNode(node)
end

abstract type Edge end

function Edge(lhs, rhs)
    DirectedEdge(lhs, rhs)    
end

struct DirectedEdge{T <: Node} <: Edge
    lhs::T
    rhs::T
end

struct UndirectedEdge{T <: Node} <: Edge
    lhs::T
    rhs::T
end

abstract type Modifier end

struct ModifiedEdge{E <: Edge, VM <: Vector{M} where {M <: Modifier}} <: Edge
    edge::E
    modifiers::VM
end

function ModifiedEdge(edge::ModifiedEdge, modifier::Modifier)
    ModifiedEdge(edge.edge, [edge.modifiers..., modifier])    
end

function ModifiedEdge(edge::Edge, modifier::Modifier)
    ModifiedEdge(edge, [modifier])    
end

ModifiedEdge(edge::Edge, modifier::Matrix{M} where {M <: Modifier}) = ModifiedEdge(edge, vec(modifier))

struct ModifyingNode{N <: Node, VM <: Vector{M} where {M <: Modifier}} <: Node
    node::N
    modifiers::VM
end

ModifyingNode(node, modifier::Modifier) = ModifyingNode(node, [modifier])

ModifyingNode(node::ModifyingNode, modifier::Modifier) = ModifyingNode(node.node, [node.modifiers modifier])

ModifyingNode(node::Node, modifier::Matrix{M} where {M <: Modifier}) = ModifyingNode(node, vec(modifier))

ModifyingNode(node::Symbol, modifier::Modifier) = ModifyingNode(Node(node), modifier)

function Edge(lhs, rhs::ModifyingNode)
    edge = Edge(lhs, rhs.node)
    ModifiedEdge(edge, rhs.modifiers)
end

function Edge(lhs::ModifyingNode, rhs)
    edge = Edge(lhs.node, rhs)
    ModifiedEdge(edge, lhs.modifiers)
end
