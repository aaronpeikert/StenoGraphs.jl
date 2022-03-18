@testset "Quoted Symbol Syntax" begin
    @test Edge(:a, :b) ≂ StenoGraphs.@quote_symbols a → b
end

@testset "Addition as hcat" begin
    @test StenoGraphs.addition_to_vector(:(a * b + c)) == :([a * b c])
    @test StenoGraphs.addition_to_vector(:(a * (b + c))) == :(a * [b c])
end

@testset "Broadcasting Edges" begin
    @test Edge(:a, [:b :c]) ≂ vec([Edge(:a, :b) Edge(:a, :c)])
    @test Edge([:a :b], :c) ≂ vec([Edge(:a, :c) Edge(:b, :c)])
    @test Edge([:a :b], [:c :d]) ≂ vec([Edge(:a, :c) Edge(:a, :d) Edge(:b, :c) Edge(:b, :d)])
end
