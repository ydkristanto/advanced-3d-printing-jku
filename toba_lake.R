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
  add_water(detect_water(matrix_toba), color = "desert") |> 
  add_shadow(ray_shade(matrix_toba), .5) |> 
  add_shadow(ambient_shade(matrix_toba), 0) |> 
  plot_map()
matrix_toba |> 
  sphere_shade() |> 
  add_water(detect_water(matrix_toba), color = "desert") |> 
  add_shadow(ray_shade(matrix_toba), .5) |> 
  add_shadow(ambient_shade(matrix_toba), 0) |> 
  plot_3d(
    matrix_toba, zscale = 17,
    fov = 0, theta = 135, zoom = .75, phi = 45,
    windowsize = c(600, 600),
    soil = TRUE
  )
render_clouds(
  matrix_toba, zscale = 17, start_altitude = 1000, end_altitude = 1500,
  attenuation_coef = 2, clear_clouds = TRUE, cloud_cover = .6
)
render_snapshot()
save_3dprint(
  filename = "toba_lake.stl",
  maxwidth = 15,
  unit = "mm"
)

# Movie ----
phivechalf = 30 + 60 * 1/(1 + exp(seq(-7, 20, length.out = 180)/2))
phivecfull = c(phivechalf, rev(phivechalf))
thetavec = -90 + 45 * sin(seq(0,359,length.out = 360) * pi/180)
zoomvec = 0.45 + 0.2 * 1/(1 + exp(seq(-5, 20, length.out = 180)))
zoomvecfull = c(zoomvec, rev(zoomvec))


render_movie(
  filename = "press_lake_toba",
  type = "custom", 
  frames = 360,
  fps = 24,
  phi = phivecfull,
  zoom = zoomvecfull,
  theta = thetavec
)


