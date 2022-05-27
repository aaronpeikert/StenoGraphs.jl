switch(x::T) where {T <: Edge} = T(x.dst, x.src)
switch(x::T) where {T <: ModifiedEdge} = T(switch(x.edge), x.modifiers)
undirect(x::DirectedEdge) = UndirectedEdge(x.src, x.dst)
undirect(x::ModifiedEdge) = ModifiedEdge(undirect(x.edge), x.modifiers)

@testset "Single Arrow" begin
    result = Edge(Node(:a), Node(:b))
    @test unarrow(Node(:a) → Node(:b))[1] == result
    @test unarrow(Node(:a) ⇒ Node(:b))[1] == result
    @test unarrow(Node(:a) ← Node(:b))[1] == switch(result)
    @test unarrow(Node(:a) ⇐ Node(:b))[1] == switch(result)
    @test unarrow(Node(:a) ↔ Node(:b))[1] == undirect(result)
    @test unarrow(Node(:a) ⇔ Node(:b))[1] == undirect(result)
    @test unarrow(Node(:a) ⇔ Node(:b))[1] == undirect(switch(result))
end

@testset "Single Chain" begin
    result = [Edge(Node(:a), Node(:b)), Edge(Node(:b), Node(:c))]
    @test unarrow(Node(:a) → Node(:b) → Node(:c)) == result
    @test unarrow(Node(:a) ⇒ Node(:b) ⇒ Node(:c)) == result
    @test unarrow(Node(:a) → Node(:b) ⇒ Node(:c)) == result

    @test unarrow(Node(:a) ← Node(:b) ← Node(:c)) == switch.(result)
    @test unarrow(Node(:a) ⇐ Node(:b) ← Node(:c)) == switch.(result)
    @test unarrow(Node(:a) ⇐ Node(:b) ⇐ Node(:c)) == switch.(result)

    @test unarrow(Node(:a) ↔ Node(:b) ↔ Node(:c)) == undirect.(switch.(result))
    @test unarrow(Node(:a) ⇔ Node(:b) ↔ Node(:c)) == undirect.(switch.(result))
    @test unarrow(Node(:a) ⇔ Node(:b) ⇔ Node(:c)) == undirect.(switch.(result))
end

@testset "Multiple Nodes Arrow" begin
    bresult = [Edge(Node(:a), Node(:c)); Edge(Node(:b), Node(:d))]
    cresult = [Edge(Node(:a), Node(:c)); Edge(Node(:a), Node(:d)); Edge(Node(:b), Node(:c)); Edge(Node(:b), Node(:d))]
    @test unarrow(Node.([:a :b]) → Node.([:c :d])) ⊆ bresult
    @test unarrow(Node.([:a :b]) ← Node.([:c :d])) ⊆ switch.(bresult)

    @test unarrow(Node.([:a :b]) ⇒ Node.([:c :d])) ⊆ cresult
    @test unarrow(Node.([:a :b]) ⇐ Node.([:c :d])) ⊆ switch.(cresult)

    @test unarrow(Node.([:a :b]) ↔ Node.([:c :d])) ⊆ undirect.(bresult)
    @test unarrow(Node.([:a :b]) ⇔ Node.([:c :d])) ⊆ undirect.(cresult)
end

@testset "Multiple Nodes Chain" begin
    bresult = [Edge(Node(:a), Node(:c)); Edge(Node(:b), Node(:d)); Edge(Node(:c), Node(:e)); Edge(Node(:d), Node(:f)); Edge(Node(:e), Node(:g)); Edge(Node(:f), Node(:h))]
    cresult = [Edge(Node(:a), Node(:c)); Edge(Node(:b), Node(:d)); Edge(Node(:c), Node(:e)); Edge(Node(:d), Node(:f)); Edge(Node(:e), Node(:g)); Edge(Node(:f), Node(:h));
    Edge(Node(:b), Node(:c)); Edge(Node(:a), Node(:d)); Edge(Node(:d), Node(:e)); Edge(Node(:c), Node(:f)); Edge(Node(:f), Node(:g)); Edge(Node(:e), Node(:h))]

    @test unarrow(Node.([:a :b]) → Node.([:c :d]) → Node.([:e :f]) → Node.([:g :h])) ⊆ bresult
    @test unarrow(Node.([:a :b]) ← Node.([:c :d]) ← Node.([:e :f]) ← Node.([:g :h])) ⊆ switch.(bresult)

    @test unarrow(Node.([:a :b]) ⇒ Node.([:c :d]) ⇒ Node.([:e :f]) ⇒ Node.([:g :h])) ⊆ cresult
    @test unarrow(Node.([:a :b]) ⇐ Node.([:c :d]) ⇐ Node.([:e :f]) ⇐ Node.([:g :h])) ⊆ switch.(cresult)

    @test unarrow(Node.([:a :b]) ↔ Node.([:c :d]) ↔ Node.([:e :f]) ↔ Node.([:g :h])) ⊆ undirect.(bresult)
    @test unarrow(Node.([:a :b]) ⇔ Node.([:c :d]) ⇔ Node.([:e :f]) ⇔ Node.([:g :h])) ⊆ undirect.(cresult)
end

struct Start <: EdgeModifier
    s
end

struct Weight <: EdgeModifier
    w
end

@testset "Modified  Chain" begin
    # correct placement of modifiers
    result = ModifiedEdge(Edge(Node(:a), Node(:b)), [Start(4)])
    @test unarrow(Node(:a) → Start(4)*Node(:b))[1] == result
    @test unarrow(Start(4) * Node(:a) ← Node(:b))[1] == switch(result)
    @test unarrow(Node(:a) ↔ Node(:b) * Start(4))[1] == undirect(result)

    #incorrect placed modifiers are silently ignored
    @test unarrow(Start(4) * Node(:a) → Node(:b))[1] == unmeta(result)
    @test unarrow(Node(:a) ← Node(:b) * Start(4))[1] == unmeta(switch(result))
    @test unarrow(Start(4) * Node(:a) ↔ Node(:b))[1] == unmeta(undirect(result))

end

@testset "NodeModifier remain on both sides" begin
    struct Label <: NodeModifier
        l
    end

    @test unarrow(Node(:a)^Label("A") → Node(:b)^Label("B"))[1] ==
        Edge(ModifiedNode(Node(:a), Label("A")), ModifiedNode(Node(:b), Label("B")))
    

end
