#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
data(mtcars)
mtcars$am <- factor(mtcars$am, labels = c("Automatic", "Manual"))

# Define server logic required to draw a histogram
shinyServer(function(input, output){
        
        model1 <- lm(mpg ~ wt, data = mtcars)
        model1pred <- reactive({
                wtInput <- input$sliderwt
                predict(model1, newdata = data.frame(wt = wtInput))
        })
        
        # Generate the first plot
        output$plot1 <- renderPlot({
                wtInput <- input$sliderwt
                plot(mtcars$wt, mtcars$mpg)
                if(input$showModel1){
                        abline(model1, col = "red", lwd = 2)
                 }
                points(wtInput, model1pred(), col = "red", pch = 16, cex = 2)
                output$pred1 <- renderText({model1pred()})
        })
        
        # Generate the second plot
        output$plot2 <- renderPlot({
                x <- mtcars$mpg
                bins <- seq(min(x), max(x), length.out = input$bins + 1)
                h <- hist(x, breaks = bins, col = "pink", 
                          xlab = "Miles Per Gallon", 
                          main = "Histogram with normal curve and box")
                xfit <- seq(min(x), max(x), length = 40)
                yfit <- dnorm(xfit, mean = mean(x), sd = sd(x))
                yfit <- yfit * diff(h$mids[1:2]) * length(x)
                lines(xfit, yfit, col = "blue", lwd = 2)
        })

        # Compute the forumla text in a reactive expression since it is 
        # shared by the output$caption and output$mpgPlot expressions
        formulaText <- reactive({
                paste("mpg ~", input$variable)
        })
        
        # Return the formula text for printing as a caption
        output$caption <- renderText({
                formulaText()
        })
        
        # Generate a plot of the requested variable against mpg and only 
        # include outliers if requested
        output$plot3 <- renderPlot({
                boxplot(as.formula(formulaText()), 
                        data = mtcars,
                        outline = input$outliers)
        })
        
        
        # Generate a summary of the data
        output$summary <- renderPrint({summary(mtcars)})
        output$structure <- renderPrint({str(mtcars)})
        
        # Generate an HTML table view of the data
        output$Table <- renderTable({
                mtcars$cartype <- row.names(mtcars)
                mtcars
        }, options = list(bFilter = FALSE, iDisplayLength=20))
        
})



