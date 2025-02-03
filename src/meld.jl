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
"""
    merge(x, y)

Merges two (or more) edge/node and fails if not mergable.
In contrast to [`meld`](@ref), it returns always one edge/node or fails.
Works for:

    * ModifiedEdge
    * ModifyingNode
    * ModifiedNode
    * DirectedEdge
    * UndirectedEdge
    * some combinations thereof (those that are mergable)
    
Requires carefull implementation by subtypes.
Will unlikely work as expected out of the box for other subtypes because it is unclear what is mergable.

# Example

```jldoctest
# `StenoGraphs` does not implement any `EdgeModifier`s
julia> struct Weight{N <: Number} <: EdgeModifier w::N end

julia> merge(Edge(Node(:a), Node(:b)), Edge(Node(:a), Node(:b) * Weight(2)))
a → b * Weight{Int64}(2)

```
"""
function merge(x::DirectedEdge, y::DirectedEdge)
    check_edges_match(x, y)
    DirectedEdge(merge(keep(x, Src), keep(y, Src)), merge(keep(x, Dst), keep(y, Dst)))
end

function merge(x::UndirectedEdge, y::UndirectedEdge)
    check_edges_match(x, y)
    # sorting required
    xns = sort([keep(x, Src), keep(x, Dst)])
    yns = sort([keep(y, Src), keep(y, Dst)])
    UndirectedEdge(merge.(xns, yns)...)
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
    # should not merge, check will fail
    check_nodes_match(x, y)
end

merge(x::Union{AbstractNode, AbstractEdge}) = x

function merge(x::Union{AbstractEdge, AbstractNode}...)
    foldr(merge, x) 
end

"""
    meld(x)

Meldes a vector of edge/node. That means it tries to [`merge`](@ref) elements of the vector that relate to the same nodes.
# Example

```jldoctest
# `StenoGraphs` does not implement any `EdgeModifier`s
struct Weight{N <: Number} <: EdgeModifier w::N end;
e1 = Edge(Node(:a), Node(:b));
e2 = e1 * Weight(1.0);
e3 = UndirectedEdge(Node(:a), Node(:c));
e4 = UndirectedEdge(Node(:c), Node(:a));
es = [e1, e1, e2, e2, e3, e3, e4, e4]
meld(es) == [e2, e3]

# output

true
```

"""
function meld(x)
    ids = id.(x)
    uids = unique(ids)
    out = similar(x, length(uids))
    for (i, id) in enumerate(uids)
        out[i] = merge(x[Ref(id) .== ids]...)
    end
    out
end
meld(x...) = meld(reduce(vcat, vec.(x)))
