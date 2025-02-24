module TigerFetch


# --------------------------------------------------------------------------------------------------
import Comonicon: @cast, @main
import Downloads
import Pkg
# using Infiltrator
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
include("artifacts.jl")
include("geotypes.jl")  # Internal type system
include("reference.jl")
include("download.jl")
include("main.jl")
include("cli.jl")
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------#
# Export types
# export download_shapefile # this actually relies on internal types ... that we might not want to export
# Export CLI function
export tigerdownload  # the julia function 
# export tigerfetch     # the cli function
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------



end # module
