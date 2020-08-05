# Installing and loading some useful packages

listOfPackages <- c("tidyverse", "lubridate", "sf", "leaflet", "shiny",
                    "shinydashboard")

for (i in listOfPackages) {
  if(!require(i, character.only = T)) {install.packages(i)}
  library(i, character.only = T)
}

# Downloading data from INS

download.file("https://www.datos.gov.co/api/views/gt2j-8ykr/rows.csv?accessType=DOWNLOAD&bom=true&format=true",
              "data/data.csv")
