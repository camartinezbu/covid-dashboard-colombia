# User interface using shiny and shinydashboard

## Header ----
header <- dashboardHeader(title = paste("Tablero Coronavirus"),
                          dropdownMenu(type = "messages",
                                       messageItem(from = "camartinezbu",
                                                   message = "Haz clic para ver el código fuente.",
                                                   href = "https://github.com/camartinezbu/covid-dashboard-replica-colombia")))

## Sidebar ----
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Panorama", tabName = "overview"),
    menuItem("Casos", tabName = "cases")
  )
)

## Body ----
body <- dashboardBody(
  # Value Box row
  tabItems(
    tabItem(tabName = "overview",
      fluidRow(div(textOutput(outputId = "report_date"),
                    style = "color:red; text-align: center;
                    font-weight: bold; padding-bottom: 10px;")),
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
    ),
    tabItem(tabName = "cases",
            "Test")
  )
)


## ShinyUI ----
shinyUI(
    dashboardPage(header, sidebar, body, skin = "black") 
)
