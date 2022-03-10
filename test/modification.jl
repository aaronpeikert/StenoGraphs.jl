struct Weight <: Modifier
    w
end

struct Start <: Modifier
    s
end

@testset "Multiplication of Edges" begin
    @test Edge(:a, :b) * Weight(1) == ModifiedEdge(Edge(:a, :b), Weight(1))
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) == Weight(1) * Edge(:a, :b)
    @test Edge(:a, :b) * Weight(1) == Weight(1) * Edge(:a, :b)
end

@testset "Multiplication of Nodes" begin
    @test ModifyingNode(Node(:a), Weight(2)) == Weight(2) * Node(:a)
    @test Node(:a) * Weight(3) == Weight(3) * Node(:a)
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) == Edge(:a * Weight(1), :b)
    @test Edge(:a * Weight(1), :b) == Edge(Weight(1) * :a, :b)
    @test ModifiedEdge(Edge(:a, :b), [Weight(1), Start(1)]) == Edge(Weight(1) * :a, :b * Start(1))
end

@testset "Multiplication of Modifiers" begin
    @test (ModifiedEdge(Edge(:a, :b), [Weight(1) Start(1)])) ==
        (Edge(:a, Weight(1) * Start(1) * :b)) ==
        (Edge(:a, Weight(1) * :b * Start(1))) ==
        (Edge(:a, :b * Weight(1) * Start(1))) ==
        (Edge(:a, :b) * Weight(1) * Start(1)) ==
        (Weight(1) * Edge(:a, :b) * Start(1)) ==
        (Edge(:a, :b) * (Weight(1) * Start(1)))

    @test (ModifyingNode(:b, [Weight(1) Start(1)])) ==
        (Weight(1) * Start(1) * :b) ==
        (Weight(1) * :b * Start(1)) ==
        (:b * Weight(1) * Start(1)) ==
        (Node(:b) * Weight(1) * Start(1)) ==
        (Weight(1) * Node(:b) * Start(1)) == 
        (Node(:b) * (Weight(1) * Start(1)))
end


@testset "Multiplication of VecOrMat of Modifiers" begin
    [Weight(1), Start(1)] * [Weight(2) Start(2)] == [Weight(1), Start(1), Weight(2), Start(2)]

    vn1 = (ModifyingNode(Node(:a), [Weight(1), Start(1)])) ==
        ([Weight(1), Start(1)] * :b) ==
        (:b * [Weight(1), Start(1)]) ==
        ([Weight(1)] * :b * [Start(1)]) ==

    @test [Weight(1) Start(1)] * :b *  [Weight(2) Start(2)] == [Weight(1) Start(1) Weight(2) Start(2)] * :b
end