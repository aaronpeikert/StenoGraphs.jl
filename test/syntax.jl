@testset "Quoted Symbol Syntax" begin
    @test Edge(:a, :b) ≂ Semi.@quote_symbols a → b
end

@testset "Addition as hcat" begin
    @test Semi.addition_to_vector(:(a * b + c)) == :([a * b c])
    @test Semi.addition_to_vector(:(a * (b + c))) == :(a * [b c])
end

@testset "Broadcasting Edges" begin
    @test Edge(:a, [:b :c]) ≂ vec([Edge(:a, :b) Edge(:a, :c)])
    @test Edge([:a :b], :c) ≂ vec([Edge(:a, :c) Edge(:b, :c)])
    @test Edge([:a :b], [:c :d]) ≂ vec([Edge(:a, :c) Edge(:a, :d) Edge(:b, :c) Edge(:b, :d)])
end
