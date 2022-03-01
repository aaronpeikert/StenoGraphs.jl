
# lhs = left hand side; rhs = right hand side
# src = source, dst = destination
# order is: lhs, rhs, src, dst
→(lhs, rhs) = Arrow(DirectedEdge, lhs, rhs)
←(lhs, rhs) = Arrow(DirectedEdge, lhs, rhs, rhs, lhs)
↔(lhs, rhs) = Arrow(UndirectedEdge, lhs, rhs)
# method for lhs == src, rhs == dst
Arrow(edge_fun, lhs, rhs) = Arrow(edge_fun, lhs, rhs, lhs, rhs)

struct DiscardArrow end

Arrow(edge_fun, lhs, rhs, src, dst) = Arrow(edge_fun, lhs, rhs, src, dst, DiscardArrow())

function Arrow(edge_fun, lhs, rhs, src, dst, ::DiscardArrow)
    Arrow(
        edge_fun(keep(src, Right, AbstractNode), keep(dst, Left, AbstractNode)),
        keep(lhs, Right, Node),
        keep(rhs, Left, Node)
    )
end

function Arrow(edge_fun, lhs::T1, rhs::T2, src, dst) where {T1 <: Arrow, T2 <: Arrow}
    [lhs; Arrow(edge_fun, lhs, rhs, src, dst, DiscardArrow()); rhs]
end

function Arrow(edge_fun, lhs::T, rhs, src, dst) where {T <: Arrow}
    [lhs; Arrow(edge_fun, lhs, rhs, src, dst, DiscardArrow())]
end

function Arrow(edge_fun, lhs, rhs::T, src, dst) where {T <: Arrow}
    [Arrow(edge_fun, lhs, rhs, src, dst, DiscardArrow()); rhs]
end

prepare_arrow_edge(edge_fun::Type{T}, lhs, rhs) where {T <: AbstractEdge} = edge_fun(keep(lhs, Right), keep(rhs, Left))
