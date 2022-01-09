#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

dayReport <<- list()
actTimeH <<- -1
actTimeM <<- -1

paginate <<- list(actPage = 0,cantPage = 1,cantElements = 4,values=list())


addToOutputActivities <- function(){
  output <- read.csv(file = "DataOutput.csv",sep = ',',header = TRUE)
  last <- tail(output,1)
  print("Okkk")
  print(last)
  lastID <- 1
  if(nrow(last) > 0){
    lastID <- last$ID+1
      
  }
  print(lastID)
  IDs <- c()
  Activities <- c()
  StartTimes <- c()
  EndTimes <- c()
  for (v in dayReport) {
    IDs <-c(IDs,lastID)
    Activities <- c(Activities,v[1])
    StartTimes <- c(StartTimes,v[2])
    EndTimes <- c(EndTimes,v[3])
    
  }
  data <- data.frame(ID = IDs,Activitie=Activities,StartTime = StartTimes,EndTime=EndTimes)
  output <- rbind(output,data)
  print(output)
  
  write.table(output,file = "DataOutput.csv",sep = ',',row.names = FALSE)
  output
}




selectActivitie <- function(activities){
  for (v in activities) {
    if(!is.null(v)){
      return(v)
    }
  }
}

UpdateListActivities <- function(initTimeH,initTimeM,time,activities){
  if(!is.null(activities) && time !=1 ){
  
  endTimeH <- 0
  endTimeM <- 0
  
  if(!exists("actTimeH")||actTimeH == -1){
    actTimeH <<- initTimeH
    actTimeM <<- initTimeM
  }
  if(time + actTimeM < 60){
    endTimeM <- actTimeM + time
    endTimeH <- actTimeH
  }
  if(time + actTimeM >= 60){
    m <- (time + actTimeM) %% 60
    h <- as.integer((time + actTimeM) / 60)
    endTimeH <- actTimeH + h
    endTimeM <- m
  }
  
  stringHourStart <- paste(toString(actTimeH) , toString(actTimeM),sep = ":" )
  stringHourEnd <-  paste(toString(endTimeH) , toString(endTimeM),sep = ":" )
  activitie<-selectActivitie(activities)
  dayReport[[length(dayReport)+1]] <<- c(activitie,stringHourStart,stringHourEnd)
  actTimeH <<- endTimeH
  actTimeM <<- endTimeM
  
  return(list(day = dayReport))
  }
}

listToData <- function(activities){
  Activities <- c()
  InitTimes <- c()
  EndTimes <- c()
  for (v in activities) {
    Activities[length(Activities)+1] <- v[1]
    InitTimes[length(InitTimes)+1] <- v[2]
    EndTimes[length(EndTimes)+1] <- v[3]
  }
  data <- data.frame(Activities,InitTimes,EndTimes)
  data
}

createPaginate <- function(action){
  data <- read.csv("Activities.csv",sep = ',')
  nr <- nrow(data)
  n <- paginate$cantElements
  repre <- c()
  for (v in (1:ceiling(nr/n))) {
    repre<- c(repre,paste("page",toString(v),sep = "_"))
  }
  values <- split(data,rep( repre,each=n,length.out = nr))
  paginate$cantPage <<- length(values)
  if(action && paginate$actPage + 1 <=  paginate$cantPage ){
    paginate$actPage <<- paginate$actPage + 1
  }
  
  if(!action && paginate$actPage - 1 > 0){
    paginate$actPage <<- paginate$actPage - 1
  }
  paginate$values <<- values
  
}


cleanPage <- function(){
    if(length(paginate$values)>0){ 
    p <- paginate$actPage
    n <- ncol(paginate$values[[p]])
    for (i in (1:n)) {
      toRemov <- paste("#col",toString(i),sep = '')
      removeUI(selector = toRemov)
    }
    removeUI(selector = "#addActivitie")
    
    removeUI(selector = "#submitDay")
  }
}

addElemnts <- function(){
  p <- paginate$actPage
  n <-ncol(paginate$values[[p]])
  Names <- names(paginate$values[[p]])
  for (i in (1:n)) {
    id <- paste("radio",toString(i),sep = '')
    idc <-paste("col",toString(i),sep = '') 
    V <- paginate$values[[p]][[i]]
    insertUI(selector = "#ActivitiesPaginate",ui = column(3,id=idc  ,radioButtons(id,Names[[i]],choices = V,selected = character(0))))
  }
  insertUI(selector ='#ButtonsPaginate',ui = actionButton(inputId = "addActivitie",label = "Agregar la actividad"))
  insertUI(selector ='#ButtonsPaginate' , ui = actionButton(inputId = "submitDay",label = "Guardar el reporte del dia"))
}


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
    
    observeEvent(input$Next,{
      cleanPage()
      createPaginate(TRUE)
      addElemnts()
      
    }
    )
  
  observeEvent(input$Prev,{
    cleanPage()
    createPaginate(FALSE)
    addElemnts()
   })
  
  
    observeEvent(input$submitDay,{
      addToOutputActivities()
      dayReport <<- list()
      actTimeH <<- -1
      actTimeM <<- -1
    })
   
    
    output$OutputTable <- renderDataTable({
      input$submitDay
      output <- read.csv("DataOutput.csv",sep = ',',header = TRUE)
      output
      
    })
   
    observeEvent(input$addActivitie,{
      p <- paginate$actPage
      n <-ncol(paginate$values[[p]])
      radios <- c()
      for (i in (1:n)) {
        radio <- paste("radio",toString(i),sep = '') 
        radios<-c(radios,input[[radio]])
      }
      UpdateListActivities(input$timeHour,input$timeMin,input$time,radios)
      
    })
  
  
    
        
  output$activitiesDayli<-renderTable({
    input$addActivitie
    input$submitDay
    table<-listToData(dayReport)
    table
    
  })  
  
  
  observeEvent(input$addActivitie,{
    
    p <- paginate$actPage
    n <- ncol(paginate$values[[p]])
    for (i in (1:n)) {
      radio <- paste("radio",toString(i),sep = '') 
      updateRadioButtons(session,inputId = radio,selected = character(0))
    }
  })
    
})
