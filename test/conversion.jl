using StenoGraphs
@testset "Conversion" begin
    @test convert(Node,:a) == Node(:a)
end

struct Start{S <: Number} <: EdgeModifier
    s::S
end

struct Label <: NodeModifier
    l
end

@testset "Promotion" begin
    @test eltype([Node(:a), :b]) <: Node
    @test eltype([Node(:a), :b, Start(1) * Node(:c)]) <: AbstractNode
    @test eltype([:b, Start(1) * Node(:c)]) <: AbstractNode
    @test eltype([Start(1) * Node(:b), Start(1) * Node(:c)]) <: MetaNode

    @test eltype(promote(Node(:a), ModifiedNode(Node(:b), Label("hi")))) <: ModifiedNode
    ns = Node.([:a, :b]) .^ Ref(Label("test"))
    ns[1] = Node(:a)
    @test eltype(ns) <: ModifiedNode

    @test eltype([ModifiedEdge(Edge(Node(:a), Node(:b)), Start(3.0)), Edge(Node(:a), Node(:c))]) <: ModifiedEdge
end