# User interface using shiny and shinydashboard

## Header ----
header <- dashboardHeader(title = "Tablero Coronavirus")

## Sidebar ----
sidebar <- dashboardSidebar(disable = T)

## Body ----
body <- dashboardBody("Hola Mundo")


## ShinuUI ----
shinyUI(
    dashboardPage(header, sidebar, body) 
)
