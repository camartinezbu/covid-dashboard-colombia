# User interface using shiny and shinydashboard

## Header ----
header <- dashboardHeader(title = paste("Covid-19 en Colombia"),
                          dropdownMenu(type = "messages",
                                       messageItem(from = "camartinezbu",
                                                   message = "Haz clic para ver el código fuente.",
                                                   href = "https://github.com/camartinezbu/covid-dashboard-replica-colombia")))

## Sidebar ----
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Panorama general", tabName = "overview"),
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
                               plotOutput(outputId = "plot_age_confirmed")
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
                               plotOutput(outputId = "plot_sex_confirmed")
                      ),
                      tabPanel("Recuperados",
                               plotOutput(outputId = "plot_sex_recovered")
                      ),
                      tabPanel("Fallecidos",
                               plotOutput(outputId = "plot_sex_dead")
                      )
               )
        )
      ),
      # Evolution of cases
      fluidRow(
        column(width = 8,
               tabBox(title = "Históricos de casos reportados",
                      width = NULL,
                      tabPanel("Acumulados",
                               plotOutput(outputId = "plot_cum_cases")
                      ),
                      tabPanel("Confirmados",
                               plotOutput(outputId = "plot_daily_confirmed")
                      ),
                      tabPanel("Recuperados",
                               plotOutput(outputId = "plot_daily_recovered")
                      ),
                      tabPanel("Fallecidos",
                               plotOutput(outputId = "plot_daily_dead")
                      )
               )
        ),
        column(width = 4,
               fluidRow(
                 box(title = "Distribución por tipo",
                     "Gráfico tipo"
                     )
               ),
               fluidRow(
                 box(title = "Distribución por estado de casos",
                     "Gráfico estado")
               )

        )
      ),
      # Map of distribution by department
      fluidRow(
        box(title = "Distribución por departamentos y distritos especiales",
            "Mapa")
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
