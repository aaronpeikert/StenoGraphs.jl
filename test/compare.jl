import Base.==
struct Weight <: EdgeModifier end
==(x::Weight, y::Weight) = true 

struct Start <: EdgeModifier
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
    me1 = ModifiedEdge(Edge(:a, :b), Start(1))
    @test me1 == me1
    me2 = deepcopy(me1)
    @test me1 == me2
    me2.modifiers[:Start] = Start(2)
    @test me1 != me2
    me3 = ModifiedEdge(Edge(:a, :b), [Weight() Start(1)])
    me4 = deepcopy(me3)
    @test me3 == me4
    me5 = ModifiedEdge(Edge(:a, :b), [Start(1) Weight()])
    @test me5 == me3
end

@testset "Arrow" begin
    a1 = :a → :b
    a2 = deepcopy(a1)
    a3 = :b ← :a
    @test a1 == a2
    @test a1 != a3
    @test unmeta(a1) == unmeta(a3)
end
