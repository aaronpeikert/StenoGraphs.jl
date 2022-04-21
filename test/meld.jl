using StenoGraphs

struct Start{S <: Number} <: EdgeModifier
    s::S
end

struct Weight{S <: Number} <: EdgeModifier
    s::S
end

struct Label <: NodeModifier
    l
end

@testset "Merge Edges" begin
    e1 = Edge(Node(:a), Node(:b))
    e2 = e1 * Weight(2)
    e3 = e1 * Start(4)

    @test merge(e1, e2) == e2
    @test merge(e2, e3) == e2 * Start(4)
    e4 = Edge(Node(:a), Node(:c))
    @test_throws StenoGraphs.EdgeMismatch merge(e1, e4)
end

@testset "Merge Nodes" begin
    n1 = Node(:a)
    n2 = n1 ^ Label("hi")
    @test merge(n1, n1) == n1
    @test merge(n1, n2) == n2
    @test merge(n2, n2) == n2

    n3 = n1 * Weight(1)
    n4 = n1 * Start(1)
    @test merge(n1, n3) == n3
    @test merge(n3, n4) == n3 * Start(1)
    @test_throws StenoGraphs.NodeMismatch merge(n2, n3)

    n5 = Node(:b) * Weight(1)
    @test_throws StenoGraphs.NodeMismatch merge(n1, n5)
end

@testset "Merge Nodes" begin
    let err = nothing
        n2 = Node(:a) ^ Label("hi")
        n3 = Node(:b) * Start(1)
        try
            merge(n2, n3)
        catch err
        end
    
        @test err isa Exception
        @test  occursin("$n3 ≠ $n2", sprint(showerror, err))
    end
    let err = nothing
        e1 = Edge(Node(:a), Node(:b))
        e4 = Edge(Node(:a), Node(:c))
        try
            merge(e1, e4)
        catch err
        end
    
        @test err isa Exception
        @test  occursin("$e1 ≠ $e4", sprint(showerror, err))
    end
end
