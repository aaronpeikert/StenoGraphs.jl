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
    @test [Edge(Node(:a), Node(:c)), Edge(Node(:b), Node(:c)), Edge(Node.(:f), Node.(:e))] ==
    @StenoGraph begin
        [a b] → c
        Edge(f, e)
    end
end