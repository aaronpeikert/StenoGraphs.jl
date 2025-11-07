using StenoGraphs
using Test, SafeTestsets, Documenter

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
        include("conversion.jl")
    end
    @safetestset "Comparison" begin
        using StenoGraphs
        include("compare.jl")
    end
    @safetestset "Unmeta" begin
        using StenoGraphs
        include("keep.jl")
    end
    @safetestset "Arrow" begin
        using StenoGraphs
        include("arrow.jl")
    end
    @safetestset "Deprecate" begin
        using StenoGraphs
        include("deprecate.jl")
    end
    @safetestset "Ids" begin
        using StenoGraphs
        include("id.jl")
    end
    @safetestset "Meld" begin
        using StenoGraphs
        include("meld.jl")
    end
    @safetestset "Swap" begin
        using StenoGraphs
        include("swap.jl")
    end
    @safetestset "Macro" begin
        using StenoGraphs
        include("macro.jl")
    end
    @safetestset "DataFrames.jl" begin
        using StenoGraphs, DataFrames
        include("DataFrames.jl")
    end
    DocMeta.setdocmeta!(StenoGraphs, :DocTestSetup, :(using StenoGraphs); recursive=true)
    doctest(StenoGraphs)
end
