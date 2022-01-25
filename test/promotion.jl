@testset "Conversion" begin
    @test convert(Node,:a) ≂ Node(:a)
end

struct Start{S <: Number} <: Modifier
    s::S
end

@testset "Promotion" begin
    @test typeof([Node(:a), :b]) == Vector{SimpleNode{Symbol}}
    @test typeof([Node(:a), :b, Start(1) * :c]) == Vector{Node}
end