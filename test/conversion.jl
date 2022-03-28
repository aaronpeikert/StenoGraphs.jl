@testset "Conversion" begin
    @test convert(Node,:a) == Node(:a)
end

struct Start{S <: Number} <: EdgeModifier
    s::S
end

@testset "Promotion" begin
    @test eltype([Node(:a), :b]) <: Node
    @test eltype([Node(:a), :b, Start(1) * Node(:c)]) <: AbstractNode
    @test eltype([:b, Start(1) * Node(:c)]) <: AbstractNode
    @test eltype([Start(1) * Node(:b), Start(1) * Node(:c)]) <: MetaNode
end
