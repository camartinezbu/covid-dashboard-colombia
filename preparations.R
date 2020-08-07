# Installing and loading some useful packages ----

list_of_packages <- c("tidyverse", "lubridate", "sf", "leaflet", "shiny",
                    "shinydashboard", "naniar", "scales")

for (i in list_of_packages) {
  if(!require(i, character.only = T)) {install.packages(i)}
  library(i, character.only = T)
}
rm(i)

# Formating dates in spanish ----

## If on windows, uncomment next line
# Sys.setlocale("LC_TIME", "Spanish")

## If on MacOS or linux, uncomment next line
Sys.setlocale("LC_TIME", "es_ES.UTF-8")

##  To reset to default, uncomment next line
# Sys.setlocale("LC_TIME", "")

# Set working directory ----

setwd("~/Documents/GitHub/covid-dashboard-replica-colombia")

# Downloading data from INS ----

download.file("https://www.datos.gov.co/api/views/gt2j-8ykr/rows.csv?accessType=DOWNLOAD",
              "data/data.csv")

# To create the marker points in the geometry folder ----

download.file("https://geoportal.dane.gov.co/descargas/mgn_2018/MGN2018_DPTO_POLITICO.zip",
               "geometry/shape_departamento.zip")

unzip("geometry/shape_departamento.zip", exdir = "geometry/")

sf::st_read("geometry/MGN_DPTO_POLITICO.shp") %>%
  st_transform(crs = 3857) %>%
  st_point_on_surface() %>%
  st_transform(crs = 4326) %>%
  st_write("geometry/marker_points.shp")
