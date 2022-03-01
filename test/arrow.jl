@testset "Single Arrow" begin
    @test unmeta(:a → :b) == Edge(:a, :b)
end

@testset "Single Chain" begin
    @test issetequal(unmeta.(:a → :b → :c), [Edge(:a, :b), Edge(:b, :c)])
end

struct Start <: Modifier
    s
end

@testset "Modified Arrow" begin
    @test unarrow(:a → :b * Start(1)) ==
    unarrow(Start(1) * :a → :b) ==
    ModifiedEdge(Edge(:a, :b), Start(1))
end
