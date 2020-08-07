# Installing and loading some useful packages

list_of_packages <- c("tidyverse", "lubridate", "sf", "leaflet", "shiny",
                    "shinydashboard", "naniar")

for (i in list_of_packages) {
  if(!require(i, character.only = T)) {install.packages(i)}
  library(i, character.only = T)
}
rm(i)

# Downloading data from INS

download.file("https://www.datos.gov.co/api/views/gt2j-8ykr/rows.csv?accessType=DOWNLOAD",
              "data/data.csv")


