@testset "Conversion" begin
    @test convert(Node,:a) ≂ Node(:a)
end

struct Start{S <: Number} <: Modifier
    s::S
end

@testset "Promotion" begin
    @test typeof([Node(:a), :b]) == Vector{Node}
    @test typeof([Node(:a), :b, Start(1) * :c]) == Vector{Node}
    @test typeof([:b, Start(1) * :c]) == Vector{Node}
end
