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
    id(keep(edge, Edge))
end

function id(edge::Edge)
    (src_id(edge), dst_id(edge))
end

function id(edge::UndirectedEdge)
    (sort([src_id(edge), dst_id(edge)])...,)
end
