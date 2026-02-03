@testset "Quoted Symbol Syntax" begin
    @test (Node(:a) → Node(:b)) == (StenoGraphs.@variable_as_node a → b)
    b = Node(:c)
    @test (Node(:a) → Node(:c)) == (StenoGraphs.@variable_as_node a → _(b))
    let err = nothing
        try
            eval(:(StenoGraphs.@variable_as_node a → _(b, c)))
        catch err
        end

        @test err isa Exception
        @test  occursin("Unqote only a single argument. Right: `_(x)`, Wrong: `_(x, y)`.", sprint(showerror, err))
    end
    @test StenoGraphs.@variable_as_node(_(:a)) == Node(:a)
    @test StenoGraphs.@variable_as_node(_([:a, :b])) == Node[:a, :b]
end

@testset "Addition as hcat" begin
    @test StenoGraphs.addition_to_vector!(:(a * b + c)) == :([a * b c])
    @test StenoGraphs.addition_to_vector!(:(a * (b + c))) == :(a * [b c])
end

@testset "Broadcasting Edges" begin
    @test Edge(Node(:a), [Node(:b) Node(:c)]) == vec([Edge(Node(:a), Node(:b)) Edge(Node(:a), Node(:c))])
    @test Edge([Node(:a) Node(:b)], Node(:c)) == vec([Edge(Node(:a), Node(:c)) Edge(Node(:b), Node(:c))])
    @test Edge([Node(:a) Node(:b)], [Node(:c) Node(:d)]) == vec([Edge(Node(:a), Node(:c)) Edge(Node(:a), Node(:d)) Edge(Node(:b), Node(:c)) Edge(Node(:b), Node(:d))])
end

@testset "Singleline Arrows" begin
    @test [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c))] == @StenoGraph [a b] → c
end

if VERSION ≥ v"1.12-"
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
end


@testset "Multiline Arrows" begin
    @test [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c)), Edge(Node.(:f), Node.(:e))] == @StenoGraph begin
        [a b] → c
        e ← f
    end
end


@testset "Multiline Mix Arrow Edge" begin
    @test [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c)), Edge(Node(:f), Node(:e))] ==
    @StenoGraph begin
        [a b] → c
        Edge(f, e)
    end
end


@testset "Nested Graphs" begin
    @test [Edge(Node(:a), Node(:b)), Edge(Node(:b), Node(:c))] ==
    @StenoGraph begin
        _(@StenoGraph a → b)
        b → c
    end
end

@testset "Broadcast in variable_as_node! should not turn functions into nodes" begin
    # https://github.com/aaronpeikert/StenoGraphs.jl/issues/63
    # Function names are escaped to resolve in caller context
    @test StenoGraphs.variable_as_node!(:(fun.(a))) == Expr(:., Expr(:escape, :fun), Expr(:tuple, :(SimpleNode(:a))))
    @test StenoGraphs.variable_as_node!(:(fun(a))) == Expr(:call, Expr(:escape, :fun), :(SimpleNode(:a)))
end

@testset "Macro hygiene: SimpleNode resolved via Julia hygiene, not module-qualification" begin
    # variable_as_node! produces bare SimpleNode (not StenoGraphs.SimpleNode).
    # Julia's macro hygiene resolves it from the defining module.
    @test StenoGraphs.variable_as_node!(:a) == Expr(:call, :SimpleNode, QuoteNode(:a))

    # Function names in calls are escaped so user-defined types resolve
    # in the caller's scope, not in StenoGraphs.
    ex = StenoGraphs.variable_as_node!(:(MyFunc(a)))
    @test ex.args[1] == Expr(:escape, :MyFunc)
    @test ex.args[2] == Expr(:call, :SimpleNode, QuoteNode(:a))
    expanded = @macroexpand(StenoGraphs.@variable_as_node a)
    # @macroexpand resolves hygiene to a GlobalRef, so compare string representation
    @test string(expanded) == string(:(StenoGraphs.SimpleNode(:a)))
end