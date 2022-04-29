edges_match(x::AbstractEdge, y::AbstractEdge) = id(x) == id(y)
@communative edges_match(x::DirectedEdge, y::UndirectedEdge) = false

struct EdgeMismatch <: Exception
    e1::AbstractEdge
    e2::AbstractEdge
end

Base.showerror(io::IO, e::EdgeMismatch) = print(io, e.e1, " ≠ ", e.e2)

function check_edges_match(x, y)
    edges_match(x, y) ? nothing : throw(EdgeMismatch(x, y))
end

@communative function check_edges_match(x::DirectedEdge, y::UndirectedEdge)
    throw(EdgeMismatch(x, y))
end

nodes_match(x::AbstractNode, y::AbstractNode) = id(x) == id(y)
@communative nodes_match(x::ModifiedNode, y::ModifyingNode) = false

struct NodeMismatch <: Exception
    n1::AbstractNode
    n2::AbstractNode
end

Base.showerror(io::IO, e::NodeMismatch) = print(io, e.n1, " ≠ ", e.n2)

function check_nodes_match(x, y)
    nodes_match(x, y) ? nothing : throw(NodeMismatch(x, y))
end


function merge_(x, y)
    (merge(keep(x, Src), keep(y, Src)), merge(keep(x, Dst), keep(y, Dst)))
end

import Base.merge
function merge(x::DirectedEdge, y::DirectedEdge)
    check_edges_match(x, y)
    DirectedEdge(merge_(x, y)...)
end

function merge(x::UndirectedEdge, y::UndirectedEdge)
    check_edges_match(x, y)
    UndirectedEdge(merge_(x, y)...)
end

function merge(x::Union{UndirectedEdge, DirectedEdge}, y::Union{UndirectedEdge, DirectedEdge})
    # should not merge, check will fail
    check_edges_match(x, y)
end

function merge(x::ModifiedEdge, y::ModifiedEdge)
    check_edges_match(x, y)
    ModifiedEdge(merge(keep(x, Edge), keep(y, Edge)), merge(modifiers(x), modifiers(y)))
end

@communative function merge(x::ModifiedEdge, y::Edge)
    check_edges_match(x, y)
    x
end

function merge(x::T, y::T) where {T <: Node}
    check_nodes_match(x, y)
    x
end

function merge(x::T, y::T) where {T <: ModifiedNode}
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

merge(x::Union{AbstractNode, AbstractEdge}) = x

function merge(x::Vararg{Union{AbstractEdge, AbstractNode}})
    foldr(merge, x) 
end

function meld(ns::Vector{<: AbstractNode})
    ids = id.(ns)
    uids = unique(ids)
    out = similar(ns, length(uids))
    for (i, id) in enumerate(uids)
        out[i] = merge(ns[id .== ids]...)
    end
    out
end
