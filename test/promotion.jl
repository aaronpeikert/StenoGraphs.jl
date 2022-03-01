@testset "Conversion" begin
    @test convert(Node,:a) == Node(:a)
end

struct Start{S <: Number} <: Modifier
    s::S
end

@testset "Promotion" begin
    @test eltype([Node(:a), :b]) <: Node
    @test eltype([Node(:a), :b, Start(1) * :c]) <: AbstractNode
    @test eltype([:b, Start(1) * :c]) <: AbstractNode
    @test eltype([Start(1) * :b, Start(1) * :c]) <: MetaNode
end
