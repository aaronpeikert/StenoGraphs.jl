@testset "Quoted Symbol Syntax" begin
    @test (:a → :b) == (StenoGraphs.@quote_symbols a → b)
end

@testset "Addition as hcat" begin
    @test StenoGraphs.addition_to_vector(:(a * b + c)) == :([a * b c])
    @test StenoGraphs.addition_to_vector(:(a * (b + c))) == :(a * [b c])
end

@testset "Broadcasting Edges" begin
    @test Edge(:a, [:b :c]) == vec([Edge(:a, :b) Edge(:a, :c)])
    @test Edge([:a :b], :c) == vec([Edge(:a, :c) Edge(:b, :c)])
    @test Edge([:a :b], [:c :d]) == vec([Edge(:a, :c) Edge(:a, :d) Edge(:b, :c) Edge(:b, :d)])
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