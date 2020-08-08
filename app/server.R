# Load data

## Database
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
                                      Sexo %in% c("F", "f") ~ "Femenino")) %>%
    mutate(Tipo_corregido = case_when(Tipo == "Importado" ~ "Importado",
                                      Tipo %in% c("Relacionado", "RELACIONADO") ~ "Relacionado",
                                      Tipo %in% c("En estudio", "EN ESTUDIO") ~ "En estudio")) %>%
    mutate(`Codigo departamento` = str_pad(`Codigo departamento`, width = 2, pad = "0", side = "left"))

data_active <- data %>% filter(atención %in% c("Hospital", "Hospital UCI", "Casa"))

data_recovered <- data %>% filter(atención == "Recuperado")

data_dead <- data %>% filter(atención == "Fallecido")

## Summary tables national

n_cases_confirmed <- data %>%
    group_by(`fecha reporte web`) %>%
    summarise(daily_cases_confirmed = n()) %>%
    mutate(cum_cases_confirmed = cumsum(daily_cases_confirmed))

n_cases_recovered <- data_recovered %>%
    group_by(`Fecha recuperado`) %>%
    summarise(daily_cases_recovered = n()) %>%
    mutate(cum_cases_recovered = cumsum(daily_cases_recovered))

n_cases_dead <- data_dead %>%
    group_by(`Fecha de muerte`) %>%
    summarise(daily_cases_dead = n()) %>%
    mutate(cum_cases_dead = cumsum(daily_cases_dead))

n_cases <- n_cases_confirmed %>%
    left_join(n_cases_recovered, by = c("fecha reporte web" = "Fecha recuperado")) %>%
    left_join(n_cases_dead, by = c("fecha reporte web" = "Fecha de muerte")) %>%
    pivot_longer(cols = -`fecha reporte web`, names_to = "type", values_to = "values")

## Summary tables by department

n_cases_confirmed_department <- data %>%
    group_by(`Codigo departamento`) %>%
    summarise(total_cases_confirmed = n())

n_cases_recovered_department <- data_recovered %>%
    group_by(`Codigo departamento`) %>%
    summarise(total_cases_recovered = n())

n_cases_dead_department <- data_dead %>%
    group_by(`Codigo departamento`) %>%
    summarise(total_cases_dead = n())

n_cases_department <- n_cases_confirmed_department %>%
    left_join(n_cases_recovered_department, by = "Codigo departamento") %>%
    left_join(n_cases_dead_department, by = "Codigo departamento") %>%
    mutate(log_total_cases_confirmed = log(total_cases_confirmed))

## Department marker points

department_marker_points <- sf::st_read("../geometry/marker_points.shp")

n_cases_department_shp <- department_marker_points %>%
    left_join(n_cases_department, by = c("DPTO_CCDGO" = "Codigo departamento")) %>%
    mutate(label = paste(sep = "</br>",
                         paste0("<b>", DPTO_CNMBR, "</b>"),
                         paste0("Casos confirmados: ", total_cases_confirmed),
                         paste0("Casos recuperados: ", total_cases_recovered),
                         paste0("Fallecidos: ", total_cases_dead)
                         ))

## Relevant constants

start_time <- as.POSIXct("03-06-2020", tz = "UTC", format = "%d-%m-%Y")
end_time <- max(data$`fecha reporte web`, na.rm = T)

start_end <- c(start_time, end_time)


# Server
shinyServer(function(input, output) {
    # Report date
    output$report_date <- renderText({
        paste0("Actualizado hasta el reporte del ",
               format(end_time, format = "%d/%m/%Y"))
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
    create_plot_age <- function(data) {
        ggplot(data, aes(x = rango_edad, fill = rango_edad)) +
            geom_bar() + 
            theme_minimal() +
            theme(legend.position = "none")
    }
    
    output$plot_age_confirmed <- renderPlot({
        create_plot_age(data)
    })
    
    output$plot_age_recovered <- renderPlot({
        create_plot_age(data_recovered)
    })
    
    output$plot_age_dead <- renderPlot({
        create_plot_age(data_dead)
    })
    
    # Cases by sex plots
    create_plot_sex <- function(data){
        ggplot(data %>% count(Sexo_corregido),
           aes(x = 0, y = n, fill = Sexo_corregido)) +
        geom_bar(width = 1, stat = "identity") +
        coord_polar("y", start = 0) +
        theme_minimal()
    }
    
    output$plot_sex_confirmed <- renderPlot({
        create_plot_sex(data)
    })

    output$plot_sex_recovered <- renderPlot({
        create_plot_sex(data_recovered)
    })

    output$plot_sex_dead <- renderPlot({
        create_plot_sex(data_dead)
    })
    
    # Reported cases historic plots
    output$plot_cum_cases <- renderPlot({
        ggplot(n_cases %>% filter(type %in% c("cum_cases_confirmed", 
                                              "cum_cases_recovered",
                                              "cum_cases_dead")),
               aes(x = `fecha reporte web`, y = values, color = type)) +
            geom_line() +
            theme_minimal()
            
    })
    
    create_plot_daily <- function(data, x, y, color) {
        ggplot(data,
               aes_string(x = x, y = y)) +
            geom_line(col = color) + # If I want line graph
            # geom_bar(fill = color) + # If I want bar graph
            # geom_area(fill = color) + # If I want area graph
            theme_minimal()
    }
    
    output$plot_daily_confirmed <- renderPlot({
        create_plot_daily(n_cases_confirmed, "`fecha reporte web`", 
                          "daily_cases_confirmed", "#F8766D")
    })
    
    output$plot_daily_recovered <- renderPlot({
        create_plot_daily(n_cases_recovered, "`Fecha recuperado`",
                          "daily_cases_recovered", "#619CFF")
    })
    
    output$plot_daily_dead <- renderPlot({
        create_plot_daily(n_cases_dead, "`Fecha de muerte`",
                          "daily_cases_dead", "#00BA38")
    })
    
    # Distribution bu department map
    
    output$map_department_cases <- renderLeaflet({
        leaflet(n_cases_department_shp) %>%
            addProviderTiles("CartoDB.PositronNoLabels") %>%
            addCircleMarkers(radius = ~log_total_cases_confirmed*2/3,
                             stroke = F,
                             fillOpacity = 0.5,
                             color = "red",
                             label = lapply(n_cases_department_shp$label, htmltools::HTML))
    })
    
    # Cases by type plot
    output$plot_type_cases <- renderPlot({
        ggplot(data %>% count(Tipo_corregido),
               aes(x = 0, y = n, fill = Tipo_corregido)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0) +
            theme_minimal()
    })
    
    # Cases by status plot
    output$plot_status_cases <- renderPlot({
        ggplot(data %>% count(Estado),
               aes(x = 0, y = n, fill = Estado)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0) +
            theme_minimal()
    })
    
})
