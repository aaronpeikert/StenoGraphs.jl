@testset "Nodes" begin
    @test typeof(Node(:a)) <: Node
end

@testset "Edges" begin
    @test Edge(:a, :b) == Edge(Node(:a), Node(:b)) == DirectedEdge(SimpleNode(:a), SimpleNode(:b))
end

# define modifier
struct Weight <: Modifier end

@testset "ModifedNode" begin
    @test ModifiedNode(:a, Weight()) == ModifiedNode(Node(:a), Weight())
end

@testset "ModifedEdges" begin
    # ModifiedNode leads to ModifiedEdge with simple Node
    @test Edge(Node(:a), ModifiedNode(Node(:b), Weight())) == ModifiedEdge(Edge(:a, :b), Weight())
end

#Edge(Node(:a), ModifiedNode(Node(:b), start(4)))

#Edge(Node(:a), Node(:b))

#ModifiedEdge(Edge(Node(:a), Node(:b)), start(4))