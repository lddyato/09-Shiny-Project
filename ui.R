

if(!("shiny" %in% rownames(installed.packages()))) {
        install.packages("shiny")
}

library(shiny)


shinyUI(
        navbarPage("Mtcars Data Exploration",
                   tabPanel("Data",
                   sidebarLayout(
                          sidebarPanel(
                                  sliderInput("sliderwt", "What is the weight of the car?", value = 3.2, min=1, max =6, step=0.01),
                                  sliderInput("bins", "Number of bins",min=1, max=50, value=12),
                                  selectInput("variable", "Variable:", list("Cylinders" = "cyl",
                                                                            "Transmission" = "am",
                                                                            "Gears" = "gear")),
                                  checkboxInput("outliers", "Show Outliers", FALSE),
                                  checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
                                  submitButton("Submit")
                          ),
                          
                          
                          
                          mainPanel(
                                    tabsetPanel(type = "tabs",
                                    tabPanel("Scatter", plotOutput("plot1"),
                                             h3("Predicted Horsepower from Model 1:"),
                                             textOutput("pred1")), 
                                    tabPanel("Histogram", plotOutput("plot2")),
                                    tabPanel("Boxplot", h3(textOutput("caption")), plotOutput("plot3")),
                                    tabPanel("Summary", h3(textOutput("Summary of the Data")), verbatimTextOutput("summary"), 
                                             verbatimTextOutput("structure")),
                                    tabPanel(p(icon("table"), "Data"), tableOutput("Table")
                                    )
                          )
                  )
                  )
                  ),
                  
                  tabPanel(p(icon("info"), "About"),
                           mainPanel(
                                   includeMarkdown("About.Rmd")
                           )
                  )
        )
)
  