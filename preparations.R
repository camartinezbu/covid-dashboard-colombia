# Installing and loading some useful packages

list_of_packages <- c("tidyverse", "lubridate", "sf", "leaflet", "shiny",
                    "shinydashboard", "naniar")

for (i in list_of_packages) {
  if(!require(i, character.only = T)) {install.packages(i)}
  library(i, character.only = T)
}
rm(i)

# Formating dates in spanish

## If on windows, uncomment next line
# Sys.setlocale("LC_TIME", "Spanish")

## If on MacOS or linux, uncomment next line
Sys.setlocale("LC_TIME", "es_ES.UTF-8")

##  To reset to default, uncomment next line
# Sys.setlocale("LC_TIME", "")


# Downloading data from INS

download.file("https://www.datos.gov.co/api/views/gt2j-8ykr/rows.csv?accessType=DOWNLOAD",
              "data/data.csv")


