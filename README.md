# TigerFetch

This package downloads TIGER/Line shapefiles from the US Census Bureau FTP server.

This was written for personal use and to learn about julia's capabilities to generate cli tools.
Thus the package is fairly lean and does not convert shapefiles into dataframes or GeoJSON.
The package has only been tested for the 2024 files, but could be extended to accomodate other vintages.
For serious use, you'd probably be better off using [tigris](https://github.com/walkerke/tigris)

What the package does is provide a convenient interface to pull file from the Census. 
You can always check what is directly available on the [ftp server.](https://www2.census.gov/geo/tiger)



## Installation

#### Command line tool
Install the command line tool (you need a julia installation for this)
```bash
mkdir -p /.local/share/julia # or some other directory 
git clone git@github.com:eloualiche/TigerFetch.jl.git  ~/.local/share/julia
cd ~/.local/share/julia  && julia --project deps/build.jl install
```

The binary will available at `~/.julia/bin/tigerfetch` but also depends on the downloaded packages.
An easier way is to install the package directly from julia. 

#### Julia package

TigerFetch.jl is not yet a registered package. 
You can install it from github via
```julia
import Pkg
Pkg.add(url="https://github.com/eloualiche/TigerFetch.jl")
```

Then install the cli tool with
```julia
using TigerFetch; TigerFetch.comonicon_install()
````



## Usage

#### Command line tool

You can use it 
```bash
~/.julia/bin/tigerfetch --help
~/.julia/bin/tigerfetch state --output tmp
~/.julia/bin/tigerfetch cousub --state IL --output tmp 
~/.julia/bin/tigerfetch areawater --state "Minnesota" --output tmp # 10,000 lakes
~/.julia/bin/tigerfetch areawater --state "MN" --county "Hennepin" --output tmp 
```


#### Julia package

Look at the [doc](https://eloualiche.github.io/TigerFetch.jl/dev/) or at the test suite (specifically `UnitTests/downloads.jl`).

This [issue](#4) tracks which geographies have been implemented thus far. 




[![CI](https://github.com/eloualiche/TigerFetch.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/eloualiche/TigerFetch.jl/actions/workflows/CI.yml)
[![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://github.com/eloualiche/Prototypes.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/eloualiche/TigerFetch.jl/graph/badge.svg?token=OZRTOQU9H6)](https://codecov.io/gh/eloualiche/TigerFetch.jl)

[![][docs-latest-img]][docs-latest-url]



[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://eloualiche.github.io/TigerFetch.jl/
