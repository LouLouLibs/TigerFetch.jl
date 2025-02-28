# --------------------------------------------------------------------------------------------------
const GEOGRAPHY_TYPES = Dict(
    "state" => State,
    "county" => County,
    "zipcode" => ZipCode,
    "urbanarea" => UrbanArea,
    "primaryroads" => PrimaryRoads,
    "cbsa" => CBSA,
    "csa" => CSA,
    "metrodivision" => METDIV,
    "rails" => Rails,

    "cousub" => CountySubdivision,
    "tract" => Tract,
    "place" => Place,
    "consolidatedcity" => ConCity,
    "primarysecondaryroads" => PrimarySecondaryRoads,

    "areawater" => AreaWater,
    "linearwater" => LinearWater,
    "road" => Roads,

)
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
"""
    tigerdownload(type::String, year::Int=2024;
                 state::String="", county::String="",
                 output::String=pwd(), force::Bool=false,
                 verbose::Bool=false)

Download TIGER/Line shapefiles from the U.S. Census Bureau.

# Arguments
- `type::String`: Geography type. Available options: $(join(keys(GEOGRAPHY_TYPES), ", ")).
- `year::Int=2024`: Data year. Census typically provides shapefiles from 2000 onward.

# Keyword Arguments
- `state::String=""`: State identifier (name, abbreviation, or FIPS code).
- `county::String=""`: County identifier (name or FIPS code). Requires `state` to be specified.
- `output::String=pwd()`: Directory where shapefiles will be saved.
- `force::Bool=false`: If `true`, redownload files even if they already exist.
- `verbose::Bool=false`: If `true`, display more detailed progress information.

# Returns
- `Vector{String}`: Paths to downloaded files.

# Examples
```julia
# Download state boundaries for the entire USA
tigerdownload("state")

# Download county subdivisions for California
tigerdownload("cousub", state="CA")

# Download census tracts for Los Angeles County, California
tigerdownload("tract", state="California", county="Los Angeles")

# Download with custom output directory and force redownload
tigerdownload("county", output="/path/to/data", force=true)
```

# Notes
- Geography types follow a hierarchy: national-level (state, county), state-level (cousub, place), 
  and county-level (tract, areawater).
- For national-level geographies, the `state` and `county` arguments are ignored.
- For state-level geographies, the `county` argument is ignored.
- For county-level geographies, both `state` and `county` are used when provided.
- If no state is specified when downloading state or county-level geographies, all states will be downloaded.
- TIGER/Line shapefiles are downloaded as ZIP archives containing multiple files (.shp, .dbf, .prj, etc.).

# See Also
- [Census TIGER/Line Documentation](https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html)
"""
function tigerdownload(
    type::String, year::Int=2024;
    state::String="",
    county::String="",
    output::String=pwd(),
    force::Bool=false,
    verbose::Bool=false)

    type_lower = lowercase(type)
    if !haskey(GEOGRAPHY_TYPES, type_lower)
        throw(ArgumentError("Invalid type. Choose from: $(join(keys(GEOGRAPHY_TYPES), ", "))"))
    end

    # Get the type and create instance
    geo_type = GEOGRAPHY_TYPES[type_lower]
    geo = geo_type(year)  # No need to pass scope anymore, it's inherent in the type

    # Dispatch based on the type's hierarchy
    if geo isa NationalGeography
        if !isempty(state) || !isempty(county)
            @warn "State/county options ignored for national-level data"
        end
        download_shapefile(geo; output_dir=output, force=force)

    elseif geo isa StateGeography
        if !isempty(county)
            @warn "County option ignored for state-level data"
        end
        if isempty(state)
            @warn "No state specified - downloading all states"
        end
        state_arg = isempty(state) ? nothing : state
        download_shapefile(geo; state=state_arg, output_dir=output, force=force)

    elseif geo isa CountyGeography
        if isempty(state)
            @warn "No state specified - downloading all states"
        end
        if !isempty(county) && isempty(state)
            throw(ArgumentError("--county option requires --state to be specified"))
        end
        state_arg = isempty(state) ? nothing : state
        county_arg = isempty(county) ? nothing : county
        download_shapefile(geo; state=state_arg, county=county_arg, output_dir=output, 
            force=force, verbose=verbose)
    end
end
# --------------------------------------------------------------------------------------------------