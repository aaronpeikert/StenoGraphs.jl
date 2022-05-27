
struct Weight <: NodeModifier
    w
end

n1 = Node(:a)
n2 = ModifiedNode(Node(:b), Weight(2.0))
e = Edge(n1, n2)


@testset "Node Ids" begin
    @test StenoGraphs.id(n1) == :a
    @test StenoGraphs.id(n2) == :b
end

@testset "Edge Ids" begin
    @test StenoGraphs.src_id(e) == :a
    @test StenoGraphs.dst_id(e) == :b
    @test StenoGraphs.id(e) == (:a, :b)
end


@testset "UndirectedEdge Ids" begin
    @test StenoGraphs.id(UndirectedEdge(Node(:a), Node(:b))) == 
    StenoGraphs.id(UndirectedEdge(Node(:b), Node(:a)))
end
