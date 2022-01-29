@testset "Nodes" begin
    @test typeof(Node(:a)) <: Node
end

@testset "Edges" begin
    e1 = Edge(:a, :b)
    e2 = Edge(Node(:a), Node(:b))
    e3 = DirectedEdge(SimpleNode(:a), SimpleNode(:b))
    @test e1 ≂ e2 && e2 ≂ e3
end

# define modifier
struct Weight <: Modifier end

@testset "ModifedNode" begin
    @test ModifyingNode(:a, Weight()) ≂ ModifyingNode(Node(:a), Weight())
end

@testset "ModifedEdges" begin
    # ModifyingNode leads to ModifiedEdge with simple Node
    @test Edge(Node(:a), ModifyingNode(Node(:b), Weight())) ≂ ModifiedEdge(Edge(:a, :b), Weight())
    @test [ModifiedEdge(Edge(:a, :b), Weight()), Edge(:a, :c)] ≂ @semi a ~ b * Weight() + c
end

#Edge(Node(:a), ModifyingNode(Node(:b), start(4)))

#Edge(Node(:a), Node(:b))

#ModifiedEdge(Edge(Node(:a), Node(:b)), start(4))