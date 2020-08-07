# Load data
data <- read_csv("../data/data.csv") %>%
    replace_with_na(replace = list('Fecha de muerte'= "-", atención = "N/A")) %>%
    mutate(rango_edad = case_when(between(Edad, 0, 9) ~ "0-9",
                                  between(Edad, 10, 19) ~ "10-19",
                                  between(Edad, 20, 29) ~ "20-29",
                                  between(Edad, 30, 39) ~ "30-39",
                                  between(Edad, 40, 49) ~ "40-49",
                                  between(Edad, 50, 59) ~ "50-59",
                                  between(Edad, 60, 69) ~ "60-69",
                                  between(Edad, 70, 79) ~ "70-79",
                                  between(Edad, 80, 89) ~ "80-89",
                                  Edad >= 90 ~ "90 o >"
                                  )) %>%
    mutate(Sexo_corregido = case_when(Sexo %in% c("M", "m") ~ "Masculino",
                                      Sexo %in% c("F", "f") ~ "Femenino"))

data_active <- data %>% filter(atención %in% c("Hospital", "Hospital UCI", "Casa"))

data_recovered <- data %>% filter(atención == "Recuperado")

data_dead <- data %>% filter(atención == "Fallecido")

n_cases_positive <- data %>%
    group_by(`fecha reporte web`) %>%
    summarise(daily_cases_positive = n()) %>%
    mutate(cum_cases_positive = cumsum(daily_cases_positive))

n_cases_recovered <- data_recovered %>%
    group_by(`Fecha recuperado`) %>%
    summarise(daily_cases_recovered = n()) %>%
    mutate(cum_cases_recovered = cumsum(daily_cases_recovered))

n_cases_dead <- data_dead %>%
    group_by(`Fecha de muerte`) %>%
    summarise(daily_cases_dead = n()) %>%
    mutate(cum_cases_dead = cumsum(daily_cases_dead))

n_cases <- n_cases_positive %>%
    left_join(n_cases_recovered, by = c("fecha reporte web" = "Fecha recuperado")) %>%
    left_join(n_cases_dead, by = c("fecha reporte web" = "Fecha de muerte"))

# Server
shinyServer(function(input, output) {
    # Report date
    output$report_date <- renderText({
        paste0("Actualizado hasta el reporte del ",
               format(max(data$`fecha reporte web`, na.rm = T), format = "%d de %B de %Y"))
    })
    
    # Value Boxes
    output$n_confirmed <- renderValueBox({
        valueBox(value = nrow(data), 
                 subtitle = "Casos confirmados",
                 color = "blue",
                 icon = icon("user"))
    })
    
    output$n_active <- renderValueBox({
        valueBox(value = nrow(data_active), 
                 subtitle = "Casos activos",
                 color = "aqua",
                 icon = icon("user"))
    })
    
    output$n_recovered <- renderValueBox({
        valueBox(value = nrow(data_recovered), 
                 subtitle = "Casos recuperados",
                 color = "fuchsia",
                 icon = icon("smile"))
    })
    
    output$n_dead <- renderValueBox({
        valueBox(value = nrow(data_dead), 
                 subtitle = "Fallecidos",
                 color = "red",
                 icon = icon("monument"))
    })
    
    # Cases by Age plots
    output$plot_age_total <- renderPlot({
        ggplot(data, aes(x = rango_edad, fill = rango_edad)) +
            geom_bar() + theme_minimal() +
            theme(legend.position = "none")
    })
    
    output$plot_age_recovered <- renderPlot({
        ggplot(data_recovered, aes(x = rango_edad, fill = rango_edad)) +
            geom_bar() + theme_minimal() +
            theme(legend.position = "none")
    })
    
    output$plot_age_dead <- renderPlot({
        ggplot(data_dead, aes(x = rango_edad, fill = rango_edad)) +
            geom_bar() + theme_minimal() +
            theme(legend.position = "none")
    })
    
    # Cases by sex plots
    output$plot_sex_total <- renderPlot({
        ggplot(data %>% count(Sexo_corregido),
               aes(x = 0, y = n, fill = Sexo_corregido)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0) +
            theme_minimal()
    })

    output$plot_sex_recovered <- renderPlot({
        ggplot(data_recovered %>% count(Sexo_corregido),
               aes(x = 0, y = n, fill = Sexo_corregido)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0) +
            theme_minimal()
    })

    output$plot_sex_dead <- renderPlot({
        ggplot(data_dead %>% count(Sexo_corregido),
               aes(x = 0, y = n, fill = Sexo_corregido)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0) +
            theme_minimal()
    })
    
    # Reported cases historic plots
    output$plot_cum_cases <- renderPlot({
        
    })
    
    output$plot_daily_cases <- renderPlot({
        
    })
    
    # Cases by type plot
    output$plot_type_cases <- renderPlot({
        
    })
    
    # Cases by status plot
    output$plot_status_cases <- renderPlot({
        
    })
    
})
