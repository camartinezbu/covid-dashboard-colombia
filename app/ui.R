# User interface using shiny and shinydashboard

## Header ----
header <- dashboardHeader(title = "Tablero Coronavirus",
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
      ),
      paste0("Fecha del reporte: ",
            format(max(data$`Fecha diagnostico`, na.rm = T), format = "%d/%m/%Y"))
    ),
    tabItem(tabName = "cases",
            "Test")
  )
)


## ShinyUI ----
shinyUI(
    dashboardPage(header, sidebar, body, skin = "black") 
)
