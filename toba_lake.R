library(tidyverse)
library(raster)
library(terra)
library(rayshader)

# Data ----
N02E098 <- terra::rast("N02E098.hgt")
N02E099 <- terra::rast("N02E099.hgt")

sraster_elev <- terra::merge(
  N02E098, N02E099
)

toba_bound <- extent(
  98.26, 99.35,
  2.22, 3.10
)

sraster_toba <- crop(
  sraster_elev, toba_bound
)

matrix_toba <- raster_to_matrix(sraster_toba)
matrix_toba <- resize_matrix(matrix_toba, scale = .15)

matrix_toba |> 
  sphere_shade() |> 
  plot_3d(matrix_toba, zscale = 12)
save_3dprint(
  filename = "toba_lake.stl",
  maxwidth = 15,
  unit = "mm"
)


