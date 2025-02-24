# --------------------------------------------------------------------------------------------------
using TigerFetch
using Test

using Pkg.Artifacts
using SHA



const testsuite = [
    "assets",
    "downloads",
]

# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
printstyled("Running tests:\n", color=:blue, bold=true)

@testset verbose=true "TigerFetch.jl" begin
    for test in testsuite
        println("\033[1m\033[32m  → RUNNING\033[0m: $(test)")
        include("UnitTests/$(test).jl")
        println("\033[1m\033[32m  PASSED\033[0m")
    end
end
# --------------------------------------------------------------------------------------------------

