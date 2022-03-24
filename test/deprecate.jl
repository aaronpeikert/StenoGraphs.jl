# use of Symbols as node is deprecated
for f in (:DirectedEdge, :UndirectedEdge)
    @eval @test_deprecated $f(:a, :b)
    @eval @test_deprecated $f(:a, Node(:b))
    @eval @test_deprecated $f(Node(:a), :b)
end

struct Weight <: EdgeModifier
    w
end

struct Label <: NodeModifier
    l
end

@test_deprecated :a^Label(2)
@test_deprecated Label(2)^:a

@test_deprecated :a*Weight(2)
@test_deprecated Weight(2)*:a

@test_deprecated keep(:a, StenoGraphs.Left, AbstractNode)
@test_deprecated keep(:a, AbstractNode)