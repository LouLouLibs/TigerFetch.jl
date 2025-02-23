# TigerFetch

Install the command line tool (you need a julia installation for this)
```bash
julia --project deps/build.jl install
```

The binary will available at `~/.julia/bin/tigerfetch`.
You can use it 
```bash
~/.julia/bin/tigerfetch --help
~/.julia/bin/tigerfetch state
~/.julia/bin/tigerfetch cousub --state IL
~/.julia/bin/tigerfetch areawater --state "Minnesota" # 10,000 lakes
~/.julia/bin/tigerfetch areawater --state "Minnesota" --county "Hennepin" 
```

