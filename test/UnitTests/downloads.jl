@testset "Download Tests" begin


# --------------------------------------------------------------------------------------------------
    @testset "National Level Downloads" begin

    test_dir = mktempdir()
    
    # Download the states shapefiles
    tigerdownload("state", 2024; state="MN", county="", output=test_dir, force=true)
    state_file_download = joinpath(test_dir, "tl_2024_us_state.zip")
    # stat(state_file_download)
    @test bytes2hex(SHA.sha256(read(state_file_download))) == 
                  "e30bad8922b177b5991bf8606d3d95de8f5f0b4bab25848648de53b25f72c17f"

    tigerdownload("county", 2024; state="MN", county="Hennepin", output=test_dir, force=true)
    county_file_download = joinpath(test_dir, "tl_2024_us_county.zip")
    # stat(county_file_download)
    @test bytes2hex(SHA.sha256(read(county_file_download))) == 
                  "a344b72be48f2448df1ae1757098d94571b96556d3b9253cf9d6ee77bce8a0b4"

    tigerdownload("cbsa", 2024; output=test_dir, force=true)
    cbsa_file_download = joinpath(test_dir, "tl_2024_us_cbsa.zip")
    round(stat(cbsa_file_download).size / 1024, digits=2) # 34mb
    @test bytes2hex(SHA.sha256(read(cbsa_file_download))) == 
                  "7bd2cef06f0cd6cccc1aeeb10105095d543515c9535b8a89c9e8e7470615c8fa"

    tigerdownload("urbanarea", 2024; output=test_dir, force=true)
    urbanarea_file_download = joinpath(test_dir, "tl_2024_us_uac20.zip")
    round(stat(urbanarea_file_download).size / 1024, digits=2) # 72mb
    @test bytes2hex(SHA.sha256(read(urbanarea_file_download))) == 
                  "13f2f86cd31935387fa458022b73ad0433c39333c36ffb6efa8185694eba9d18"

    tigerdownload("zipcode", 2024; output=test_dir, force=true)
    zipcode_file_download = joinpath(test_dir, "tl_2024_us_zcta520.zip")
    round(stat(zipcode_file_download).size / 1024, digits=2) # 516mb
    @test bytes2hex(SHA.sha256(read(zipcode_file_download))) == 
                  "7331f68ada3d8eec3a87478c2a6ca68b7434762aa9d5a6cf2369d6ad90b3e03d"

    tigerdownload("metrodivision", 2024; output=test_dir, force=true)
    metrodivision_file_download = joinpath(test_dir, "tl_2024_us_metdiv.zip")
    round(stat(metrodivision_file_download).size / 1024, digits=2) # 516mb
    @test bytes2hex(SHA.sha256(read(metrodivision_file_download))) == 
                  "c7deea8ce439d3671a565e2e629bf23e1b6df5c714be3f9f72555728de3ab975"

    # -- rails
    tigerdownload("rails", 2024; output=test_dir, force=true)
    rails_file_download = joinpath(test_dir, "tl_2024_us_rails.zip")
    round(stat(rails_file_download).size / 1024, digits=2) # 516mb
    @test bytes2hex(SHA.sha256(read(rails_file_download))) == 
                  "b0c19b22b1ee293062dba5dc05f57c2b6290c3df916aab8de62ff9344ebe9658"

    tigerdownload("primaryroads", 2024; output=test_dir, force=true)
    primaryroads_file_download = joinpath(test_dir, "tl_2024_us_primaryroads.zip")
    round(stat(primaryroads_file_download).size / 1024, digits=2) # 516mb
    @test bytes2hex(SHA.sha256(read(primaryroads_file_download))) == 
                  "d4f1b1cd981f440aee9980fdf991d4312a0bd03e7b2b2ae609a266bfc59ae786"

    end
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
    @testset "State Level Downloads" begin

    test_dir = mktempdir()
    
    # Download the county subdivisions shapefiles
    tigerdownload("cousub", 2024; state="MN", county="", output=test_dir, force=true)
    cousub_file_download = joinpath(test_dir, "tl_2024_27_cousub.zip")
    # stat(cousub_file_download)
    @test bytes2hex(SHA.sha256(read(cousub_file_download))) == 
                  "b1cf4855fe102d9ebc34e165457986b8d906052868da0079ea650d39d973ec98"

    # for all the states ... 
    tigerdownload("cousub", 2024; output=test_dir, force=false)
    cousub_file_list = [ "tl_2024_$(x[2])_cousub.zip" 
        for x in TigerFetch.get_state_list() ]
    cousub_file_list = joinpath.(test_dir, cousub_file_list)
    @test !all(isfile.(cousub_file_list)) # there should be one missing file
    @test all(.!isfile.(filter(contains("tl_2024_74_cousub.zip"), cousub_file_list))) # there should be one missing file

    cousub_file_download = filter(contains("tl_2024_28_cousub.zip"), cousub_file_list)[1]
    round(stat(cousub_file_download).size / 1024, digits=2)
    @test bytes2hex(SHA.sha256(read(cousub_file_download))) == 
                  "f91963513bf14f64267fefc5ffda24161e879bfb76a48c19517eba0f85c638ba"

    # -- tracts
    tigerdownload("tract", 2024; state="27", county="", output=test_dir, force=true)
    tract_file_download = joinpath(test_dir, "tl_2024_27_tract.zip")
    round(stat(tract_file_download).size / 1024, digits=2)
    @test bytes2hex(SHA.sha256(read(tract_file_download))) == 
                  "83f784b2042d0af55723baaac37b2b29840d1485ac233b3bb73d6af4ec7246eb"

    # -- place
    tigerdownload("place", 2024; state="27", county="", output=test_dir, force=true)
    tract_file_download = joinpath(test_dir, "tl_2024_27_place.zip")
    round(stat(tract_file_download).size / 1024, digits=2)
    @test bytes2hex(SHA.sha256(read(tract_file_download))) == 
                  "f03383a2522009c63daae5b73164ac565fc37470539d1fc79c057ed5dc31c9c3"
    
    # -- concity ... not all states are available
    tigerdownload("consolidatedcity", 2024; state="20", county="", output=test_dir, force=true)
    consolidatedcity_file_download = joinpath(test_dir, "tl_2024_20_concity.zip")
    round(stat(consolidatedcity_file_download).size / 1024, digits=2)
    @test bytes2hex(SHA.sha256(read(consolidatedcity_file_download))) == 
                  "510ee4a9d1e2bcf0dc8b87fc3c97f66e7afafbd5e4f1c2996d024c14c2eb7ab4"
    
    # -- roads
    tigerdownload("primarysecondaryroads", 2024; state="27", county="", output=test_dir, force=true)
    road_file_download = joinpath(test_dir, "tl_2024_27_prisecroads.zip")
    round(stat(road_file_download).size / 1024, digits=2)
    @test bytes2hex(SHA.sha256(read(road_file_download))) == 
                  "3c06a9b03ca06abf42db85b3b9ab3110d251d54ccf3d59335a2e5b98d2e6f52a"



    end
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
    @testset "County Level Downloads" begin

    test_dir = mktempdir()
    
    # Download the areawater shapefiles
    tigerdownload("areawater", 2024; state="MN", county="Hennepin", output=test_dir, force=true)
    areawater_file_download = joinpath(test_dir, "tl_2024_27053_areawater.zip")
    # stat(cousub_file_download)
    @test bytes2hex(SHA.sha256(read(areawater_file_download))) == 
                  "54a2825f26405fbb83bd4c5c7a96190867437bc46dc0d4a8155198890d63db54"

    # Download the linear water  shapefiles for all of Michigan
    tigerdownload("linearwater", 2024; state="MI", output=test_dir, force=true)
    linearwater_file_list = [ "tl_2024_$(x[2])$(x[3])_linearwater.zip" 
        for x in TigerFetch.get_county_list("MI") ]
    linearwater_file_list = joinpath.(test_dir, linearwater_file_list)
    @test all(isfile.(linearwater_file_list)) # test that all the files are there

    linearwater_file_download = filter(contains("tl_2024_26089_linearwater.zip"), linearwater_file_list)[1]
    round(stat(linearwater_file_download).size / 1024, digits=2)
    @test bytes2hex(SHA.sha256(read(linearwater_file_download))) == 
                  "b05a58ddb37abdc9287c533a6f87110ef4b153dc4fbd20833d3d1cf56470cba7"

    # roads
    tigerdownload("road", 2024; state="MN", county="Hennepin", output=test_dir, force=true)
    roads_file_download = joinpath(test_dir, "tl_2024_27053_roads.zip")
    round(stat(roads_file_download).size / 1024, digits=2)
    @test bytes2hex(SHA.sha256(read(roads_file_download))) == 
                  "b828ad38a8bc3cd3299efcc7e3b333ec2954229392eb254a460e596c1db78511"



    end
# --------------------------------------------------------------------------------------------------


end