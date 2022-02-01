import Base.==
struct Weight <: Modifier end
==(x::Weight, y::Weight) = true 

struct Start <: Modifier
    s::Number
end
==(x::Start, y::Start) = x.s == y.s


@testset "Modifier" begin
    @test [Start(1) Weight()] == [Start(1) Weight()]
    @test [Start(1) Weight()] == [Weight() Start(1)]
end

@testset "Node" begin
    @test Node(:a) == Node(:a)
    @test Node(:a) != Node(:b)
    @test ModifyingNode(Node(:a), [Start(1) Weight()]) == ModifyingNode(Node(:a), [Start(1) Weight()])
end

@testset "UndirectedEdge" begin
    @test UndirectedEdge(:a, :b) == UndirectedEdge(:b, :a)
end

@testset "DirectedEdge" begin
    me1 = ModifiedEdge(:a → :b, Start(1))
    @test me1 == me1
    me2 = deepcopy(me1)
    @test me1 == me2
    me2.modifiers[1] = Start(2)
    @test me1 != me2
    me3 = ModifiedEdge(:a → :b, [Weight() Start(1)])
    me4 = deepcopy(me3)
    @test me3 == me4
    me5 = ModifiedEdge(:a → :b, [Start(1) Weight()])
    @test me5 == me3
end