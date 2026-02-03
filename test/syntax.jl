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

@testset "Let-style @StenoGraph (inline)" begin
    # Basic
    @test @StenoGraph(let a, b; a → b; end) == [Edge(Node(:a), Node(:b))]

    # Chain arrows
    @test @StenoGraph(let a, b, c; a → b → c; end) ==
        [Edge(Node(:a), Node(:b)), Edge(Node(:b), Node(:c))]

    # Addition syntax (+ → hcat)
    @test @StenoGraph(let a, b, c; a + b → c; end) ==
        [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c))]

    # Multiline block
    @test @StenoGraph(let a, b, c, d
        a → b
        c → d
    end) == [Edge(Node(:a), Node(:b)), Edge(Node(:c), Node(:d))]

    # Scoping: variables don't leak
    @StenoGraph let _let_scope_a, _let_scope_b
        _let_scope_a → _let_scope_b
    end
    @test !@isdefined(_let_scope_a)
    @test !@isdefined(_let_scope_b)

    # External variables work without _() escape
    let ext = Node(:ext)
        @test @StenoGraph(let a; a → ext; end) ==
            [Edge(Node(:a), Node(:ext))]
    end

    # Arrow directions
    @test @StenoGraph(let a, b; a ← b; end) == [Edge(Node(:b), Node(:a))]
    @test @StenoGraph(let a, b; a ↔ b; end) == [UndirectedEdge(Node(:a), Node(:b))]
end

@testset "Let-style @StenoGraph (splat from collection)" begin
    # Basic splat
    nodes = [Node(:a), Node(:b)]
    @test @StenoGraph(let nodes...; a → b; end) == [Edge(Node(:a), Node(:b))]

    # Addition syntax
    nodes = [Node(:a), Node(:b), Node(:c)]
    @test @StenoGraph(let nodes...; a + b → c; end) ==
        [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c))]

    # Multiline
    nodes = [Node(:a), Node(:b), Node(:c)]
    @test @StenoGraph(let nodes...
        a → b
        b → c
    end) == [Edge(Node(:a), Node(:b)), Edge(Node(:b), Node(:c))]

    # Preserves ModifiedNode
    struct _TestLabelSplat <: NodeModifier; l::String; end
    mod_nodes = [ModifiedNode(Node(:a), _TestLabelSplat("A")), Node(:b)]
    result = @StenoGraph let mod_nodes...
        a → b
    end
    @test result[1].src isa ModifiedNode

    # Duplicate ids: last wins
    dup_nodes = [Node(:a), ModifiedNode(Node(:a), _TestLabelSplat("A2")), Node(:b)]
    result = @StenoGraph let dup_nodes...
        a → b
    end
    @test result[1].src isa ModifiedNode

    # Symbol vector (like declare_nodes_from)
    syms = [:x, :y]
    @test @StenoGraph(let syms...; x → y; end) == [Edge(Node(:x), Node(:y))]

    # Multiple splats
    nodes1 = [Node(:a), Node(:b)]
    nodes2 = [Node(:c), Node(:d)]
    @test @StenoGraph(let nodes1..., nodes2...
        a → c
        b → d
    end) == [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:d))]

    # Mixed bare symbols + splat
    nodes = [Node(:c), Node(:d)]
    @test @StenoGraph(let a, b, nodes...
        a → c
        b → d
    end) == [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:d))]

    # Scoping: variables don't leak
    _splat_scope_nodes = [Node(:_splat_scope_a), Node(:_splat_scope_b)]
    @StenoGraph let _splat_scope_nodes...
        _splat_scope_a → _splat_scope_b
    end
    @test !@isdefined(_splat_scope_a)
    @test !@isdefined(_splat_scope_b)
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