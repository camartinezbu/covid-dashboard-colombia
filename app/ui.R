# User interface using shiny and shinydashboard

## Header ----
header <- dashboardHeader(title = "Tablero Coronavirus")

## Sidebar ----
sidebar <- dashboardSidebar(disable = T)

## Body ----
body <- dashboardBody(
  fluidRow(
    column(width = 3,
           valueBoxOutput(outputId = "n_confirmed",
                          width = NULL
           )
    ),
    column(width = 3,
           valueBoxOutput(outputId = "n_active",
                          width = NULL
           )
    ),
    column(width = 3,
           valueBoxOutput(outputId = "n_recovered",
                          width = NULL
           )
    ),
    column(width = 3,
           valueBoxOutput(outputId = "n_dead",
                          width = NULL
           )
    )
  )
)


## ShinyUI ----
shinyUI(
    dashboardPage(header, sidebar, body, skin = "black") 
)
