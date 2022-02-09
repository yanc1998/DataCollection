#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Recolecter Data"),
    
      
    sidebarLayout(
        sidebarPanel(
            sliderInput("time","Time to action:",min = 1,max = 1440,value = 1),
            numericInput("timeHour", label = h3("Enter wake up time hour"), value = 4,min = 4,max = 16),
            numericInput("timeMin", label = h3("Enter wake up time minut"), value = 0,min = 0,max = 59),
            actionButton(inputId = "Prev",label = "Prev"),
            actionButton(inputId = "Next",label = "Next")
        ),
        
       
        mainPanel(
          tabsetPanel(
            id = "tabs",
  
            tabPanel("Datos",
                     tableOutput("activitiesDayli"),
                     fluidRow(tags$div(id = 'ActivitiesPaginate')),
                     tags$div(id = 'ButtonsPaginate'),
              
                             
            ),
            
            
            tabPanel("Data Table",
                     dataTableOutput("OutputTable"))
            
          ),
            
        )
    )
))
