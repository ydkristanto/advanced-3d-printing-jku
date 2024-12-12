library(tidyverse)
library(raster)
library(terra)
library(rayshader)

# Data ----
N48E014 <- terra::rast("N48E014.hgt")

lab_coords <- c(14.32, 48.34)
jku_bound <- extent(
  14.27, 14.37,
  48.29, 48.39
)

sraster_jku <- crop(
  N48E014, jku_bound
)

matrix_jku <- raster_to_matrix(sraster_jku)

# 3D modeling ----
matrix_jku |> 
  sphere_shade() |> 
  add_water(detect_water(matrix_jku), color = "desert") |> 
  add_shadow(ray_shade(matrix_jku), .5) |> 
  add_shadow(ambient_shade(matrix_jku), 0) |> 
  plot_3d(
    matrix_jku, zscale = 15,
    fov = 0, theta = 135, zoom = .75, phi = 45,
    windowsize = c(600, 600),
    soil = TRUE
  )

render_clouds(
  matrix_jku, zscale = 15, start_altitude = 800, end_altitude = 1000, 
  sun_altitude = 45, attenuation_coef = 2,
  cloud_cover = 0.45, frequency = 0.01, fractal_levels = 32,
  clear_clouds = TRUE
)

render_label(
  matrix_jku, x = 180, y = 180, z = 1100, zscale = 15,
  text = "JKU STEAM Lab", textsize = 2, linewidth = 2,
  fonttype = "bold",
  clear_previous = TRUE,
  textcolor = "white",
  linecolor = "white"
)

# Movie ----
phivechalf = 30 + 60 * 1/(1 + exp(seq(-7, 20, length.out = 180)/2))
phivecfull = c(phivechalf, rev(phivechalf))
thetavec = -90 + 45 * sin(seq(0,359,length.out = 360) * pi/180)
zoomvec = 0.45 + 0.2 * 1/(1 + exp(seq(-5, 20, length.out = 180)))
zoomvecfull = c(zoomvec, rev(zoomvec))


render_movie(
  filename = "press_jku_steam_lab",
  type = "custom", 
  frames = 360,
  fps = 24,
  phi = phivecfull,
  zoom = zoomvecfull,
  theta = thetavec
)
