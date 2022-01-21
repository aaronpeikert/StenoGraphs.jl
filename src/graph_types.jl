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

edges = (:DirectedEdge, :UndirectedEdge)
for e in edges
    @eval $e(lhs::Symbol, rhs::Symbol) = $e(Node(lhs), Node(rhs))
    @eval $e(lhs, rhs::Symbol) = $e(lhs, Node(rhs))
    @eval $e(lhs::Symbol, rhs) = $e(Node(lhs), rhs)
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

ModifiedNode(node::Symbol, modifier) = ModifiedNode(Node(node), modifier)

function Edge(lhs, rhs::ModifiedNode)
    edge = Edge(lhs, rhs.node)
    ModifiedEdge(edge, rhs.modifier)
end

function Edge(lhs::ModifiedNode, rhs)
    edge = Edge(lhs.node, rhs)
    ModifiedEdge(edge, lhs.modifier)
end
