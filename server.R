library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

user.test <- readRDS("user.test.rds")

shinyServer(function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet(user.test) %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -73.587810, lat = 45.50884, zoom = 14) %>%
      addMarkers(~longitude, ~latitude, group = "Users") %>%
      addLayersControl(
        baseGroups = c("Users", "Zone")
      )
  })
  
## A reactive expression that returns the set of zips that are
## in bounds right now
  
  userInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(user.test[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(user.test,
           latitude >= latRng[1] & latitude <= latRng[2] &
             longitude >= lngRng[1] & longitude <= lngRng[2])
  })
  
  selectUser <- reactive({
    user.test[user.test$name == input$user,]
  })
  
  observe({
    leafletProxy("map", data = selectUser()) %>% clearShapes() %>%
      addCircles(~longitude, ~latitude, radius = (input$distance*500),
                 stroke = TRUE, weight = 1, fill = FALSE, color = "red")
  })

  
## Show a popup
  showPopup <- function(lat, lng) {
    selectedUser <- user.test[user.test$longitude == lng,]
    content <- as.character(tagList(
      tags$h5("Name:", selectedUser$name),
      tags$h6("Average Stars:",selectedUser$average_stars),
      tags$h6("Fans:", selectedUser$fans),
      tags$h6("Review Count:", selectedUser$review_count)
    )) 
    leafletProxy("map") %>% addPopups(lng, lat, content, options = popupOptions(closeOnClick = T))
  }
  
  
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_marker_click
    if (is.null(event))
      return()
    
    isolate({
      showPopup(event$lat, event$lng)
    })
    
})
 
}) 
  