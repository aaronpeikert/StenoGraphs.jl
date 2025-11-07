using StenoGraphs, DataFrames

struct Weight <: StenoGraphs.EdgeModifier w end
struct Start <: StenoGraphs.EdgeModifier s end
struct Label <: StenoGraphs.NodeModifier l end

@testset "DataFrames" begin
    g = @StenoGraph begin
        b → Weight(1)*a
        c → Weight(1)*Start(2)*b
        c^Label("hi") ↔ a
    end
    @test "DstWeight" ∈ names(DataFrame(g))
end