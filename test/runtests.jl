using Semi
using Test, SafeTestsets

@testset "Semi.jl" begin
    @safetestset "Graph Types" begin
        using Semi
        include("graph_types.jl")
    end
    @safetestset "Syntax" begin
        using Semi
        include("syntax.jl")
    end
    @safetestset "Modify Edges" begin
        using Semi
        include("modification.jl")
    end
end
