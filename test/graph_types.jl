@testset "Nodes" begin
    @test typeof(Node(:a)) <: Node
    @test length(Node(:a)) == 1
end

@testset "Edges" begin
    @test Edge(Node(:a), Node(:b)) == Edge(Node(:a), Node(:b)) == DirectedEdge(SimpleNode(:a), SimpleNode(:b))
end

# define modifier
struct Weight <: EdgeModifier end

@testset "ModifedNode" begin
    @test ModifyingNode(Node(:a), Weight()) == ModifyingNode(Node(:a), Weight())
end

@testset "ModifedEdges" begin
    # ModifyingNode leads to ModifiedEdge with simple Node
    @test Edge(Node(:a), ModifyingNode(Node(:b), Weight())) == ModifiedEdge(Edge(Node(:a), Node(:b)), Weight())
    # check if the same works with vector
    @test [ModifiedEdge(Edge(Node(:a), Node(:b)), Weight()), Edge(Node(:a), Node(:c))] == Edge(Node(:a), [Node(:b) * Weight() Node(:c)])
end
