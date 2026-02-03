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
    @test_throws UndefVarError StenoGraphs.Edge
    using StenoGraphs # note results is already constructed without StenoGraphs availible
    @test result.graph == [Edge(Node(:a), Node(:b))]
    @test result.addition == [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c))]
    @test result.multiline == [Edge(Node(:a), Node(:b)), Edge(Node(:d), Node(:c))]

    # Let-style forms also work when re-exported
    result_let = @eval module _EndUserTestLet
        using ..$(nameof(m)): @StenoGraph, →, ←, ↔
        using StenoGraphs: Node, Edge
        graph = @StenoGraph let a, b
            a → b
        end
    end
    @test result_let.graph == [Edge(Node(:a), Node(:b))]

    result_splat = @eval module _EndUserTestSplat
        using ..$(nameof(m)): @StenoGraph, →, ←, ↔
        using StenoGraphs: Node, Edge
        nodes = [Node(:a), Node(:b)]
        graph = @StenoGraph let nodes...
            a → b
        end
    end
    @test result_splat.graph == [Edge(Node(:a), Node(:b))]
end