
# --------------------------------------------------------------------------------------------------
const GEOGRAPHY_TYPES = Dict(
    "state" => State,
    "county" => County,
    "cousub" => CountySubdivision,
    "tract" => Tract,
    "areawater" => AreaWater,
)

# julia function
function tigerdownload(
    type::String, year::Int=2024;
    state::String="",
    county::String="",
    output::String=pwd(),
    force::Bool=false)

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
        download_shapefile(geo; state=state_arg, county=county_arg, output_dir=output, force=force)
    end
end
# --------------------------------------------------------------------------------------------------


