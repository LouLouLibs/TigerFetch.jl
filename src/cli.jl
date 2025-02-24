

# -------------------------------------------------------------------------------------------------
"""
  tigerfetch(type, year)

Download shapefiles for US geography from the Census Tiger ftp server.

# Intro



# Args

- `type`: Geography type (state, county, cousub, tract)
- `year`: Data year (default: 2024)

# Options

- `--state`: State identifier (name, abbreviation, or FIPS)
- `--county`: County identifier (name or FIPS, requires --state)
- `--output`: Output directory (default: current directory)
- `--force`: Override existing files

# Examples
tigerfetch state
tigerfetch cousub --state IL
tigerfetch areawater --state "Minnesota" # 10,000 lakes
"""
@main function tigerfetch(
    type::String, year::Int=2024;
    state::String="",
    county::String="",
    output::String=pwd(),
    force::Bool=false)

    tigerdownload(type, year; state=state, county=county, output=output, force=force)

end
# -------------------------------------------------------------------------------------------------



