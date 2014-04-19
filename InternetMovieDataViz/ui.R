library(shiny)

shinyUI(
  pageWithSidebar(
      headerPanel("IMDB Movie Ratings"),
      sidebarPanel(
        radioButtons("mpaaRating","MPAA Rating:",choices=c("All","NC-17","PG","PG-13","R")),
                   
        checkboxGroupInput("movieGenres","Movie Genres:",choices=c("Action","Animation","Comedy",
                                                                               "Drama","Documentary","Romance",
                                                                               "Short")),
        selectInput("colorScheme","Color Scheme:",choices=c("Default",
                                                            "Accent",
                                                            "Set1",
                                                            "Set2",
                                                            "Set3",
                                                            "Dark2",
                                                            "Pastel1",
                                                            "Pastel2")),
        sliderInput("dotAlpha","Dot Alpha:",min=0.01,max=1,value=1,step=0.01),
        sliderInput("dotSize","Dot Size:",min=1,max=10,value=2,step=1)
      ),
        mainPanel(tabsetPanel(tabPanel("Scatter Plot",plotOutput("scatterplot",width=600,height=500)),
                              tabPanel("Aggregated Point Chart",plotOutput("line",width=600,height=500)),
                              tabPanel("Ratings by Genre", tableOutput("table2")),
                              tabPanel("Decadely Average Stats", tableOutput("table1"))
        )
  )  
)
)

