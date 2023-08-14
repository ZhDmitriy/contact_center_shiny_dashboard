library(shiny)
library(shinydashboard)

data <- read.csv(file.choose(), sep=";")
View(data) #Посмотреть на данные

callid_vc <- data$Call.Id
answer_vc <- data$Answered..Y.N.
answer_vc <- c(answer_vc, "All")
data_vc <- data$Date
all_rows <- nrow(data)

# ^^^ Считать данные

ui <- dashboardPage(skin="purple",
                    
  dashboardHeader(title = "Контактный центр"),
   
  dashboardSidebar(sidebarMenu(
    
    br(),
    menuItem("Менеджер", icon=icon("list-alt")),
    menuItem("Аналитик", icon=icon("rocket"), badgeLabel = "New", badgeColor = "green")
    
    )
  ),
  dashboardBody(
    
    fluidRow(column(width=12,
                    infoBoxOutput("mau", width=2),
                    infoBoxOutput("cr", width=2),
                    infoBoxOutput("lost", width=2),
                    infoBoxOutput("avgtalk", width=2),
                    infoBoxOutput("spend", width=2),
                    infoBoxOutput("earned", width=2)
            )

    ),
    
    fluidRow(
      
      column(4, 
             selectInput("data", "Выберете дату: ", choices = data_vc)
      ),
      
      column(4, 
             selectInput("typecall", "Выберете тип вызова (Поле Answered..Y.N.): ", choices = answer_vc)
      )
      
    ),
    
    mainPanel(
      DT::dataTableOutput("dat")
    )
    
  )
)

server <- function(input, output) {
  
  output$dat <- DT::renderDataTable(DT::datatable({
    data_us <- data
    
    if (input$typecall == "All"){
      return_data <- data_us[data_us$Date == input$data, ]
    } else {
      return_data <- data_us[data_us$Date == input$data & data_us$Answered..Y.N. == input$typecall, ]
    }
    
    mau_us <- nrow(return_data)
    
    output$mau <- renderInfoBox({
      infoBox("MAU", mau_us, col='red', icon=icon("user"), fill=TRUE, width=2)
    })
  
    if (input$typecall == "Y"){
      output$cr <- renderInfoBox({
        infoBox("CR, %", (mau_us / all_rows)*100 , col='red', icon=icon("percent"), fill=TRUE, width=2)
      })
    }
    else{
      output$cr <- renderInfoBox({
        infoBox("cr", "% отвеченных", col='red', icon=icon("percent"), fill=TRUE, width=2)
      })
    }
    
    if (input$typecall == "N"){
      output$lost <- renderInfoBox({
        infoBox("Потеряно, руб.", nrow(return_data) * 350, col='red', icon=icon("minus"), fill=TRUE, width=2)
      })
    }
    else{
      output$lost <- renderInfoBox({
        infoBox("Потеряно, руб.", "Для неотвеченных", col='red', icon=icon("minus"), fill=TRUE, width=2)
      })
    }
    
    output$avgtalk <- renderInfoBox({
      infoBox("AvgTalk/Line",round(mean(return_data$Time), digits = 4), col='red', icon=icon("phone"), fill=TRUE, width=2)
      
    })
    
    output$spend <- renderInfoBox({
      infoBox("Потрачено, руб.", nrow(return_data) * 350, col='red', icon=icon("wallet"), fill=TRUE, width=2)
    })
    
    if (input$typecall == "Y"){
      output$earned <- renderInfoBox({
        infoBox("Заработано, руб.", nrow(return_data) * 700 * (mau_us / all_rows)*100, col='red', icon=icon("wallet"), fill=TRUE, width=2)
      })
    } else{
      output$earned <- renderInfoBox({
        infoBox("Заработано, руб.", "Для отвеченных", col='red', icon=icon("wallet"), fill=TRUE, width=2)
      })
    }
    
    return_data
  }), server = FALSE)
  
}

shinyApp(ui, server)

