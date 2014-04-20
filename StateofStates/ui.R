shinyUI(
  pageWithSidebar(
      titlePanel("U.S. States 1970s Statistics"),
      sidebarPanel(width=3,
        conditionalPanel(condition="input.plotType=='Bubble Text'",
        radioButtons("volumes","Size Bubble by:",choices=c("Area"="Area (in square miles)",
                                                           "Population"="Population (in Millions)",
                                                           "Density"="Density (persons per square mile)")
                     ),
        selectInput("XAxis","On X-Axis:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                   "Illiteracy"="Illiteracy %",
                                                   "Life Expectancy"="Life Expectancy (in years)",
                                                   "Murder"="Murders (per 100,000)",
                                                   "High School Graduates"="High School Graduates %",
                                                   "Frost"="Frost (in days)"),
                    selected="Life Expectancy (in years)"
                    ),
        selectInput("YAxis","On Y-Axis:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                   "Illiteracy"="Illiteracy %",
                                                   "Life Expectancy"="Life Expectancy (in years)",
                                                   "Murder"="Murders (per 100,000)",
                                                   "High School Graduates"="High School Graduates %",
                                                   "Frost"="Frost (in days)"),
                    selected="Illiteracy %"
                    ),
        selectInput("Color","Color By:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                  "Illiteracy"="Illiteracy %",
                                                  "Life Expectancy"="Life Expectancy (in years)",
                                                  "Murder"="Murders (per 100,000)",
                                                  "High School Graduates"="High School Graduates %",
                                                  "Frost"="Frost (in days)"),
                    selected="High School Graduates %"
                    ),
        checkboxGroupInput("region","Region:",choices=c("South",
                                                        "West",
                                                        "Northeast",
                                                        "North Central")
                           )
        ),
        conditionalPanel(condition="input.plotType=='Small Multiples'",
        radioButtons("volumes2","Size Bubble by:",choices=c("Area"="Area (in square miles)",
                                                                            "Population"="Population (in Millions)",
                                                                            "Density"="Density (persons per square mile)")
                         ),
        selectInput("XAxis2","On X-Axis:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                                    "Illiteracy"="Illiteracy %",
                                                                    "Life Expectancy"="Life Expectancy (in years)",
                                                                    "Murder"="Murders (per 100,000)",
                                                                    "High School Graduates"="High School Graduates %",
                                                                    "Frost"="Frost (in days)"),
                                     selected="Life Expectancy (in years)"
                         ),
        selectInput("YAxis2","On Y-Axis:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                                    "Illiteracy"="Illiteracy %",
                                                                    "Life Expectancy"="Life Expectancy (in years)",
                                                                    "Murder"="Murders (per 100,000)",
                                                                    "High School Graduates"="High School Graduates %",
                                                                    "Frost"="Frost (in days)"),
                                     selected="Illiteracy %"
                         ),
        selectInput("Color2","Color By:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                                   "Illiteracy"="Illiteracy %",
                                                                   "Life Expectancy"="Life Expectancy (in years)",
                                                                   "Murder"="Murders (per 100,000)",
                                                                   "High School Graduates"="High School Graduates %",
                                                                   "Frost"="Frost (in days)"),
                                     selected="High School Graduates %"
                         ),
        checkboxGroupInput("region2","Region:",choices=c("South",
                                                                         "West",
                                                                         "Northeast",
                                                                         "North Central")
                         )
        ),
        conditionalPanel(condition="input.plotType=='Geospatial Mapping'",
        selectInput("Color3","Color By:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                                  "Illiteracy"="Illiteracy %",
                                                                  "Life Expectancy"="Life Expectancy (in years)",
                                                                  "Murder"="Murders (per 100,000)",
                                                                  "High School Graduates"="High School Graduates %",
                                                                  "Frost"="Frost (in days)"),
                                   selected="High School Graduates %"
                                  ),
        checkboxGroupInput("region3","Region:",choices=c("South",
                                                         "West",
                                                         "Northeast",
                                                         "North Central")
                                          )
                      ),
      # Condition for Parallel Coordinates Plot
      conditionalPanel(condition="input.plotType=='Parallel Coordinates'",
      checkboxGroupInput("variab","Choose Variables:",choices=c("Income"="Per Capita Income (in $1000s)",
                                                                "Illiteracy"="Illiteracy %",
                                                                "Life Expectancy"="Life Expectancy (in years)",
                                                                "Murder"="Murders (per 100,000)",
                                                                "High School Graduates"="High School Graduates %",
                                                                "Frost"="Frost (in days)",
                                                                "Area"="Area (in square miles)",
                                                                "Population"="Population (in Millions)",
                                                                "Density"="Density (persons per square mile)")
                                          ),
      checkboxGroupInput("regionpc","Region:",choices=c("South",
                                                        "West",
                                                        "Northeast",
                                                        "North Central")
                       )
                       )    
      ),
      mainPanel(
          tabsetPanel(
              tabPanel("Bubble Text",plotOutput("bubbleplot",height=480)),
              tabPanel("Small Multiples",plotOutput("smallmultiples",height=480)),
              tabPanel("Parallel Coordinates",plotOutput("pcgraph"),
                       helpText("Select atleast two variables")),
              tabPanel("Geospatial Mapping",plotOutput("mapgraph",height=480)),
              id="plotType"
              ),width=9
      )
      
    )
  )
