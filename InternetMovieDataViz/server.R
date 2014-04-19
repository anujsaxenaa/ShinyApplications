library(ggplot2)
library(shiny)
library(scales)

loadData <- function() {
  data("movies", package = "ggplot2")
  
  rem1 <- which(is.na(movies$budget))
  rem2 <- which(movies$budget <= 0)
  rem3 <- which(movies$mpaa=="")
  rem_all <- unique(c(rem1, rem2, rem3))
  movies <- movies[-rem_all,]
  droplevels(movies)
  genre <- rep(NA, nrow(movies))
  count <- rowSums(movies[, 18:24])
  genre[which(count > 1)] = "Mixed"
  genre[which(count < 1)] = "None"
  genre[which(count == 1 & movies$Action == 1)] = "Action"
  genre[which(count == 1 & movies$Animation == 1)] = "Animation"
  genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
  genre[which(count == 1 & movies$Drama == 1)] = "Drama"
  genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
  genre[which(count == 1 & movies$Romance == 1)] = "Romance"
  genre[which(count == 1 & movies$Short == 1)] = "Short"
  movies$budget <- movies$budget/1000000
  movies$genre <- as.factor(genre)
  movies$decade[movies$year <=1949] <- "1940s"
  movies$decade[movies$year>=1950 & movies$year <=1959] <- "1950s"
  movies$decade[movies$year>=1960 & movies$year <=1969] <- "1960s"
  movies$decade[movies$year>=1970 & movies$year <=1979] <- "1970s"
  movies$decade[movies$year>=1980 & movies$year <=1989] <- "1980s"
  movies$decade[movies$year>=1990 & movies$year <=1999] <- "1990s"
  movies$decade[movies$year>=2000] <- "2000-2005"
  return(movies)
}
globalData <- loadData()

getPlot <- function(localFrame,dotSize,dotAlpha,colorScheme,Genre,Rating) {
  
  if (length(Genre) %in% c(1:7)) {
    localFrame <- subset(localFrame, localFrame$genre %in% Genre)
  } else {
    localFrame <- localFrame
  }
  
  if (Rating =="PG") {
    localFrame <- subset(localFrame, localFrame$mpaa %in% Rating)
  } 
  else if (Rating =="PG-13") {
    localFrame <- subset(localFrame, localFrame$mpaa %in% Rating)
  }
  else if (Rating == "R") {
    localFrame <- subset(localFrame, localFrame$mpaa %in% Rating)
  }
  else if (Rating == "NC-17") {
    localFrame <- subset(localFrame, localFrame$mpaa %in% Rating)
  } else {
    localFrame <- localFrame
  }
  
  p <- ggplot(localFrame, aes(x=budget,y=rating,color=mpaa))
  p <- p + geom_point(size=dotSize,alpha=dotAlpha)
  p <- p + labs(title="Movie Budget and Rating comparision",
                color="MPAA Rating",
                x="Budget (in Millions)",
                y="IMDB Rating")
  #p <- p + scale_x_continuous(expand=c(0,200),
  #                            label=million_formatter)
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + theme(axis.text.x = element_text(size = 12,color="black"))
  p <- p + theme(axis.text.y = element_text(size = 12,color="black"))
  p <- p + theme(panel.border = element_blank())
  p <- p + theme(legend.direction = "horizontal")
  p <- p + theme(legend.justification = c(0, 0))
  p <- p + theme(legend.position = c(0, 0))
  p <- p + theme(legend.background = element_blank())
  
  p <- p + xlim(0,200) + ylim(0,10)
  if (colorScheme == "Default") {
    p <- p +
      scale_color_brewer(type = "qual", palette = 2)
  }
  else if (colorScheme == "Accent") {
    p <- p +
      scale_color_brewer(type = "qual", palette = "Accent")
  }
  else if (colorScheme == "Set1") {
    p <- p +
      scale_color_brewer(type = "qual", palette = "Set1")
  }
  else if (colorScheme == "Set2") {
    p <- p +
      scale_color_brewer(type = "qual", palette = "Set2")
  }
  else if (colorScheme == "Set3") {
    p <- p +
      scale_color_brewer(type = "qual", palette = "Set3")
  }
  else if (colorScheme == "Dark2") {
    p <- p +
      scale_color_brewer(type = "qual", palette = "Dark2")
  }
  else if (colorScheme == "Pastel1") {
    p <- p +
      scale_color_brewer(type = "qual", palette = "Pastel1")
  }
  else if (colorScheme == "Pastel2") {
    p <- p +
      scale_color_brewer(type = "qual", palette = "Pastel2")
  }
  else {
    p <- p +
      scale_color_grey(start = 0.4, end = 0.4)
  }
  #p <- p + scale_color_brewer(type="qual",palette=3)
  return(p)
}

agg_by_year <- function() {
  ay <- data.frame(aggregate(globalData[,c(3,4,5,6)],by=list(globalData$decade),FUN=mean))
  colnames(ay) <- c("Decade of Release","Avg Movie Length (mins)", "Avg Budget (in Millions)",
                    "Average Rating", "Average Votes")
  return(ay)
} 

agg_by_genre <- function() {
  ag <- data.frame(aggregate(globalData$rating,by=list(globalData$genre),FUN=mean))
  colnames(ag) <- c("Genre of Movie", "Average Rating")
  return(ag)
}

agg_by_length <- function() {
  al <- data.frame(aggregate(globalData$rating,by=list(globalData$length),FUN=mean))
  #colnames(al) <- c("Movie Length", "Average Rating")
  pal <- qplot(Group.1,x,data=al,geom="point")+
    theme(panel.background = element_rect(fill='oldlace',color="white"))+
    theme(axis.text.x = element_text(size = 12,color="black"))+
    theme(axis.text.y = element_text(size = 12,color="black"))+
    labs(title="Movie Length and Rating comparision",
         x="Movie Length (in Minutes)",
         y="IMDB Rating")
  return(pal)
}
#### SHINY SERVER ####

shinyServer(function(input, output) {
  cat("Press \'ESC\' to exit…\n")

  localFrame <- globalData
  
  output$scatterplot <- renderPlot(
    { 
      scatterplot <- getPlot(localFrame,
                             input$dotSize,
                             input$dotAlpha,
                             input$colorScheme,
                             input$movieGenres,
                             input$mpaaRating)
      print(scatterplot)
      } 
  )
  output$line <- renderPlot(
    {
      print(agg_by_length())
    }
  )
  output$table1 <- renderTable(
{
  return(agg_by_year())
}
    )
output$table2 <- renderTable(
{
  return(agg_by_genre())
}
)


})
































