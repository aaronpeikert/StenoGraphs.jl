struct Weight <: EdgeModifier
    w
end

struct Observed <: NodeModifier end

@testset "Swap Node <-> Node" begin
    n1 = Node(:a)
    n2 = Node(:b)
    @test swap_node(n1, n1, n2) == swap_node(n1, n1 => n2) == n2
    @test swap_node(n1 ^ Observed(), n1, n2) == swap_node(n1 ^ Observed(), n1 => n2) == n2 ^ Observed()
    @test swap_node(n1 * Weight(1), n1, n2) == n2 * Weight(1)
end

@testset "Swap Nodes in Edges" begin
    n1 = Node(:a)
    n2 = Node(:b)
    n3 = Node(:c)

    e1 = Edge(n1, n2)
    e3 = Edge(n3, n2)
    @test swap_node(e1, n1, n3) == e3
    @test swap_node(e1 * Weight(1), n1, n3) == e3 * Weight(1)

end

@testset "Swap Nodes in UndirectedEdges" begin
    n1 = Node(:a)
    n2 = Node(:b)
    n3 = Node(:c)

    e1 = UndirectedEdge(n1, n2)
    e3 = UndirectedEdge(n3, n2)
    @test swap_node(e1 * Weight(1), n1, n3) == e3 * Weight(1)
end
