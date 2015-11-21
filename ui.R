library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Yelp!", id = "nav",
                   
  tabPanel("Interactive Map",
      
          div(class = "outer",
            tags$head(
              includeCSS("styles.css")
            ),
          
          leafletOutput("map", width="100%", height="100%"),
          
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                        draggable = TRUE, top = 60, left = "auto", right = 10, bottom = "auto",
                        width = 330, height = "auto",
                        h2("User Explorer"),
                        selectInput("user","User", user.test$name),
                        sliderInput("distance", "Distance", 1, min = 1, max = 10, step = 0.2)
                        ),
          
          tags$div(id="cite",
                   "Data compiled for ", tags$em("DSS - Capstone"), " by Usamah Khan"
                  )
          )
  ))
)