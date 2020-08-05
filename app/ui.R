# User interface using shiny and shinydashboard

## Header ----
header <- dashboardHeader(title = "Tablero Coronavirus")

## Sidebar ----
sidebar <- dashboardSidebar(disable = T)

## Body ----
body <- dashboardBody(
  # Value Box row
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
  ),
  # Age and Sex composition row
  fluidRow(
    column(width = 6,
           tabBox(title = "Distribución por Edad",
                  width = NULL,
                  tabPanel("Confimados",
                           plotOutput(outputId = "plot_age_total")
                           ),
                  tabPanel("Recuperados",
                           plotOutput(outputId = "plot_age_recovered")
                           ),
                  tabPanel("Fallecidos",
                           plotOutput(outputId = "plot_age_dead")
                           )
                  )
      
    ),
    column(width = 6,
           tabBox(title = "Distribución por Sexo",
                  width = NULL,
                  tabPanel("Confimados",
                           plotOutput(outputId = "plot_sex_total")
                  ),
                  tabPanel("Recuperados",
                           plotOutput(outputId = "plot_sex_recovered")
                  ),
                  tabPanel("Fallecidos",
                           plotOutput(outputId = "plot_sex_dead")
                  )
           )
        
    )
  )
)


## ShinyUI ----
shinyUI(
    dashboardPage(header, sidebar, body, skin = "black") 
)
