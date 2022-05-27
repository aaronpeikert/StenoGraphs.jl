struct Weight <: EdgeModifier
    w
end

struct Start <: EdgeModifier
    s
end

struct Observed <: NodeModifier end
struct Ordinal <: NodeModifier end

@testset "Multiplication of Edges" begin
    @test Edge(Node(:a), Node(:b)) * Weight(1) == ModifiedEdge(Edge(Node(:a), Node(:b)), Weight(1))
    @test ModifiedEdge(Edge(Node(:a), Node(:b)), Weight(1)) == Weight(1) * Edge(Node(:a), Node(:b))
    @test Edge(Node(:a), Node(:b)) * Weight(1) == Weight(1) * Edge(Node(:a), Node(:b))
end

@testset "Multiplication of Nodes" begin
    @test ModifyingNode(Node(:a), Weight(2)) == Weight(2) * Node(:a)
    @test Node(:a) * Weight(3) == Weight(3) * Node(:a)
    @test ModifiedEdge(Edge(Node(:a), Node(:b)), Weight(1)) == Edge(Node(:a) * Weight(1), Node(:b))
    @test Edge(Node(:a) * Weight(1), Node(:b)) == Edge(Weight(1) * Node(:a), Node(:b))
    @test ModifiedEdge(Edge(Node(:a), Node(:b)), [Weight(1), Start(1)]) == Edge(Weight(1) * Node(:a), Node(:b) * Start(1))
end

@testset "Multiplication of Modifiers" begin
    @test (ModifiedEdge(Edge(Node(:a), Node(:b)), [Weight(1) Start(1)])) ==
        (Edge(Node(:a), Weight(1) * Start(1) * Node(:b))) ==
        (Edge(Node(:a), Weight(1) * Node(:b) * Start(1))) ==
        (Edge(Node(:a), Node(:b) * Weight(1) * Start(1))) ==
        (Edge(Node(:a), Node(:b)) * Weight(1) * Start(1)) ==
        (Weight(1) * Edge(Node(:a), Node(:b)) * Start(1)) ==
        (Edge(Node(:a), Node(:b)) * (Weight(1) * Start(1)))

    @test (ModifyingNode(Node(:b), [Weight(1) Start(1)])) ==
        (Weight(1) * Start(1) * Node(:b)) ==
        (Weight(1) * Node(:b) * Start(1)) ==
        (Node(:b) * Weight(1) * Start(1)) ==
        (Node(:b) * Weight(1) * Start(1)) ==
        (Weight(1) * Node(:b) * Start(1)) == 
        (Node(:b) * (Weight(1) * Start(1)))
  
    @test Start(3)*Start(4)*Weight(5) ==
        [Start(3), Start(4), Weight(5)] ==
        (Start(3)*Start(4))*Weight(5) ==
        Start(3)*(Start(4)*Weight(5))
end

@testset "ModifiedNode" begin
    @test Node(:a)^Observed() == Observed()^Node(:a) == ModifiedNode(Node(:a), Observed())
    @test Node(:a)^Observed()^Ordinal() == Node(:a)^[Observed(), Ordinal()] == ModifiedNode(Node(:a), [Observed(), Ordinal()])
    @test Node(:a)^Observed()^Ordinal()^Ordinal() == ModifiedNode(Node(:a), [Observed(), Ordinal()])
    @test Observed()^Observed()^Ordinal() ==
        [Observed(), Observed(), Ordinal()] ==
        (Observed()^Observed())^Ordinal() ==
        Observed()^(Observed()^Ordinal())
end

@testset "Modification of Arrow" begin
    @test unarrow((Node(:a) → Node(:b)) * Start(1)) == unarrow(Node(:a) → Start(1) * Node(:b))
    @test unarrow((Node.([:a :b]) → Node.([:c :d])) * Start(1)) == unarrow(Node.([:a :b]) → Node.([:c :d]) .* Ref(Start(1)))
end
