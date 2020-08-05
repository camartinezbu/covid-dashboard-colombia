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

# Server
shinyServer(function(input, output) {
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
    
    # Age composition plots
    output$plot_age_total <- renderPlot({
        ggplot(data, aes(x = rango_edad, fill = rango_edad)) +
            geom_bar()
    })
    
    output$plot_age_recovered <- renderPlot({
        ggplot(data_recovered, aes(x = rango_edad, fill = rango_edad)) +
            geom_bar()
    })
    
    output$plot_age_dead <- renderPlot({
        ggplot(data_dead, aes(x = rango_edad, fill = rango_edad)) +
            geom_bar()
    })
    
    #Sex composition plots
    output$plot_sex_total <- renderPlot({
        ggplot(data %>% count(Sexo_corregido),
               aes(x = 0, y = n, fill = Sexo_corregido)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0)
    })

    output$plot_sex_recovered <- renderPlot({
        ggplot(data_recovered %>% count(Sexo_corregido),
               aes(x = 0, y = n, fill = Sexo_corregido)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0)
    })

    output$plot_sex_dead <- renderPlot({
        ggplot(data_dead %>% count(Sexo_corregido),
               aes(x = 0, y = n, fill = Sexo_corregido)) +
            geom_bar(width = 1, stat = "identity") +
            coord_polar("y", start = 0)
    })
    
})
