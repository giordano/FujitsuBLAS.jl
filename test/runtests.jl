using FujitsuBLAS
using Test
using LinearAlgebra

@testset "FujitsuBLAS.jl" begin
    @test !iszero(FujitsuBLAS.__init__())
    blases = BLAS.get_config().loaded_libs
    fjblas = findfirst(x -> contains(x.libname, r"libfjlapackexsve_ilp64.so$"), blases)
    @test !isnothing(fjblas)
    @test blases[fjblas].interface === :ilp64
end
