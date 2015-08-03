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
      leaflet(collines) %>%
        addPolygons(stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                    color= ~colorBin("YlOrRd", collines$NUM_PATIENTS, bins=100)(NUM_PATIENTS)
        )
      })

    reactive
    
    observe({
      
      if (input$conditions == "CONDITIONS") {
        leafletProxy("map", session, data = collines) %>%
        clearShapes() %>%
        addPolygons(stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
          color= ~colorBin("Blues", collines$CONDITIONS, bins=100)(CONDITIONS)
          )
      }
      if (input$conditions == "CONDITIONS.1") {
        leafletProxy("map", session, data = collines) %>%
          clearShapes() %>%
          addPolygons(stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                      color= ~colorBin("Blues", collines$CONDITIONS.1, bins=100)(CONDITIONS.1)
          )
      }
    })

    
    }
  )

