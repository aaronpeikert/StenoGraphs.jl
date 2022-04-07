function id(node::AbstractNode)
    keep(node, Node).node
end

function src_id(edge)
    id(keep(edge, StenoGraphs.Src))
end

function dst_id(edge)
    id(keep(edge, StenoGraphs.Dst))
end

function id(edge::AbstractEdge)
    (src_id(edge), dst_id(edge))
end
