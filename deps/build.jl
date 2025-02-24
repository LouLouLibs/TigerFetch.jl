#!/usr/bin/env julia

# Get the project directory
project_dir = dirname(dirname(@__FILE__))
@info project_dir 

# Activate and instantiate the project
import Pkg
Pkg.activate(project_dir)
Pkg.instantiate()

# Now we can safely use the package
using TigerFetch
TigerFetch.comonicon_install()