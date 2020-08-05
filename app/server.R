# Load data
data <- read_csv("../data/data.csv") %>%
    replace_with_na(replace = list('Fecha de muerte'= "-", atención = "N/A"))

# Server
shinyServer(function(input, output) {
    
    output$n_confirmed <- renderValueBox({
        valueBox(value = nrow(data), 
                 subtitle = "Casos confirmados",
                 color = "blue",
                 icon = icon("user"))
    })
    
    output$n_active <- renderValueBox({
        valueBox(value = nrow(data %>% filter(atención %in% c("Hospital", 
                                                              "Hospital UCI",
                                                              "Casa"))), 
                 subtitle = "Casos activos",
                 color = "aqua",
                 icon = icon("user"))
    })
    
    output$n_recovered <- renderValueBox({
        valueBox(value = nrow(data %>% filter(atención == "Recuperado")), 
                 subtitle = "Casos recuperados",
                 color = "fuchsia",
                 icon = icon("smile"))
    })
    
    output$n_dead <- renderValueBox({
        valueBox(value = nrow(data %>% filter(atención == "Fallecido")), 
                 subtitle = "Fallecidos",
                 color = "red",
                 icon = icon("monument"))
    })
    
})
