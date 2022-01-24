struct Weight <: Modifier
    w
end

@testset "Multiplication of Edges" begin
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) == Weight(1) * @semi a ~ b
    @test Edge(:a, :b) * Weight(1) == Weight(1) * Edge(:a, :b)
end

@testset "Multiplication of Nodes" begin
    @test ModifiedNode(Node(:a), Weight(2)) == Weight(2) * Node(:a)
    @test Node(:a) * Weight(3) == Weight(3) * Node(:a)
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) == Edge(:a * Weight(1), :b) == Edge(Weight(1) * :a, :b)
end
