# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'


library(sf)
library(tidyverse)
library(dplyr)
library(osmdata)


osmstreets <- function(capa){

bbox_base <- sf::st_bbox(st_read(capa) %>% sf::st_transform(4326))

sector <- osmdata::opq(bbox=bbox_base)

# Descarga de datos

dato <- c("\"highway\"=\"primary\"",
              "\"highway\"=\"trunk\"",
              "\"highway\"=\"trunk_link\"",
              "\"highway\"=\"secondary\"",
              "\"highway\"=\"tertiary\"",
              "\"highway\"=\"road\"",
              "\"highway\"=\"motorway\"",
              "\"highway\"=\"motorway_link\"",
              "\"highway\"=\"primary_link\"",
              "\"highway\"=\"tertiary_link\"",
              "\"highway\"=\"secondary_link\"",
              "\"highway\"=\"unclassified\"",
              "\"highway\"=\"residential\"",
              "\"highway\"=\"living_street\"",
              "\"highway\"=\"construction\"")

#
sector_osm <- osmdata::add_osm_features(opq=sector, features =  dato)

sector_datos <- osmdata::osmdata_sf(q=sector_osm)

sector_final <- sector_datos$osm_polygons

names(sector_final$geometry) <- NULL

sector_final_LP <- sf::st_cast(sector_final,"LINESTRING")

sector_final_L <- sector_datos$osm_lines

final <- rbind(sector_final_LP,sector_final_L)

final_select <- dplyr::select(final,c(osm_id,name,highway,access,surface,maxspeed))
}


