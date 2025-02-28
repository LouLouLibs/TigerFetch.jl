
# --------------------------------------------------------------------------------------------------
# Abstract base type
abstract type TigerGeography end

# Abstract types for each scope
abstract type NationalGeography <: TigerGeography end
abstract type StateGeography <: TigerGeography end
abstract type CountyGeography <: TigerGeography end
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
# Concrete types with their metadata as constants
struct State <: NationalGeography
    year::Int
end
const STATE_META = (tiger_name = "STATE", description = "State Boundaries")

struct County <: NationalGeography
    year::Int
end
const COUNTY_META = (tiger_name = "COUNTY", description = "County Boundaries")

struct ZipCode <: NationalGeography
    year::Int
end
const ZIP_META = (tiger_name = "ZCTA520", description = "2020 5-Digit ZIP Code Tabulation Area")

struct UrbanArea <: NationalGeography
    year::Int
end
const URBANAREA_META = (tiger_name = "UAC20", description = "2020 Urban Area/Urban Cluster")

struct PrimaryRoads <: NationalGeography
    year::Int
end
const PRIMARYROADS_META = (tiger_name = "PRIMARYROADS", description = "Primary Roads")

struct Rails <: NationalGeography
    year::Int
end
const RAILS_META = (tiger_name = "RAILS", description = "Rails")

struct CBSA <: NationalGeography
    year::Int
end
const CBSA_META = (tiger_name = "CBSA", description = "Core Based Statistical Area")

struct CSA <: NationalGeography
    year::Int
end
const CSA_META = (tiger_name = "CSA", description = "Combined Statistical Area")

struct METDIV <: NationalGeography
    year::Int
end
const METDIV_META = (tiger_name = "METDIV", description = "Metropolitan Division")
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
struct CountySubdivision <: StateGeography
    year::Int
end
const COUSUB_META = (tiger_name = "COUSUB", description = "County Subdivision")

struct Tract <: StateGeography
    year::Int
end
const TRACT_META = (tiger_name = "TRACT", description = "Census Tract")

struct Place <: StateGeography
    year::Int
end
const PLACE_META = (tiger_name = "PLACE", description = "Place")

struct PrimarySecondaryRoads <: StateGeography
    year::Int
end
const PSROADS_META = (tiger_name = "PRISECROADS", description = "Primary and Secondary Roads")

struct ConCity <: StateGeography
    year::Int
end
const CONCITY_META = (tiger_name = "CONCITY", description = "Consolidated City")

struct UNSD <: StateGeography
    year::Int
end
const UNSD_META = (tiger_name = "UNSD", description = "Unified School District")


# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
# --- county geographies
struct AreaWater <: CountyGeography
    year::Int
end
const AREAWATER_META = (tiger_name = "AREAWATER", description = "Area Hydrography")

struct LinearWater <: CountyGeography
    year::Int
end
const LINEARWATER_META = (tiger_name = "LINEARWATER", description = "Linear Hydrography")

struct Roads <: CountyGeography
    year::Int
end
const ROADS_META = (tiger_name = "ROADS", description = "Roads")
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
# Helper methods to access metadata
tiger_name(::Type{State}) = STATE_META.tiger_name
tiger_name(::Type{County}) = COUNTY_META.tiger_name
tiger_name(::Type{ZipCode}) = ZIP_META.tiger_name
tiger_name(::Type{UrbanArea}) = URBANAREA_META.tiger_name
tiger_name(::Type{PrimaryRoads}) = PRIMARYROADS_META.tiger_name
tiger_name(::Type{Rails}) = RAILS_META.tiger_name
tiger_name(::Type{CBSA}) = CBSA_META.tiger_name
tiger_name(::Type{CSA}) = CSA_META.tiger_name
tiger_name(::Type{METDIV}) = METDIV_META.tiger_name

tiger_name(::Type{CountySubdivision}) = COUSUB_META.tiger_name
tiger_name(::Type{Tract}) = TRACT_META.tiger_name
tiger_name(::Type{Place}) = PLACE_META.tiger_name
tiger_name(::Type{ConCity}) = CONCITY_META.tiger_name
tiger_name(::Type{UNSD}) = UNSD_META.tiger_name
tiger_name(::Type{PrimarySecondaryRoads}) = PSROADS_META.tiger_name

tiger_name(::Type{AreaWater}) = AREAWATER_META.tiger_name
tiger_name(::Type{LinearWater}) = LINEARWATER_META.tiger_name
tiger_name(::Type{Roads}) = ROADS_META.tiger_name

tiger_name(x::T) where T <: TigerGeography = tiger_name(T)

# -- description
description(::Type{State}) = STATE_META.description
description(::Type{County}) = COUNTY_META.description
description(::Type{ZipCode}) = ZIP_META.description
description(::Type{UrbanArea}) = URBANAREA_META.description
description(::Type{PrimaryRoads}) = PRIMARYROADS_META.description
description(::Type{Rails}) = RAILS_META.description
description(::Type{CBSA}) = CBSA_META.description
description(::Type{CSA}) = CSA_META.description
description(::Type{METDIV}) = METDIV_META.description

description(::Type{CountySubdivision}) = COUSUB_META.description
description(::Type{Tract}) = TRACT_META.description
description(::Type{Place}) = PLACE_META.description
description(::Type{ConCity}) = CONCITY_META.description
description(::Type{UNSD}) = UNSD_META.description
description(::Type{PrimarySecondaryRoads}) = PSROADS_META.description

description(::Type{AreaWater}) = AREAWATER_META.description
description(::Type{LinearWater}) = LINEARWATER_META.description
description(::Type{Roads}) = ROADS_META.description

description(x::T) where T <: TigerGeography = description(T)

# --
# Helper methods now just reference the type hierarchy
scope(::Type{T}) where {T <: NationalGeography} = National
scope(::Type{T}) where {T <: StateGeography} = ByState
scope(::Type{T}) where {T <: CountyGeography} = ByCounty
# --------------------------------------------------------------------------------------------------