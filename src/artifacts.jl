using Pkg.Artifacts

"""
Bind the artifact to the GitHub-hosted tarball.
Run this script once to update Artifacts.toml.
"""

"""
Bind the artifact from a GitHub-hosted tarball.
Run this script once to update Artifacts.toml.
"""
function bind_github_artifact()

artifact_url = "https://github.com/eloualiche/TigerFetch.jl/releases/download/0.1.1/fips_state_county_list.tar.gz"


# sha256
artifact_hash_256 = "f00e895f9358863c07e9c6c3b9eedf199cc740aab0583ce25de39e9d7159b565"

# The SHA1 hash (obtained from sha256sum)
# using SHA
# artifact_path = "assets/fips_state_county_list.tar.gz"
# artifact_hash = bytes2hex(open(sha1, artifact_path))
artifact_hash = "d9f2ce485acf54390052e796cb4ccf8c01e70bcb"
sha1_hash = Base.SHA1(artifact_hash)

# Bind the artifact with its SHA1 hash
bind_artifact!(
    "Artifacts.toml",      # Path to Artifacts.toml
    "fips_state_county_list",         # Name of the artifact
    sha1_hash;             # SHA1 hash (as a Base.SHA1 object)
    download_info=[(artifact_url, artifact_hash_256)],  # URL for downloading the artifact and its SHA256 hash
    force=true             # Overwrite if exists
)

end


"""
Get the directory containing the artifact files.
"""
function artifact_dir()
    artifact_toml = joinpath(@__DIR__, "..", "Artifacts.toml")

    # Get the hash from Artifacts.toml
    hash = artifact_hash("fips_state_county_list", artifact_toml)
    if hash === nothing
        error("Could not find fips_state_county_list entry in Artifacts.toml")
    end

    # Ensure the artifact is installed (downloads if needed)
    ensure_artifact_installed("fips_state_county_list", artifact_toml)

    # Return the artifact directory path
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
