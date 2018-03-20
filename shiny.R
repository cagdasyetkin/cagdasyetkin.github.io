
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
library(leaflet)
library(maps)
library(ggplot2)

ui <- fluidPage(
  
  leafletOutput("CountryMap", width = 1000, height = 500),

      fluidRow(
        shinydashboard::box(
        actionButton(inputId='ab1', label="See the Cities", 
        icon = icon("th"), 
        onclick ="window.open('https://www.youtube.com/watch?v=00VaKcv47HA')"),
        
        shinydashboard::box(
        actionButton(inputId='ab1', label="Book Your Ticket", 
        icon = icon("th"), 
        onclick ="window.open('https://www.turkishairlines.com/')")
        )
      )))

server <- function(input, output){
  cities_in_text <- read.csv("cities_in_text.csv")
  Country = map("world", fill = TRUE, plot = FALSE, regions="Turkey", exact=TRUE)
  output$CountryMap <- renderLeaflet({
    leaflet(Country) %>% addTiles() %>%
      addCircleMarkers(lng = cities_in_text$longitude, 
                       lat = cities_in_text$latitude,
                       label = cities_in_text$cityName, 
                       radius = cities_in_text$trade_power,
                       color = "red")
                      
      
  })

}


shinyApp(ui =ui, server = server)

