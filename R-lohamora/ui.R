library(shiny)

shinyUI(fluidPage(
  
  title = "Text Visualization",
  plotOutput('visuals'),
  hr(),
  
  fluidRow(
    column(2,offset=1,
           radioButtons("layout","Select layout:",choices=c("Bar Plot",
                                                            "Word Cloud","Comparison Cloud"))
    ),
    column(4,offset=1,
           h4("Word Explorer",align="center"),
           selectInput("whichbk","Select Book",
                       choices=c("Harry Potter & the Philosopher's Stone"="Harry_Potter1",
                                 "Harry Potter & the Chamber of Secrets"="Harry_Potter2",
                                 "Harry Potter & the Prisoner of Azkaban"="Harry_Potter3",
                                 "Harry Potter & the Goblet of Fire"="Harry_Potter4",
                                 "Harry Potter & the Order of the Phoenix"="Harry_Potter5",
                                 "Harry Potter & the Half Blood Prince"="Harry_Potter6",
                                 "Harry Potter & the Deathly Hallows"="Harry_Potter7")
           ),
          # br(),
           sliderInput('numWords', 'Select number of Words (5x for Word Cloud)', 
                       min=10, max=60, value=min(10, 30), 
                       step=1, round=0)
    )
  )
)
)