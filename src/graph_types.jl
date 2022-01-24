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

struct ModifiedNode{N <: Node, VM <: Vector{M} where {M <: Modifier}} <: Node
    node::N
    modifiers::VM
end

ModifiedNode(node, modifier::Modifier) = ModifiedNode(node, [modifier])

ModifiedNode(node::Symbol, modifier::Vector{M} where {M <: Modifier}) = ModifiedNode(Node(node), modifier)

function Edge(lhs, rhs::ModifiedNode)
    edge = Edge(lhs, rhs.node)
    ModifiedEdge(edge, rhs.modifiers)
end

function Edge(lhs::ModifiedNode, rhs)
    edge = Edge(lhs.node, rhs)
    ModifiedEdge(edge, lhs.modifiers)
end
