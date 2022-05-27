struct Weight <: EdgeModifier
    w
end

struct Observed <: NodeModifier end

struct Label <: NodeModifier l end
import Base.==
==(x::Label, y::Label) = x.l == y.l

@testset "Swap Node <-> Node" begin
    n1 = Node(:a)
    n2 = Node(:b)
    @test swap_node(n1, n1, n2) == swap_node(n1, n1 => n2) == n2
    @test swap_node(n1 ^ Observed(), n1, n2) == swap_node(n1 ^ Observed(), n1 => n2) == n2 ^ Observed()
    @test swap_node(n1 * Weight(1), n1, n2) == n2 * Weight(1)
    @test swap_node(n1 ^ Label("hi"), n1 ^ Label("hi"), n2 * Observed()) == n2 * Observed()
    @test swap_node(n1, n1, n1 ^ Label("hi")) == n1 ^ Label("hi")
end

@testset "Swap Nodes in Edges" begin
    for e in (:DirectedEdge, :UndirectedEdge)
        @eval begin
            n1 = Node(:a)
            n2 = Node(:b)
            n3 = Node(:c)
            e1 = $e(n1, n2)
            e3 = $e(n3, n2)
            @test swap_node(e1, n1, n3) == e3
            @test swap_node(e1, n2, n3) == $e(n1, n3)
            @test swap_node(e1 * Weight(1), n1, n3) == e3 * Weight(1)
            @test swap_node($e(n1 ^ Label("hi"), n2), n1 ^ Label("hi"), n3 ^ Label("ho")) == $e(n3 ^ Label("ho"), n2)
        end
    end
end

@testset "Swap Edges" begin
    for e in (:DirectedEdge, :UndirectedEdge)
        @eval begin
            n1 = Node(:a)
            n2 = Node(:b)
            n3 = Node(:c)
            e1 = $e(n1, n2)
            e3 = $e(n3, n2)
            @test swap_edge(e1, e1, e3) == swap_edge(e1, e1 => e3) == e3
            @test swap_edge(e1 * Weight(1), e1, e3) == e3 * Weight(1)
            @test swap_edge(e1, e1, e1 * Weight(1)) == e1 * Weight(1)
        end
    end
end

@testset "Swap nonexistent nodes" begin
    n1 = Node(:a)
    @test_throws KeyError swap_node(n1, Node(:c), Node(:d))

    e1 = Edge(Node(:a), Node(:b))
    @test_throws KeyError swap_node(e1, Node(:c), Node(:d))
end
