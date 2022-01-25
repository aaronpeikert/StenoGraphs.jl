struct Weight <: Modifier
    w
end

struct Start <: Modifier
    s
end

@testset "Multiplication of Edges" begin
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) ≂ Weight(1) * @semi a ~ b
    @test Edge(:a, :b) * Weight(1) ≂ Weight(1) * Edge(:a, :b)
end

@testset "Multiplication of Nodes" begin
    @test ModifiedNode(Node(:a), Weight(2)) ≂ Weight(2) * Node(:a)
    @test Node(:a) * Weight(3) ≂ Weight(3) * Node(:a)
    @test ModifiedEdge(Edge(:a, :b), Weight(1)) ≂ Edge(:a * Weight(1), :b)
    @test Edge(:a * Weight(1), :b) ≂ Edge(Weight(1) * :a, :b)
end

@testset "Multiplication of Modifiers" begin
    e1 = ModifiedEdge(Edge(:a, :b), [Weight(1) Start(1)])
    e2 = @semi a ~ Weight(1) * Start(1) * b 
    e3 = @semi a ~ Weight(1) * b * Start(1)
    e4 = @semi a ~ b * Weight(1) * Start(1)

    @test e1 ≂ e2
    @test e2 ≂ e3
    @test e3 ≂ e4
end
