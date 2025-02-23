# Abstract base type
abstract type TigerGeography end

# Abstract types for each scope
abstract type NationalGeography <: TigerGeography end
abstract type StateGeography <: TigerGeography end
abstract type CountyGeography <: TigerGeography end

# Concrete types with their metadata as constants
struct State <: NationalGeography
    year::Int
end
const STATE_META = (tiger_name = "STATE", description = "State Boundaries")

struct County <: NationalGeography
    year::Int
end
const COUNTY_META = (tiger_name = "COUNTY", description = "County Boundaries")

struct CountySubdivision <: StateGeography
    year::Int
end
const COUSUB_META = (tiger_name = "COUSUB", description = "County Subdivisions")

struct Tract <: CountyGeography
    year::Int
end
const TRACT_META = (tiger_name = "TRACT", description = "Census Tracts")

struct AreaWater <: CountyGeography
    year::Int
end
const AREAWATER_META = (tiger_name = "AREAWATER", description = "Area Water")

# Helper methods to access metadata
tiger_name(::Type{State}) = STATE_META.tiger_name
tiger_name(::Type{County}) = COUNTY_META.tiger_name
tiger_name(::Type{CountySubdivision}) = COUSUB_META.tiger_name
tiger_name(::Type{Tract}) = TRACT_META.tiger_name
tiger_name(::Type{AreaWater}) = AREAWATER_META.tiger_name

tiger_name(x::T) where T <: TigerGeography = tiger_name(T)

description(::Type{State}) = STATE_META.description
description(::Type{County}) = COUNTY_META.description
description(::Type{CountySubdivision}) = COUSUB_META.description
description(::Type{Tract}) = TRACT_META.description
description(::Type{AreaWater}) = AREAWATER_META.description

description(x::T) where T <: TigerGeography = description(T)

# Helper methods now just reference the type hierarchy
scope(::Type{T}) where {T <: NationalGeography} = National
scope(::Type{T}) where {T <: StateGeography} = ByState
scope(::Type{T}) where {T <: CountyGeography} = ByCounty
