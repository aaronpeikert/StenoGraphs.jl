using StenoGraphs
using Test, SafeTestsets

@testset "StenoGraphs.jl" begin
    @safetestset "Graph Types" begin
        using StenoGraphs
        include("graph_types.jl")
    end
    @safetestset "Syntax" begin
        using StenoGraphs
        include("syntax.jl")
    end
    @safetestset "Modify Edges" begin
        using StenoGraphs
        include("modification.jl")
    end
    @safetestset "Communative" begin
        using StenoGraphs
        include("comunative.jl")
    end
    @safetestset "Promotion and Conversion" begin
        using StenoGraphs
        include("promotion.jl")
    end

    @safetestset "Comparison" begin
        using StenoGraphs
        include("compare.jl")
    end
end
