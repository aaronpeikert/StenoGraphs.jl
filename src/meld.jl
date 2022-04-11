edges_match(x, y) = keep(x, Edge) == keep(y, Edge)

struct EdgeMismatch <: Exception
    e1::AbstractEdge
    e2::AbstractEdge
end

Base.showerror(io::IO, e::EdgeMismatch) = print(io, e.e1, " ≠ ", e.e2)

function check_edges_match(x, y)
    edges_match(x, y) ? nothing : throw(EdgeMismatch(x, y))
end

nodes_match(x, y) = keep(x, Node) == keep(y, Node)
@communative nodes_match(x::ModifiedNode, y::ModifyingNode) = false

struct NodeMismatch <: Exception
    n1::AbstractNode
    n2::AbstractNode
end

Base.showerror(io::IO, e::NodeMismatch) = print(io, e.n1, " ≠ ", e.n2)

function check_nodes_match(x, y)
    nodes_match(x, y) ? nothing : throw(NodeMismatch(x, y))
end

@communative function check_nodes_match(x, y)
    nodes_match(x, y) ? nothing : throw(NodeMismatch(x, y))
end

import Base.merge
function merge(x::Edge, y::Edge)
    check_edges_match(x, y)
    x
end

function merge(x::ModifiedEdge, y::ModifiedEdge)
    check_edges_match(x, y)
    ModifiedEdge(keep(x, Edge), merge(modifiers(x), modifiers(y)))
end

@communative function merge(x::ModifiedEdge, y::Edge)
    check_edges_match(x, y)
    x
end

function merge(x::Node, y::Node)
    check_nodes_match(x, y)
    x
end

function merge(x::ModifiedNode, y::ModifiedNode)
    check_nodes_match(x, y)
    ModifiedNode(keep(x, Node), merge(modifiers(x), modifiers(y)))
end

@communative function merge(x::ModifiedNode, y::Node)
    check_nodes_match(x, y)
    x
end

function merge(x::ModifyingNode, y::ModifyingNode)
    check_nodes_match(x, y)
    ModifyingNode(keep(x, Node), merge(modifiers(x), modifiers(y)))
end

@communative function merge(x::ModifyingNode, y::Node)
    check_nodes_match(x, y)
    x
end

@communative function merge(x::ModifyingNode, y::ModifiedNode)
    check_nodes_match(x, y)
end
