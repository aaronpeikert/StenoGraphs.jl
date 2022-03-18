struct Weight <: EdgeModifier
    w
end

struct Start <: EdgeModifier
    s
end

@testset "Declare Communative" begin
    StenoGraphs.@communative foo(a::Weight, b::Start) = a.w * b.s
    @test foo(Weight(2), Start(3)) == foo(Start(3), Weight(2))

    StenoGraphs.@communative function bar(x::Vector{m} where {m <: EdgeModifier}, y::Int)
        length(x)*y
    end
    @test bar([Weight(1), Start(2)], 2) == 4
end