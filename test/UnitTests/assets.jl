
@testset "Asset Installation Tests" begin
    @testset "Artifact Configuration" begin


        artifact_toml = joinpath(@__DIR__, "..", "..", "Artifacts.toml")
        @test isfile(artifact_toml)
        @test_nowarn ensure_artifact_installed("fips_state_county_list", artifact_toml)

        # Test that the artifact path is valid
        artifact_path = TigerFetch.artifact_dir()
        @test isdir(artifact_path)

        # Test that both expected files exist in artifact
        @test isfile(joinpath(artifact_path, "national_county2020.txt"))
        @test isfile(joinpath(artifact_path, "national_state2020.txt"))

    end

    @testset "Reference Data Files" begin
        # Get reference data paths
        data_paths = TigerFetch.get_reference_data()
        
        @testset "Data Dictionary Structure" begin
            @test data_paths isa Dict
            @test haskey(data_paths, "county")
            @test haskey(data_paths, "state")
        end

        @testset "County Data File" begin
            county_path = data_paths["county"]
            @test isfile(county_path)
            
            # Test county file content structure
            content = readlines(county_path)
            @test length(content) > 0
            @test occursin("|", first(content))
            
            # Test expected column structure
            first_line = split(first(content), "|")
            @test length(first_line) >= 4  # Should have at least State, County FIPS, Name columns
            
            # Test file hash matches expected
            @test bytes2hex(SHA.sha256(read(county_path))) == 
                  "9f6e5f6eb6ac2f5e9a36d5fd01dec77991bddc75118f748a069441a4782970d6"
        end

        @testset "State Data File" begin
            state_path = data_paths["state"]
            @test isfile(state_path)
            
            # Test state file content structure
            content = readlines(state_path)
            @test length(content) > 0
            @test occursin("|", first(content))
            
            # Test expected column structure
            first_line = split(first(content), "|")
            @test length(first_line) >= 4  # Should have at least FIPS, Abbrev, Name columns
            
            # Test file hash matches expected
            @test bytes2hex(SHA.sha256(read(state_path))) == 
                  "167942161ec455bf7b0ee81b6ad76c109eb65e63136125d3683f8a44f51bbc66"
        end
    end

    @testset "Data Processing Functions" begin
        @testset "State List Processing" begin
            state_list = TigerFetch.get_state_list()
            @test length(state_list) > 0
            @test all(x -> length(x) == 3, state_list)  # [abbrev, fips, name]
            
            # Test specific state presence
            @test any(x -> x[1] == "AL", state_list)  # Alabama should exist
            @test any(x -> x[2] == "06", state_list)  # California FIPS should exist
        end

        @testset "County List Processing" begin
            # Test full county list
            county_list = TigerFetch.get_county_list()
            @test length(county_list) > 0
            @test all(x -> length(x) == 4, county_list)  # [state, state_fips, county_fips, name]
            
            # Test state-specific county list
            al_counties = TigerFetch.get_county_list("01")  # Alabama FIPS
            @test length(al_counties) > 0
            @test all(x -> x[1] == "AL", al_counties)  # All should be Alabama counties
            
            # Test known county existence
            @test any(x -> x[3] == "001" && x[2] == "01", al_counties)  # Autauga County, AL
        end
    end
end