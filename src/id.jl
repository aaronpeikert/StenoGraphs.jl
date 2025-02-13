"""
    id(node::AbstractNode)

Returns the id of a node. See [`Node`](@ref).

```jldoctest
julia> id(Node(:a), Node(:b)))
:a

julia> id(Node(1))
1

```

"""

function id(node::AbstractNode)
    keep(node, Node).node
end

function src_id(edge::AbstractEdge)
    id(keep(edge, StenoGraphs.Src))
end

function dst_id(edge::AbstractEdge)
    id(keep(edge, StenoGraphs.Dst))
end

"""
    id(node::MetaEdge)

Returns a `Tuple` that uniquely identifies the edge by the `id`s from its nodes.


```jldoctest
julia> id(Edge(Node(:a), Node(:b)))
(:a, :b)

julia> id(UndirectedEdge(Node(:b), Node(:a)))
(:a, :b)

```

"""
function id(edge::MetaEdge)
    id(keep(edge, Edge))
end

function id(edge::Edge)
    (src_id(edge), dst_id(edge))
end

function id(edge::UndirectedEdge)
    (sort([src_id(edge), dst_id(edge)])...,)
end
