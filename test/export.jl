@testset "Re-exported @StenoGraph resolves without StenoGraphs in scope" begin
    # Simulate a downstream package that re-exports @StenoGraph and arrows.
    # The macro should work without `SimpleNode`, `StenoGraph`, or
    # `convert_symbol` being directly available in the end-user's namespace.
    # https://github.com/aaronpeikert/StenoGraphs.jl/issues/73
    m = @eval module _ReExportTest
        using StenoGraphs: @StenoGraph, →, ←, ↔
        export @StenoGraph, →, ←, ↔
    end
    # Use the re-exported macro from an "end-user" context
    # that has no direct access to StenoGraphs internals.
    result = @eval module _EndUserTest
        using ..$(nameof(m)): @StenoGraph, →, ←, ↔
        using StenoGraphs: Node, Edge
        graph = @StenoGraph a → b
        addition = @StenoGraph a + b → c
        multiline = @StenoGraph begin
            a → b
            c ← d
        end
    end
    @test result.graph == [Edge(Node(:a), Node(:b))]
    @test result.addition == [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c))]
    @test result.multiline == [Edge(Node(:a), Node(:b)), Edge(Node(:d), Node(:c))]
end