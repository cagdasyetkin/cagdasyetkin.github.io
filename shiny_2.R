library(shiny)
library(leaflet)
library(maps)
library(geosphere)
library(ggplot2)

#write.csv(cities_in_text, file = "cities_in_text.csv")

ui <- fluidPage(
  
  fluidRow(
    headerPanel('19th Century BCE, Cities in Trade Records'),
    
    column(4, 
           selectInput('type', 'City Type', c("All", "lost", "known"), selected = "lost")),
    
    column(4,  
           sliderInput("freq", "Occurance In Text:", min = 1,  max = 100, value = 5))
    
  ),
  
  column(10,
  fluidRow(leafletOutput("CountryMap", width = 850, height = 300))),
  
  # Create a new row for the table.
  fluidRow(
  column(7, 
         fluidRow(
           tableOutput('viewData')))),

  #FOOTER GOES
  hr(),
  print("Lost Cities estimated geo locations from: Trade, Merchants, and
the Lost Cities of the Bronze Age, Gojko Barjamovic - Thomas Chaney - Kerem Coşar - Ali Hortaçsu - October 26, 2017")
  
)


server <- function(input, output, session){
  
  # Filter data based on selections
  library(data.table)
  dt <- data.table(cities_in_text)
  
  # subset the data on various inputs from ui.R
  subsetData <- reactive({
    
    if(input$type[1] != 'All') {
      new_data <- dt[type == input$type[1], ]
    } else {
      new_data <- dt
    }
 
    new_data <- new_data[Occurance_In_Text <= input$freq,]
    
    
    return(new_data)
  })
  
  # display the data in real time to identify if the subsetting
  # is occurring as expected.
  output$viewData <- renderTable({
    subsetData()
  }) 
  
  
  mycolors <- colorRampPalette(c('green', 'blue', 'red', 'orange'))(length(cities_in_text$cityName))[rank(cities_in_text$cityName)]
  
  output$CountryMap <- renderLeaflet({
    leaflet() %>% 
      fitBounds(25, 32, 50, 45) %>%
      addTiles() %>%
      addCircleMarkers(data = subsetData(),
                       lng = ~longitude,
                       lat = ~latitude,
                       label = ~cityName,
                       radius = ~trade_power,
                       color = mycolors, stroke = T)
    
  })
  
}

shinyApp(ui =ui, server = server)

