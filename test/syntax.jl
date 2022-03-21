@testset "Quoted Symbol Syntax" begin
    @test (:a → :b) == (StenoGraphs.@quote_symbols a → b)
    b = :c
    @test (:a → :c) == (StenoGraphs.@quote_symbols a → _(b))
    let err = nothing
        try
            eval(:(StenoGraphs.@quote_symbols a → _(b, c)))
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
    @test Edge(:a, [:b :c]) == vec([Edge(:a, :b) Edge(:a, :c)])
    @test Edge([:a :b], :c) == vec([Edge(:a, :c) Edge(:b, :c)])
    @test Edge([:a :b], [:c :d]) == vec([Edge(:a, :c) Edge(:a, :d) Edge(:b, :c) Edge(:b, :d)])
end

@testset "Singleline Arrows" begin
    @test [Edge(:a, :c), Edge(:b, :c)] == @StenoGraph [a b] → c
end

@testset "Multiline Arrows" begin
    @test [Edge(:a, :c), Edge(:b, :c), Edge(:f, :e)] == @StenoGraph begin
        [a b] → c
        e ← f
    end
end


@testset "Multiline Mix Arrow Edge" begin
    @test [Edge(:a, :c), Edge(:b, :c), Edge(:f, :e)] ==
    @StenoGraph begin
        [a b] → c
        Edge(f, e)
    end
end