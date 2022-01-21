abstract type Node end

struct SimpleNode{T <: Symbol} <: Node
    node::T
end

function Node(node)
    SimpleNode(node)
end

abstract type Edge end

struct DirectedEdge{T <: Node} <: Edge
    lhs::T
    rhs::T
end

function Edge(lhs, rhs)
    DirectedEdge(lhs, rhs)    
end

struct UndirectedEdge{T <: Node} <: Edge
    lhs::T
    rhs::T
end

abstract type Modifier end

struct ModifiedEdge{E <: Edge, M <: Modifier} <: Edge
    edge::E
    modifier::M
end

function ModifiedEdge(edge::ModifiedEdge, modifier::Modifier)
    ModifiedEdge(edge.edge, [edge.modifier, modifier])    
end

struct ModifiedNode{N <: Node, M <: Modifier} <: Node
    node::N
    modifier::M
end

function Edge(lhs, rhs::ModifiedNode)
    edge = Edge(lhs, rhs.node)
    ModifiedEdge(edge, rhs.modifier)
end

function Edge(lhs::ModifiedNode, rhs)
    edge = Edge(lhs.node, rhs)
    ModifiedEdge(edge, lhs.modifier)
end
