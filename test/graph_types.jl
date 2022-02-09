@testset "Nodes" begin
    @test typeof(Node(:a)) <: Node
end

@testset "Edges" begin
    @test Edge(:a, :b) == Edge(Node(:a), Node(:b)) == DirectedEdge(SimpleNode(:a), SimpleNode(:b))
end

# define modifier
struct Weight <: Modifier end

@testset "ModifedNode" begin
    @test ModifyingNode(:a, Weight()) == ModifyingNode(Node(:a), Weight())
end

@testset "ModifedEdges" begin
    # ModifyingNode leads to ModifiedEdge with simple Node
    @test Edge(Node(:a), ModifyingNode(Node(:b), Weight())) == ModifiedEdge(Edge(:a, :b), Weight())
    @test [ModifiedEdge(Edge(:a, :b), Weight()), Edge(:a, :c)] == @StenoGraph a → b * Weight() + c
end
