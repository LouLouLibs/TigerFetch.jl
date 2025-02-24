

# --------------------------------------------------------------------------------------------------
# National scope (States, Counties nationally)
function download_shapefile(
    geo::T;
    output_dir::String=pwd(),
    force::Bool=false) where {T <: NationalGeography}

    geo_type = typeof(geo)
    filename = "tl_$(geo.year)_us_$(lowercase(tiger_name(geo_type))).zip"

    url = "https://www2.census.gov/geo/tiger/TIGER$(geo.year)/$(tiger_name(geo_type))/" * filename
    output_path = joinpath(output_dir, filename)

    if isfile(output_path) && !force
        @info "File exists" path=output_path
        return output_path
    end

    try
        @info "Downloading $(description(geo_type))" url=url
        mkpath(output_dir)
        Downloads.download(url, output_path)
        return output_path
    catch e
        @error "Download failed" exception=e
        rethrow(e)
    end
end
# --------------------------------------------------------------------------------------------------
#
#
# --------------------------------------------------------------------------------------------------
# State scope (CountySubdivisions, Places)
function download_shapefile(
    geo::T;
    state::Union{String, Integer, Nothing}=nothing,
    output_dir::String=pwd(),
    force::Bool=false) where T<:StateGeography

    # Get states to process
    if !isnothing(state)
        state_info = standardize_state_input(state)
        if isnothing(state_info)
            throw(ArgumentError("Invalid state identifier provided"))
        end
        states_to_process = [state_info]
    else
        @warn "No state specified - downloading all states"
        states_to_process = get_state_list()
        
        # There are some exceptions because not everything is available all the time!
        (geo isa CountySubdivision) ? filter!(s -> s[2] != "74", states_to_process) : nothing

    end

    # Use the type of geo to get tiger_name
    geo_type = typeof(geo)
    base_url = "https://www2.census.gov/geo/tiger/TIGER$(geo.year)/$(tiger_name(geo_type))/"

    try
        # Process each state with total interrupt by user ...
        for state_info in states_to_process
            fips = state_info[2]
            state_name = state_info[3]
            filename = "tl_$(geo.year)_$(fips)_$(lowercase(tiger_name(T))).zip"
            url = base_url * filename
            output_path = joinpath(output_dir, filename)

            if isfile(output_path) && !force
                @info "File exists" state=state_name path=output_path
                continue
            end

            try
                @info "Downloading" state=state_name url=url
                Downloads.download(url, output_path)
            catch e
                if e isa InterruptException
                    # Re-throw interrupt to be caught by outer try block
                    rethrow(e)
                end
                @error "Download failed" state=state_name exception=e
                continue
            end
        end
    catch e
        if e isa InterruptException
            @info "Download process interrupted by user"
            # Optional: Clean up partially downloaded file
            try
                isfile(output_path) && rm(output_path)
            catch
                # Ignore cleanup errors
            end
            rethrow(e)  # This will exit the function
        end
        rethrow(e)  # Re-throw any other unexpected errors
    end

end
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
# County scope (Tracts, WaterAreas)
function download_shapefile(
    geo::T;
    state::Union{String, Integer, Nothing}=nothing,
    county::Union{String, Integer, Nothing}=nothing,
    output_dir::String=pwd(),
    force::Bool=false) where {T <: CountyGeography}


    # Get states to process
    if !isnothing(state)
        state_info = standardize_state_input(state)
        if isnothing(state_info)
            throw(ArgumentError("Invalid state identifier: $state"))
        end
        states_to_process = [state_info]
    else
        @warn "No state specified - downloading all states"
        states_to_process = get_state_list()
    end

    # Track failures
    failed_downloads = String[]

    for state_info in states_to_process
        state_fips = state_info[2]
        state_name = state_info[3]

        # Get counties for this state
        counties = get_county_list(state_fips)

        # Filter for specific county if provided
        if !isnothing(county)
            county_info = standardize_county_input(county, state_fips)
            if isnothing(county_info)
                throw(ArgumentError("Invalid county identifier for $(state_name)"))
            end
            counties = [county_info]
        end

        for county_info in counties
            county_fips = county_info[3]  # Assuming similar structure to state_info
            county_name = county_info[4]

            filename = "tl_$(geo.year)_$(state_fips)$(county_fips)_$(lowercase(tiger_name(geo))).zip"
            url = "https://www2.census.gov/geo/tiger/TIGER$(geo.year)/$(tiger_name(geo))/" * filename
            output_path = joinpath(output_dir, filename)

            if isfile(output_path) && !force
                @info "File exists" state=state_name county=county_name path=output_path
                continue
            end

            try
                @info "Downloading" state=state_name county=county_name url=url
                mkpath(output_dir)
                Downloads.download(url, output_path)
            catch e
                push!(failed_downloads, "$(state_name) - $(county_name)")
                @error "Download failed" state=state_name county=county_name exception=e
                continue
            end
        end
    end

    if !isempty(failed_downloads)
        @warn "Some downloads failed" failed_locations=failed_downloads
    end
end
# --------------------------------------------------------------------------------------------------
