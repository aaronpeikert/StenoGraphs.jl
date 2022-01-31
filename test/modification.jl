struct Weight <: Modifier
    w
end

struct Start <: Modifier
    s
end

@testset "Multiplication of Edges" begin
    @test Edge(:a, :b) * Weight(1) ≂ ModifiedEdge(Edge(:a, :b), Weight(1))
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) ≂ Weight(1) * @semi a → b
    @test Edge(:a, :b) * Weight(1) ≂ Weight(1) * Edge(:a, :b)
end

@testset "Multiplication of Nodes" begin
    @test ModifyingNode(Node(:a), Weight(2)) ≂ Weight(2) * Node(:a)
    @test Node(:a) * Weight(3) ≂ Weight(3) * Node(:a)
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) ≂ Edge(:a * Weight(1), :b)
    @test Edge(:a * Weight(1), :b) ≂ Edge(Weight(1) * :a, :b)
    @test ModifiedEdge(Edge(:a, :b), [Weight(1), Start(1)]) ≂ @semi Weight(1) * a → b * Start(1)
end

@testset "Multiplication of Modifiers" begin
    e1 = ModifiedEdge(Edge(:a, :b), [Weight(1) Start(1)])
    e2 = @semi a → Weight(1) * Start(1) * b 
    e3 = @semi a → Weight(1) * b * Start(1)
    e4 = @semi a → b * Weight(1) * Start(1)
    e5 = Edge(:a, :b) * Weight(1) * Start(1)
    e6 = Weight(1) * Edge(:a, :b) * Start(1)
    n7 = Edge(:a, :b) * (Weight(1) * Start(1))
    @test e1 ≂ e2
    @test e2 ≂ e3
    @test e3 ≂ e4
    @test e4 ≂ e5
    @test e5 ≂ e6

    n1 = ModifyingNode(:b, [Weight(1) Start(1)])
    n2 = @semi Weight(1) * Start(1) * b 
    n3 = @semi Weight(1) * b * Start(1)
    n4 = @semi b * Weight(1) * Start(1)
    n5 = Node(:b) * Weight(1) * Start(1)
    n6 = Weight(1) * Node(:b) * Start(1)
    n7 = Node(:b) * (Weight(1) * Start(1))
    @test n1 ≂ n2
    @test n2 ≂ n3
    @test n3 ≂ n4
    @test n4 ≂ n5
    @test n5 ≂ n6
    @test n6 ≂ n7
end


@testset "Multiplication of VecOrMat of Modifiers" begin
    [Weight(1), Start(1)] * [Weight(2) Start(2)] ≂ [Weight(1), Start(1), Weight(2), Start(2)]

    vn1 = ModifyingNode(Node(:a), [Weight(1), Start(1)])
    vn2 = [Weight(1), Start(1)] * :b
    vn3 = :b * [Weight(1), Start(1)]
    vn4 = [Weight(1)] * :b * [Start(1)]

    vn1 ≂ vn2
    vn2 ≂ vn3
    vn3 ≂ vn4

    @test [Weight(1) Start(1)] * :b *  [Weight(2) Start(2)] ≂ [Weight(1) Start(1) Weight(2) Start(2)] * :b
end