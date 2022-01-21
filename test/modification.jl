struct Weight <: Modifier end
test = @semi a ~ b

Weight() * test

Weight() * @semi a ~ b

test * Weight()

@testset "Multiplication of Edges" begin
    @test ModifiedEdge(Edge(:a, :b), Weight()) == Weight() * @semi a ~ b
    @test Edge(:a, :b) * Weight() == Weight() * Edge(:a, :b)
end