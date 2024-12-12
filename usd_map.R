library(tidyverse)
library(raster)
library(terra)
library(rayshader)

# Data ----
S08E110 <- terra::rast("S08E110.hgt")

usd_coords <- c(110.42, -7.75)

usd_bound <- extent(
  110.17, 110.67,
  -8.00, -7.50
)

sraster_usd <- crop(
  S08E110, usd_bound
)

matrix_usd <- raster_to_matrix(sraster_usd)
matrix_usd <- matrix_usd |> 
  resize_matrix(scale = .2)

# 3D modeling ----
matrix_usd |> 
  sphere_shade() |> 
  add_water(detect_water(matrix_usd), color = "desert") |> 
  add_shadow(ray_shade(matrix_usd), .5) |> 
  add_shadow(ambient_shade(matrix_usd), 0) |> 
  plot_3d(
    matrix_usd, zscale = 30,
    fov = 0, theta = 135, zoom = .75, phi = 45,
    windowsize = c(600, 600),
    soil = TRUE
  )

render_clouds(
  matrix_usd, zscale = 30, start_altitude = 1500, end_altitude = 2000, 
  sun_altitude = 45, attenuation_coef = 2, offset_y = 300,
  cloud_cover = 0.35, frequency = 0.01, fractal_levels = 32,
  clear_clouds = TRUE
)

render_label(
  matrix_usd, x = 180, y = 180, z = 2500, zscale = 30,
  text = "Sanata Dharma University", textsize = 3, linewidth = 4,
  textcolor = "white",
  linecolor = "white",
  fonttype = "bold"
)

# Movie ----
phivechalf = 30 + 60 * 1/(1 + exp(seq(-7, 20, length.out = 180)/2))
phivecfull = c(phivechalf, rev(phivechalf))
thetavec = -90 + 45 * sin(seq(0,359,length.out = 360) * pi/180)
zoomvec = 0.45 + 0.2 * 1/(1 + exp(seq(-5, 20, length.out = 180)))
zoomvecfull = c(zoomvec, rev(zoomvec))


render_movie(
  filename = "press_usd_3d",
  type = "custom", 
  frames = 360,
  fps = 24,
  phi = phivecfull,
  zoom = zoomvecfull,
  theta = thetavec
)



