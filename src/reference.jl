function get_state_list()::Vector{Vector{String}}
    paths = get_reference_data()
    state_file = paths["state"]

    # we do not need to load CSV so we read the file by hand
    state_list = readlines(state_file) |>
        l -> split.(l, "|") |> # split by vertical bar
        l -> map(s -> String.(s[ [1,2,4] ]), l) |> # select some columns
        l -> l[2:end] # remove the header

    return unique(state_list)
end

# Takes a string input (handles names and abbreviations)
function standardize_state_input(state_input::String)::Union{Vector{String}, Nothing}
    normalized_input = uppercase(strip(state_input))
    states = get_state_list()
    matched_state = findfirst(state ->
        any(uppercase(identifier) == normalized_input for identifier in state),
        states)
    return isnothing(matched_state) ? nothing : states[matched_state]
end

# Takes numeric input (handles FIPS codes)
function standardize_state_input(fips::Integer)::Union{Vector{String}, Nothing}
    fips_str = lpad(string(fips), 2, '0')
    states = get_state_list()
    matched_state = findfirst(state -> state[2] == fips_str, states)
    return isnothing(matched_state) ? nothing : states[matched_state]
end

# Handles the default case
standardize_state_input(::Nothing) = nothing


# -------------------------------------------------------------------------------------------------

function get_county_list(state=nothing)::Vector{Vector{AbstractString}}
    paths = get_reference_data()  # Remove TigerFetch. prefix since we're inside the module
    county_file = paths["county"]

    # we do not need to load CSV so we read the file by hand
    county_list = readlines(county_file) |>
        ( l -> split.(l, "|") ) |> # split by vertical bar
        ( l -> map(s -> String.(s[ [1,2,3,5] ]), l) ) |> # select some columns
        ( l -> l[2:end] ) # remove the header

    if isnothing(state)
        return county_list
    elseif !isnothing(tryparse(Int, state))  # then its the fips
        return unique(filter(l -> l[2] == state, county_list))
    else   # then its the abbreviation state name 
        return unique(filter(l -> l[1] == state, county_list))
    end

end



function standardize_county_input(
    county_input::Union{String, Integer},
    state_fips::String)::Union{Vector{String}, Nothing}

    # Handle numeric input (FIPS code)
    if county_input isa Integer
        # Convert to three-digit string with leading zeros
        county_fips = lpad(string(county_input), 3, '0')
        return find_county(county_fips, state_fips)
    end

    # Handle string input (name or FIPS)
    normalized_input = uppercase(strip(county_input))
    return find_county(normalized_input, state_fips)
end


function find_county(identifier::String, state_fips::String)::Union{Vector{String}, Nothing}

    counties = get_county_list(state_fips)

    COUNTY_SUFFIXES = ["COUNTY", "MUNICIPIO", "BOROUGH", "PARISH", "MUNICIPALITY", "CENSUS AREA"]
    clean_county_name(name::String) = replace(uppercase(strip(name)), 
        Regex("\\s+(" * join(COUNTY_SUFFIXES, "|") * ")\$") => "")
    clean_identifier = clean_county_name(uppercase(identifier))

    # Try to match based on any identifier in the county vector only on fips and name to avoid false positive
    matched_county = findfirst(
        county -> any(clean_county_name(id) == clean_identifier for id in county[[3,4]]),
        counties)

    return isnothing(matched_county) ? nothing : counties[matched_county]
end









