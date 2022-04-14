struct Weight <: EdgeModifier
    w
end

struct Observed <: NodeModifier end

@testset "Swap Node <-> Node" begin
    n1 = Node(:a)
    n2 = Node(:b)
    @test swap_node(n1, n1, n2) == StenoGraphs.swap_node(n1, n1 => n2) == n2
    @test swap_node(n1 ^ Observed(), n1, n2) == n2 ^ Observed()
    @test swap_node(n1 * Weight(1), n1, n2) == n2 * Weight(1)
end
