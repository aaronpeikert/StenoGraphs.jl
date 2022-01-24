using Semi
using Test, SafeTestsets

@testset "Semi.jl" begin
    @safetestset "Graph Types" begin
        using Semi
        include("test_helper.jl")
        include("graph_types.jl")
    end
    @safetestset "Syntax" begin
        using Semi
        include("test_helper.jl")
        include("syntax.jl")
    end
    @safetestset "Modify Edges" begin
        using Semi
        include("test_helper.jl")
        include("modification.jl")
    end
end
