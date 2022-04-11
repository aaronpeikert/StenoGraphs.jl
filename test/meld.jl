using StenoGraphs

struct Start{S <: Number} <: EdgeModifier
    s::S
end

struct Weight{S <: Number} <: EdgeModifier
    s::S
end

struct Label <: NodeModifier
    l
end

@testset "Merge Edges" begin
    e1 = Edge(Node(:a), Node(:b))
    e2 = e1 * Weight(2)
    e3 = e1 * Start(4)

    @test merge(e1, e2) == e2
    @test merge(e2, e3) == e2 * Start(4)
end

@testset "Merge Nodes" begin
    n1 = Node(:a)
    n2 = n1 ^ Label("hi")
    @test merge(n1, n2) == n2
    @test merge(n2, n2) == n2

    n3 = n1 * Weight(1)
    n4 = n1 * Start(1)
    @test merge(n1, n3) == n3
    @test merge(n3, n4) == n3 * Start(1)
    @test_throws StenoGraphs.NodeMismatch merge(n2, n3)
end
