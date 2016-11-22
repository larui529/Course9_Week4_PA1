
library(shiny)
library(HistData)
library(dplyr)
library(ggplot2)
library(caret)

# converting in centimeters
df = read.csv("Lebron2015.csv")
df1 = df[,c("X.1", "AST", "PTS", "GmSc")]
df1$X.1 = substring(df1$X.1, 1,2)
df1$X.1 = as.factor(df1$X.1)

# linear model
regmod <- lm(GmSc ~ AST + PTS , data=df1)
fitmod = train (X.1 ~AST + PTS,df1,  method = "rf")
rt = predict (fitmod, newdata=df)

shinyServer(function(input, output) {
        output$GameResult <- renderText({
                paste("When Lebron James get points of",
                      strong(round(input$PTS, 1)),
                      "and assistance of",
                      strong(round(input$AST, 1)),
                      "times, the predicted")
        })
        output$TotalPoints <- renderText({
                df <- data.frame(PTS=input$PTS,
                                 AST=input$AST)
                ch <- predict(regmod, newdata=df)
                rt = predict (fitmod, newdata=df)
                
               paste0(
                       "Lebron James's game score tonight is about ",
                       em(strong(round(ch))),
                       "and Cleveland Cavaliers will ",
                       em(strong(
                               if (rt == "W") {
                                       "Win"
                               } else {
                                       "Loss"
                               }
                       )),
                       "the game"
                )
        })
        output$barsPlot <- renderPlot({
                
                df <- data.frame(PTS=input$PTS,
                                 AST=input$AST)
                ch <- predict(regmod, newdata=df)
                yvals <- c("Points", "Assists", "Game Score")
                df <- data.frame(
                        x = factor(yvals, levels = yvals, ordered = TRUE),
                        y = c(input$PTS, input$AST, ch),
                        colors = c("pink", "orange", "blue")
                )
                ggplot(df, aes(x=x, y=y, color=colors, fill=colors)) +
                        geom_bar(stat="identity", width=0.5) +
                        xlab("") +
                        ylab("Game Score") +
                        theme_minimal() +
                        theme(legend.position="none")
                
        })
        output$plot2 <- renderPlot({
                ggplot(data = df1, aes(x=PTS, y = GmSc, col = X.1))+
                        geom_point()+
                        geom_smooth(method = "lm")
        })
        output$plot3 <- renderPlot({
                ggplot(data = df1, aes(x=AST, y = GmSc, col = X.1))+
                        geom_point()+
                        geom_smooth(method = "lm")
        })
})