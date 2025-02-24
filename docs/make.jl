#!/usr/bin/env julia
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
# from within doc
import Pkg; Pkg.develop(path="..")
using TigerFetch
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
# Pkg.add(["Documenter", "DocumenterVitepress"])
using Documenter
using DocumenterVitepress

# -- 
makedocs(
    # format = Documenter.HTML(),
    format = MarkdownVitepress(
        repo = "https://github.com/eloualiche/TigerFetch.jl",
    ),
    repo = Remotes.GitHub("eloualiche", "TigerFetch.jl"),
    sitename = "TigerFetch.jl",
    modules  = [TigerFetch],
    authors = "Erik Loualiche",
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "man/cli.md",
            "man/julia.md"
        ],
        "Demos" => [
            "demo/simple_map.md",
        ],
        "Library" => [
            "lib/public.md",
            "lib/internals.md"
        ]
    ]
)

# --
deploydocs(;
    repo = "github.com/eloualiche/TigerFetch.jl",
    target = "build", # this is where Vitepress stores its output
    devbranch = "main",
    branch = "gh-pages",
    push_preview = true,
)
# --------------------------------------------------------------------------------------------------