@testset "Asset Installation Tests" begin

    @testset "Artifact Existence" begin

        # Test that the Artifacts.toml file exists
        artifact_toml = joinpath(pkgdir(TigerFetch), "Artifacts.toml")
        @test isfile(artifact_toml)

        # Test that we can get the artifact directory
        artifact_toml = joinpath(@__DIR__, "..", "..", "Artifacts.toml")
        @test_nowarn ensure_artifact_installed("package_assets", artifact_toml)

        # Test that the artifact path is valid
        artifact_path = TigerFetch.artifact_dir()
        @test isdir(artifact_path)
    end

    @testset "Reference Data Files" begin
        # Get reference data paths
        data_paths = TigerFetch.get_reference_data()

        @testset "County Data File" begin
            county_path = data_paths["county"]
            @test isfile(county_path)

            # Test county file content structure
            content = readlines(county_path)
            @test length(content) > 0
            @test occursin("|", first(content))
            first_line = split(first(content), "|")
            @test length(first_line) >= 4
        end

        @testset "State Data File" begin
            state_path = data_paths["state"]
            @test isfile(state_path)

            # Test state file content structure
            content = readlines(state_path)
            @test length(content) > 0
            @test occursin("|", first(content))

            first_line = split(first(content), "|")
            @test length(first_line) >= 4
        end
    end



    @testset "Data Accessibility" begin
        # Test state list functionality
        state_list = TigerFetch.get_state_list()
        @test length(state_list) > 0
        @test all(x -> length(x) == 3, state_list)  # Each state should have 3 identifiers

        # Test county list functionality
        county_list = TigerFetch.get_county_list()
        @test length(county_list) > 0
        @test all(x -> length(x) == 3, county_list)  # Each county should have 3 identifiers

        # Test specific state county list
        al_counties = TigerFetch.get_county_list("AL")
        @test length(al_counties) > 0
        @test all(x -> x[1] == "AL", al_counties)  # All counties should be from Alabama
    end
end
