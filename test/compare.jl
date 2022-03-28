import Base.==
struct Weight <: EdgeModifier end
==(x::Weight, y::Weight) = true 

struct Start <: EdgeModifier
    s::Number
end
==(x::Start, y::Start) = x.s == y.s

struct Observed <: NodeModifier end

@testset "Modifier" begin
    @test [Start(1) Weight()] == [Start(1) Weight()]
    @test [Start(1) Weight()] == [Weight() Start(1)]
end

@testset "Node" begin
    @test Node(:a) == Node(:a)
    @test Node(:a) != Node(:b)
    a = ModifyingNode(Node(:a), [Start(1) Weight()])
    @test a == deepcopy(a)
    @test ModifyingNode(Node(:a), [Start(1) Weight()]) == ModifyingNode(Node(:a), [Start(1) Weight()])
    b = ModifiedNode(Node(:a), Observed())
    @test b == deepcopy(b)
end

@testset "UndirectedEdge" begin
    @test UndirectedEdge(Node(:a), Node(:b)) == UndirectedEdge(Node(:b), Node(:a))
end

@testset "DirectedEdge" begin
    me1 = ModifiedEdge(Edge(Node(:a), Node(:b)), Start(1))
    @test me1 == me1
    me2 = deepcopy(me1)
    @test me1 == me2
    me2.modifiers[:Start] = Start(2)
    @test me1 != me2
    me3 = ModifiedEdge(Edge(Node(:a), Node(:b)), [Weight() Start(1)])
    me4 = deepcopy(me3)
    @test me3 == me4
    me5 = ModifiedEdge(Edge(Node(:a), Node(:b)), [Start(1) Weight()])
    @test me5 == me3
end

@testset "Arrow" begin
    a1 = Node(:a) → Node(:b)
    a2 = deepcopy(a1)
    a3 = Node(:b) ← Node(:a)
    @test a1 == a2
    @test a1 != a3
    @test unmeta(a1) == unmeta(a3)
end

@testset "Hash of UndirectedEdge" begin
    e1 = UndirectedEdge(Node(:a), Node(:b))
    e2 = UndirectedEdge(Node(:b), Node(:a))
    me1 = ModifiedEdge(e1, Weight())
    me2 = ModifiedEdge(e2, Weight())
    @test hash(e1) == hash(e2)
    @test hash(me1) == hash(me2)
    @test length(unique([e1, e2])) == 1
    @test length(unique([me1, me2])) == 1
end
