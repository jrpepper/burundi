library(shiny)
library(maps)
library(mapproj)
library(rgdal)
library(leaflet)

collines <- readOGR("BDI_Admin4_region.shp", layer = "BDI_Admin4_region", verbose = FALSE)
collines$NUM_PATIENTS <- as.numeric(as.character(collines$NUM_PATIEN))

pal <- colorQuantile("YlGn", NULL, n = 5)

shinyServer(
  function(input, output, session) {
    
    output$map <- renderLeaflet({
      leaflet(collines) %>% addTiles(urlTemplate = "https://api.tiles.mapbox.com/v4/mapbox.light/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYWxleGdvb2RlbGwiLCJhIjoicy1fNU4wZyJ9.PjqkYLHj6u5PLiWH61TQDw") %>%
        addPolygons(stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                    color= ~colorBin("YlOrRd", collines$NUM_PATIENTS, bins=100)(NUM_PATIENTS)
        )
    })
    
    observe({
      
      popupContent <- paste("<strong>",collines@data[,"COLLINE"],"</strong><br>", input$conditions,": ",collines@data[[input$conditions]],"<br>", sep="")
      
      leafletProxy("map", session, data = collines) %>%
        clearShapes() %>%
        addPolygons(stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                    color= ~colorBin("Blues", collines[[input$conditions]], bins=30)(collines[[input$conditions]]),
                    popup = ~popupContent
        )
    })
    
  }
)