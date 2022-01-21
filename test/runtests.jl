using Semi
using Test

@testset "Semi.jl" begin
    include("graph_types.jl")
    include("syntax.jl")
    include("modification.jl")
end
