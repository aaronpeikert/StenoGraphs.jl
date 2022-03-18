switch(x::T) where {T <: Edge} = T(x.dst, x.src)
switch(x::T) where {T <: ModifiedEdge} = T(switch(x.edge), x.modifiers)
undirect(x::DirectedEdge) = UndirectedEdge(x.src, x.dst)
undirect(x::ModifiedEdge) = ModifiedEdge(undirect(x.edge), x.modifiers)

@testset "Single Arrow" begin
    result = Edge(:a, :b)
    @test unarrow(:a → :b)[1] == result
    @test unarrow(:a ⇒ :b)[1] == result
    @test unarrow(:a ← :b)[1] == switch(result)
    @test unarrow(:a ⇐ :b)[1] == switch(result)
    @test unarrow(:a ↔ :b)[1] == undirect(result)
    @test unarrow(:a ⇔ :b)[1] == undirect(result)
    @test unarrow(:a ⇔ :b)[1] == undirect(switch(result))
end

@testset "Single Chain" begin
    result = [Edge(:a, :b), Edge(:b, :c)]
    @test unarrow(:a → :b → :c) == result
    @test unarrow(:a ⇒ :b ⇒ :c) == result
    @test unarrow(:a → :b ⇒ :c) == result

    @test unarrow(:a ← :b ← :c) == switch.(result)
    @test unarrow(:a ⇐ :b ← :c) == switch.(result)
    @test unarrow(:a ⇐ :b ⇐ :c) == switch.(result)

    @test unarrow(:a ↔ :b ↔ :c) == undirect.(switch.(result))
    @test unarrow(:a ⇔ :b ↔ :c) == undirect.(switch.(result))
    @test unarrow(:a ⇔ :b ⇔ :c) == undirect.(switch.(result))
end

@testset "Multiple Nodes Arrow" begin
    bresult = [Edge(:a, :c); Edge(:b, :d)]
    cresult = [Edge(:a, :c); Edge(:a, :d); Edge(:b, :c); Edge(:b, :d)]
    @test unarrow([:a :b] → [:c :d]) ⊆ bresult
    @test unarrow([:a :b] ← [:c :d]) ⊆ switch.(bresult)

    @test unarrow([:a :b] ⇒ [:c :d]) ⊆ cresult
    @test unarrow([:a :b] ⇐ [:c :d]) ⊆ switch.(cresult)

    @test unarrow([:a :b] ↔ [:c :d]) ⊆ undirect.(bresult)
    @test unarrow([:a :b] ⇔ [:c :d]) ⊆ undirect.(cresult)
end

@testset "Multiple Nodes Chain" begin
    bresult = [Edge(:a, :c); Edge(:b, :d); Edge(:c, :e); Edge(:d, :f); Edge(:e, :g); Edge(:f, :h)]
    cresult = [Edge(:a, :c); Edge(:b, :d); Edge(:c, :e); Edge(:d, :f); Edge(:e, :g); Edge(:f, :h);
    Edge(:b, :c); Edge(:a, :d); Edge(:d, :e); Edge(:c, :f); Edge(:f, :g); Edge(:e, :h)]

    @test unarrow([:a :b] → [:c :d] → [:e :f] → [:g :h]) ⊆ bresult
    @test unarrow([:a :b] ← [:c :d] ← [:e :f] ← [:g :h]) ⊆ switch.(bresult)

    @test unarrow([:a :b] ⇒ [:c :d] ⇒ [:e :f] ⇒ [:g :h]) ⊆ cresult
    @test unarrow([:a :b] ⇐ [:c :d] ⇐ [:e :f] ⇐ [:g :h]) ⊆ switch.(cresult)

    @test unarrow([:a :b] ↔ [:c :d] ↔ [:e :f] ↔ [:g :h]) ⊆ undirect.(bresult)
    @test unarrow([:a :b] ⇔ [:c :d] ⇔ [:e :f] ⇔ [:g :h]) ⊆ undirect.(cresult)
end

struct Start <: EdgeModifier
    s
end

struct Weight <: EdgeModifier
    w
end

@testset "Modified  Chain" begin
    # correct placement of modifiers
    result = ModifiedEdge(Edge(:a, :b), [Start(4)])
    @test unarrow(:a → Start(4)*:b)[1] == result
    @test unarrow(Start(4) * :a ← :b)[1] == switch(result)
    @test unarrow(:a ↔ :b * Start(4))[1] == undirect(result)

    #incorrect
    @test unarrow(Start(4) * :a → :b)[1] == result.edge
    @test unarrow(:a ← :b * Start(4))[1] == switch(result).edge
    @test unarrow(Start(4) * :a ↔ :b)[1] == undirect(result).edge

end
