
# lhs = left hand side; rhs = right hand side
# src = source, dst = destination
# order is: lhs, rhs, src, dst
function Arrow(lhs, rhs, src, dst; edge_fun = DirectedEdge, cross = false)
    if cross
        edges = edge_fun(src, dst)
    else
        edges = edge_fun.(src, dst)
    end
    edges = isa(edges, VecOrMat) ? edges : [edges]
    edges = isa(edges, Matrix) ? vec(edges) : edges
    edges = isa(lhs, Arrow) ? vcat(lhs.edges..., edges...) : edges
    edges = isa(rhs, Arrow) ? vcat(edges..., rhs.edges...) : edges
    Arrow(edges, lhs, rhs)
end

→(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, Node), keep(rhs, Left, AbstractNode))
⇒(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, Node), keep(rhs, Left, AbstractNode); cross = true)
←(lhs, rhs) = Arrow(lhs, rhs, keep(rhs, Left, Node), keep(lhs, Right, AbstractNode))
⇐(lhs, rhs) = Arrow(lhs, rhs, keep(rhs, Left, Node), keep(lhs, Right, AbstractNode); cross = true)
↔(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, Node), keep(rhs, Left, AbstractNode); edge_fun = UndirectedEdge)
⇔(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, Node), keep(rhs, Left, AbstractNode); edge_fun = UndirectedEdge, cross = true)

# if either lhs or rhs are a single node, broadcast arrow (barrow) behave like cross arrow (carrow)
barrows = [:→, :←, :↔]
carrows = [:⇒, :⇐, :⇔]
for (barrow, carrow) in zip(barrows,  carrows)
    @eval $barrow(lhs::Union{AbstractNode, Symbol}, rhs::Union{AbstractNode, Symbol}) = $carrow(lhs, rhs)
    @eval $barrow(lhs::Union{AbstractNode, Symbol}, rhs) = $carrow(lhs, rhs)
    @eval $barrow(lhs, rhs::Union{AbstractNode, Symbol}) = $carrow(lhs, rhs)
end
