library(ggplot2)
library(shiny)
library(scales)
library(maps)
library(Hmisc)
library(stringi)
library(plyr)
library(GGally)
library(stringr)

states <- map_data("state")
colnames(states)[5] <- "State"
states$State <- stri_trans_totitle(states$State)

loadData <- function() {
  df <- data.frame(state.x77,
                   State = state.name,
                   Abbrev = state.abb,
                   Region = state.region,
                   Division = state.division
  )
  df$Density <- (df$Population*1000)/df$Area
  colnames(df) <- c("Population (in Millions)", "Per Capita Income (in $1000s)", "Illiteracy %",
                    "Life Expectancy (in years)","Murders (per 100,000)","High School Graduates %","Frost (in days)",
                    "Area (in square miles)","State","Abbrev","Region","Division","Density (persons per square mile)")
#   df3 <- data.frame(Group=rep(1:9,each=50),
#                     State=rep(df$State,9),
#                     Variables=c(rep("Population",50),
#                                 rep("Income",50),
#                                 rep("Illiteracy",50),
#                                 rep("LifeExpectancy",50),
#                                 rep("Murder",50),
#                                 rep("HighSchoolGraduates",50),
#                                 rep("Frost",50),
#                                 rep("Area",50),
#                                 rep("Density",50)
#                     ),
#                     Values=c(df$Population,
#                            df$Income,
#                            df$Illiteracy,
#                            df$LifeExpectancy,
#                            df$Murder,
#                            df$HighSchoolGraduates,
#                            df$Frost,
#                            df$Area,
#                            df$Density),
#                     Region=rep(df$Region,9) 
#   )
#   df3$Variables <- as.character(df3$Variables)
  return(df)
}

globalData <- loadData()

bubblePlot <- function(localFrame,
                       Xs,
                       Ys,
                       bize,
                       clr,
                       region) {
  big_dataset <- globalData
  if (length(region) %in% c(1:4)) {
    localFrame <- subset(localFrame, localFrame$Region %in% region)
  } else {
    localFrame <- localFrame
  }
  localFrame$Xs <- localFrame[,Xs]
  localFrame$Ys <- localFrame[,Ys]
  localFrame$bize <- localFrame[,bize]
  localFrame$clr <- localFrame[,clr]
  p <- ggplot(localFrame,aes(x=Xs,
                             y=Ys,
                             #size=bize,
                             color=clr,
                             label=factor(Abbrev))
              ) + 
    #geom_point(alpha=I(0.66),aes(show_guide=F)) + 
    geom_text(aes(size = bize),alpha=I(0.66)) +
    xlab(Xs) + ylab(Ys) + 
    #scale_size_continuous(limits=c(2,20),breaks=c(min(big_dataset$clr),10,20,max(big_datase)))
    scale_size(range=c(nrow(big_dataset)*0.1,nrow(big_dataset)*0.4)) + 
    scale_y_continuous(limits=c(min(big_dataset[,Ys]),
                                max(big_dataset[,Ys])
                                ),
                       breaks=round(as.numeric(quantile(big_dataset[,Ys],probs=seq(0,1,0.25))),1)
                       ) +
    scale_x_continuous(limits=c(min(big_dataset[,Xs]),
                                max(big_dataset[,Xs])
                                ),
                       breaks=round(as.numeric(quantile(big_dataset[,Xs],probs=seq(0,1,0.25))),1)
                       ) +
    scale_color_gradient(limits=c(min(big_dataset[,clr]),
                                  max(big_dataset[,clr]))
                                  ) + 
    labs(title=(paste(str_trim(str_extract(Xs,"[A-z ]+")),"VS",str_trim(str_extract(Ys,"[A-z ]+")))),
         color=clr,
         size=bize) + 
    theme(panel.background = element_rect(fill = NA, 
                                          color="black")) +
    #theme(panel.border = element_rect(color="black")) +
    theme(axis.text.x = element_text(size = 12,
                                     color="black")) +
    theme(axis.text.y = element_text(size = 12,
                                     color="black")) +
    theme(legend.key = element_rect(fill=NA)) +
    theme(panel.grid.major.x=element_line(colour="grey50", linetype="dashed",size=0.3)) + 
    theme(panel.grid.major.y=element_line(colour="grey50", linetype="dashed",size=0.3)) +
    
    guides(size = FALSE) +
    theme(legend.position="bottom")
   # palette <- brewer_pal(type = "qual", palette = "Set1")(4)
  #rejs <- levels(localFrame$Region)
  #palette[which(!rejs %in% region)] <- "#EEEEEE"
  #p <- p + scale_color_manual(values = palette)
  return(p)
}

smallMultiples <- function(localFrame,
                           Xs,
                           Ys,
                           bize,
                           clr,
                           region) {
  big_dataset <- globalData
  if (length(region) %in% c(1:4)) {
    localFrame <- subset(localFrame, localFrame$Region %in% region)
  } else {
    localFrame <- localFrame
  }
  localFrame$Xs <- localFrame[,Xs]
  localFrame$Ys <- localFrame[,Ys]
  localFrame$bize <- localFrame[,bize]
  localFrame$clr <- localFrame[,clr]
  
  q <- ggplot(localFrame,aes(x=Xs,
                             y=Ys,
                             size=bize,
                             color=clr,
                             label=factor(Abbrev))
              ) + #geom_point(alpha=I(0.76)) +
    geom_text(aes(size = bize),alpha=I(0.76)) +
    xlab(Xs) + ylab(Ys) + facet_wrap(~Region) +
    scale_y_continuous(limits=c(min(big_dataset[,Ys]),
                                max(big_dataset[,Ys])
                                ),
                        breaks=round(as.numeric(quantile(big_dataset[,Ys],probs=seq(0,1,0.3))),1)
                        ) +
    scale_x_continuous(limits=c(min(big_dataset[,Xs]),
                                max(big_dataset[,Xs])
                                ),
                        breaks=round(as.numeric(quantile(big_dataset[,Xs],probs=seq(0,1,0.3))),1)
                        ) +
    #scale_size_area(max_size=nrow(big_dataset)*0.4) +
    scale_size(range=c(nrow(big_dataset)*0.1,nrow(big_dataset)*0.4)) + 
    theme(legend.position="bottom") + 
    scale_color_gradient(limits=c(min(big_dataset[,clr]),max(big_dataset[,clr]))) +
#     scale_color_gradient(name=clr,limits=c(min(big_dataset[,clr]),max(big_dataset[,clr])),
#                          guide = guide_legend(#title.position = "top",label.position = "bottom",
#                                               title.theme = element_text(size=15, face="italic",angle=0)
#                                               #keywidth = 2)
#                          )
#     ) + 
#     scale_fill_continuous(name=clr,limits=c(min(big_dataset[,clr]),max(big_dataset[,clr])),
#                           guide = guide_legend(title.position = "top",label.position = "bottom",
#                                                title.theme = element_text(size=15, face="italic",angle=0),
#                                                keywidth = 2)
#                           ) +
    labs(title=(paste(str_trim(str_extract(Xs,"[A-z ]+")),"VS",str_trim(str_extract(Ys,"[A-z ]+")))),
         color=clr,
         size=bize) +
    theme(legend.key = element_rect(fill=NA)) +
    theme(panel.background = element_rect(fill = NA, 
                                          color="black")) +
    theme(axis.text.x = element_text(size = 11,
                                     color="black")) +
    theme(axis.text.y = element_text(size = 11,
                                     color="black")) +
    theme(panel.grid.major.x=element_line(colour="grey76", size=0.4,linetype="dashed")) +
    guides(size = FALSE)
  return(q)  
}

mapGraph <- function(localFrame,
                     Cols,
                     region) {
  df5 <- merge(states,localFrame,by="State")
  df5 <- df5[order(df5$order),]
  
  mid_range <- function(x) mean(range(x,na.rm=TRUE))
  
  centress <- ddply(df5, .(Abbrev),
                   colwise(mid_range,.(lat,long)))
  
  centress2 <- merge(centress,localFrame,by="Abbrev")
  big_dataset <- globalData
  if (length(region) %in% c(1:4)) {
    df6 <- subset(df5, df5$Region %in% region)
    centress2 <- subset(centress2, centress2$Region %in% region)
  } else {
    df6 <- df5
    centress2 <- centress2
  }
  df6$Cols <- df6[,Cols]
  r <- ggplot() +
    geom_polygon(data=df6,aes(long,lat,fill=Cols,group=group)) +
    geom_text(data=centress2,aes(x=long,y=lat,label=Abbrev),color="black",size=4) + 
    scale_fill_continuous(low="sienna1",high="sienna4",name=Cols,
                          limits=c(min(big_dataset[,Cols]),max(big_dataset[,Cols])),
                          guide = guide_legend(title.position = "top",label.position = "bottom",
                                               title.theme = element_text(size=15, face="italic",angle=0),,
                                                                          keywidth = 2)
                          ) + 
    #scale_color_gradient(limits=c(min(big_dataset[,Cols]),max(big_dataset[,Cols]))) +
    theme(panel.background=element_rect(fill="white")) +
    theme(panel.grid.major = element_blank()) + 
    theme(panel.grid.minor = element_blank()) +
    theme(axis.text.x=element_blank()) +
    theme(axis.text.y=element_blank()) +
    theme(axis.ticks.x=element_blank()) +
    theme(axis.ticks.y=element_blank()) +
    theme(axis.title.x=element_blank()) +
    theme(axis.title.y=element_blank()) +
    #theme(legend.title=ele) + 
    labs(color=paste(Cols))+ #coord_map() +
    theme(legend.justification=c(0,0), legend.position=c(0,0),legend.direction="horizontal")
    #scale_x_continuous(limits=c(min(df5$long),max(df5$long))) +
    #scale_y_continuous(limits=c(min(df5$lat),max(df5$lat)))
  return(r)
}

parkour <- function(localFrame,vari,region) {
  namedf <- data.frame(Varnames=colnames(localFrame),
                       Varindeces=as.numeric(sapply(colnames(localFrame),function(x) which(colnames(globalData)==x))
                       )
  )
  if (length(vari) %in% c(1:9)) {
    varinum <- subset(namedf$Varindeces,namedf$Varnames %in% vari)
  } else {
    varinum <- namedf$Varindeces[1:9]
  }
  if (length(region) %in% c(1:4)) {
    localFrame <- subset(localFrame, localFrame$Region %in% region)
  } else {
    localFrame <- localFrame
  }
  colnames(localFrame) <- str_trim(str_extract(colnames(localFrame),"[A-z ]+"))
  s <- ggparcoord(localFrame,varinum,groupColumn=11) +
    theme(legend.key = element_rect(fill=NA)) +
    theme(panel.background = element_rect(fill = NA, 
                                          color="black")) +
    theme(panel.grid.major.x=element_line(colour="grey70", size=0.5,linetype="dashed")) +
    theme(axis.text.x = element_text(size = 12,
                                     color="black")) +
    theme(axis.text.y = element_text(size = 12,
                                     color="black")) 
    
  print(s)
}

#### SHINY SERVER ####

shinyServer(function(input, output) {
  cat("Press \'ESC\' to exit…\n")
  
  localFrame <- globalData
  
  output$bubbleplot <- renderPlot(
  {
  bp <- bubblePlot(localFrame,
                   input$XAxis,
                   input$YAxis,
                   input$volumes,
                   input$Color,
                   input$region)
  print(bp)
  }
    )
 output$smallmultiples <- renderPlot(
  {
    sm <- smallMultiples(localFrame,
                         input$XAxis2,
                         input$YAxis2,
                         input$volumes2,
                         input$Color2,
                         input$region2)
    print(sm)
  } 
   )
 output$mapgraph <- renderPlot(
  {
    mc <- mapGraph(localFrame,
                   input$Color3,
                   input$region3)
    print(mc)
  }
   )
 output$pcgraph <- renderPlot(
  {
    pc <- parkour(localFrame,
                  input$variab,
                  input$regionpc) 
    print(pc)
  } 
  )
  
}
)

