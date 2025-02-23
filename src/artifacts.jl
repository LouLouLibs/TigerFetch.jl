using Pkg.Artifacts

"""
Create and bind the artifact for existing files.
Run this script once to set up the artifact.
"""
function create_artifacts()
    # Create a new artifact
    artifact_hash = create_artifact() do artifact_dir
        # Copy your existing files into the artifact directory
        mkpath(artifact_dir)

        # Assuming your files are in a directory named "assets" at the package root
        source_dir = joinpath(@__DIR__, "..", "assets")

        # Copy the files
        cp(joinpath(source_dir, "national_county2020.txt"),
           joinpath(artifact_dir, "national_county2020.txt"))
        cp(joinpath(source_dir, "national_state2020.txt"),
           joinpath(artifact_dir, "national_state2020.txt"))
    end

    # Bind the artifact in Artifacts.toml
    bind_artifact!(
        "Artifacts.toml",           # Your Artifacts.toml file
        "package_assets",           # Name for your artifact
        artifact_hash;              # Hash from create_artifact
        force=true                  # Overwrite if exists
    )
end

"""
Get the directory containing the artifact files.
"""
function artifact_dir()
    artifact_toml = joinpath(@__DIR__, "..", "Artifacts.toml")
      # Get the hash from the Artifacts.toml file
    hash = artifact_hash("package_assets", artifact_toml)
    if hash === nothing
        error("Could not find package_assets entry in Artifacts.toml")
    end
    # Ensure the artifact is installed
    ensure_artifact_installed("package_assets", artifact_toml)
    # Now use the hash to get the path
    return artifact_path(hash)
end


"""
Get paths to specific reference files.
"""
function get_reference_data()
    base_path = artifact_dir()
    return Dict(
        "county" => joinpath(base_path, "national_county2020.txt"),
        "state" => joinpath(base_path, "national_state2020.txt")
    )
end
