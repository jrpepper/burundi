library(shiny)
library(leaflet)
library(rgdal)

cList = c("CONDITIONS","CONDITIONS.1","CONDITIONS.2","CONDITIONS.3")

shinyUI(bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width="100%", height="100%"),
  absolutePanel(top = 10, right = 10,
                selectInput("conditions", "Condition",
                            cList
                            )
    )
  )
)