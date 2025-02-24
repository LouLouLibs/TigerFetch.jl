# Drawing a simple map


```@setup simplemap
import Pkg; 
Pkg.add(["CairoMakie", "DataFrames", "DataFramesMeta"])
Pkg.add(["GADM", "GeoMakie", "GeometryOps", "GeoJSON", "Shapefile", "ZipFile"]);
```

You will need a bunch of libraries to plot these; maybe setup a temporary environment, because it is not fun waiting for Makie to recompile at every startup.
```@example simplemap
using CairoMakie, DataFrames, DataFramesMeta
using GADM, GeoMakie, GeometryOps, GeoJSON, Shapefile, ZipFile
using TigerFetch
tmp_dir = mktempdir(); map_dir = joinpath(tmp_dir, "map"); 
```

## Plotting county subdivisions

We are downloading the county shapefiles (which is a national file), subsets it to Minnesota and plot it.
```@example simplemap;
tigerdownload("county"; output=map_dir) ;
isfile(joinpath(map_dir, "tl_2024_us_county.zip"))
```

First, we process the file which is national to only keep counties in the state
```@example simplemap;
df_shp_cty = Shapefile.Table(joinpath(map_dir, "tl_2024_us_county.zip")) |> DataFrame;
@rsubset!(df_shp_cty, :STATEFP=="27");
```

```@example simplemap;
fig = Figure(size=(750,900));
homerule_centroid = GeometryOps.centroid(df_shp_cty.geometry);
ga = GeoAxis(fig[1, 1]; 
    dest = "+proj=ortho +lon_0=$(homerule_centroid[1]) +lat_0=$(homerule_centroid[2])",
    xticksvisible = false, xgridvisible = false, xticks=[0],
   yticksvisible = false, ygridvisible = false, yticks=[0]);
poly!(ga, df_shp_cty.geometry;
      color=:white,
      strokecolor = :black, strokewidth = 0.5, shading = NoShading, 
      colormap = :dense, alpha = 0.5);
save("p1.svg", fig); nothing # hide
```
![](p1.svg)


## Addings water areas and roads

Roads are at the state level and water areas at the county level, so this will complete the example.

From simple to more complicated we start with primary and secondary roads
```@example simplemap;
tigerdownload("primarysecondaryroads"; state="MN", output=map_dir);
df_shp_roads = Shapefile.Table(joinpath(map_dir, "tl_2024_27_prisecroads.zip")) |> DataFrame;
lines!(ga, df_shp_roads.geometry; color=RGBf(255/255, 203/255, 71/255), alpha=0.75, linewidth=0.2);
save("p2.svg", fig); nothing # hide
```
![](p2.svg)



And the water areas; we download them in a separate directory because there is one file per county:
```@example simplemap;
mkpath(joinpath(map_dir, "MN"));
tigerdownload("areawater"; state="MN", output=joinpath(map_dir, "MN"));
```

Then we read all of the downloaded shapefiles in the dictionary and keep only the subset of the largest lakes or rivers:
```@example simplemap
df_shp_water = [ DataFrame(Shapefile.Table(joinpath(map_dir, "MN", f))) 
                 for f in readdir(joinpath(map_dir, "MN")) ];
df_shp_water = reduce(vcat, df_shp_water, cols=:union);       
@rsubset!(df_shp_water, :AWATER > 1_000_000); # only keep larger water 
```

And now the plot:
```@example simplemap
poly!(ga, df_shp_water.geometry;
      color=RGBf(170/255, 218/255, 255/255),
      strokewidth=0.5, strokecolor=RGBf(144/255, 202/255, 249/255));
save("p3.svg", fig); nothing # hide
```
![](p3.svg)


