library(shiny)

shinyUI(fluidPage(
        titlePanel("Prediction of total points of Cleveland Cavaliers in a game 
                   and game result through Lebron James's performance"),
        sidebarLayout(
                sidebarPanel(
                        helpText("This application predicts total points of Cleveland Cavaliers in a game and game result through Lebron James's performance."),
                        helpText("Please make a choise of parameters:"),
                        sliderInput(inputId = "PTS",
                                    label = "Points in a single game",
                                    value = 100,
                                    min = 0,
                                    max = 100,
                                    step = 1),
                        sliderInput(inputId = "AST",
                                    label = "Assists time in a single game:",
                                    value = 30,
                                    min = 0,
                                    max = 30,
                                    step = 1)
                ),
                
                mainPanel(
                        htmlOutput("GameResult"),
                        htmlOutput("TotalPoints"),
                        plotOutput("barsPlot", width = "50%"),
                        plotOutput("plot2", width = "100%"),
                        plotOutput("plot3", width = "100%")
                )
        )
))