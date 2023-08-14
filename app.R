library(shiny)
library(shinydashboard)

#data <- read.csv(file.choose(), sep=";")
#View(data)

data

start_date <- readline(prompt = "Start: ") #включительно
end_date <- readline(prompt = "End: ") #не включительно

#выбранный интервал пользователя
data_user <- data[data$Date == start_date, ]
View(data_user)

#считаем метрику MAU
mau <- nrow(data_user)
mau

#Константые значения 
choices_data_start <- data$Date


# ^^^ Логика с данными 

ui <- dashboardPage(skin="purple",
    dashboardHeader(title="Контактный центр"),
    dashboardSidebar(
      sidebarMenu(
        br(),
        menuItem("Менеджер", icon=icon("list-alt")),
        menuItem("Аналитик", icon=icon("rocket")),
        selectInput("date_user_start", "Выберете начало периода:", choices_data_start), 
        selectInput("date_user_end", "Выберете конец периода:", choices_data_start), #НЕ ВКЛЮЧИТЕЛЬНО
      )
    ),
    dashboardBody(
      fluidRow(
        column(width=12,
               infoBoxOutput("ibox", width=2),
               #infoBox("MAU", uiOutput("mau"), col='red', icon=icon("user"), width=2),
               infoBox("CR (кц)%", paste0('20%'), col='red', icon=icon("percent"), width=2),
               infoBox("Потеряно, т. р.", 12000, col='red', icon=icon("minus"), width=2), 
               infoBox("AvgTalk, сек.", 325, col='red', icon=icon("phone"), width=2),
               infoBox("Потрачено, т. р.", 12349, col='red', icon=icon("wallet"), width=2),
               infoBox("Заработано, т. р.", 1235200, col='red', icon=icon("wallet"), width=2)
        )
      ),
      fluidRow(
          box(title="DAU", status="primary", solidHeader = T, plotOutput("histogram")),
          box(title="Среднее время работы оператора в течение месяца", status="primary", solidHeader = T, plotOutput("histogram"))
      ),
      fluidRow(
        box(title="Количество звонков по категориям за месяц", status="primary", solidHeader = T, plotOutput("histogram"))
      ),
      fluidRow(
        #Здесь нужно нарисовать круговую диаграмму
        #---
        #---
      )
    )
  )



server <- function(input, output){
  
  #output$ibox <- renderInfoBox({
  #  infoBox(
  #    "MAU",
  #    5,
  #    icon = icon("credit-card"),
  #    width=2
  #  )
  #})
  
}

shinyApp(ui = ui, server = server)



