library(ggplot2)
library(wordcloud)
library(shiny)
require(tm)        
require(SnowballC)

barplt <- function(which_book,num_words,layout_selection) {
  if(which_book=="Harry_Potter1") {
    book_title <- "Harry Potter & the Philosopher's Stone"
  } 
  else if (which_book =="Harry_Potter2") {
    book_title <- "Harry Potter & the Chamber of Secrets"
  }
  else if (which_book == "Harry_Potter3") {
    book_title <- "Harry Potter & the Prisoner of Azkaban"
  }
  else if (which_book =="Harry_Potter4") {
    book_title <- "Harry Potter & the Goblet of Fire"
  }
  else if (which_book == "Harry_Potter5") {
    book_title <- "Harry Potter & the Order of the Phoenix"
  }
  else if (which_book == "Harry_Potter6") {
    book_title <- "Harry Potter & the Half Blood Prince"
  }
  else if (which_book == "Harry_Potter7") {
    book_title <- "Harry Potter & the Deathly Hallows"
  }
  if (layout_selection %in% c("Bar Plot","Word Cloud")) {
  book_source <- DirSource(
    # indicate directory
    directory = file.path("."),
    encoding = "UTF-8",     # encoding
    pattern = paste(which_book,".txt",sep=""),      # filename pattern
    recursive = FALSE,      # visit subdirectories?
    ignore.case = FALSE)    # ignore case in pattern?
  } else {
    book_source <- DirSource(
      # indicate directory
      directory = file.path("."),
      encoding = "UTF-8",     
      pattern = "*.txt",      
      recursive = FALSE,      
      ignore.case = FALSE)    
  }
#   book_source <- DirSource(
#       # indicate directory
#       directory = file.path("."),
#       encoding = "UTF-8",     # encoding
#       pattern = paste(which_book,".txt",sep=""),      # filename pattern
#       recursive = FALSE,      # visit subdirectories?
#       ignore.case = FALSE)

  book_corpus <- Corpus(
    book_source, 
    readerControl = list(
      reader = readPlain, # read as plain text
      language = "en"))
  
  book_corpus <- tm_map(book_corpus, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))
  book_corpus <- tm_map(book_corpus, tolower)
  
  book_corpus <- tm_map(
    book_corpus, 
    removePunctuation,
    preserve_intra_word_dashes = TRUE)
  
  book_corpus <- tm_map(
    book_corpus, 
    removeWords, 
    stopwords("english"))
  
#   book_corpus <- tm_map(
#     book_corpus, 
#     stemDocument,
#     lang = "porter") 
  
  book_corpus <- tm_map(
    book_corpus, 
    stripWhitespace)
  
  book_corpus <- tm_map(
    book_corpus, 
    removeWords, 
    c("will", "can", "get", "that", "year", "let","said",'all', 'just', 'being', 'over', 'both',
      'through', 'yourselves','its', 'before', 'herself', 'had', 'should', 'to', 'only', 'under',
      'ours', 'has', 'do', 'them', 'his', 'very', 'they', 'not', 'during', 'now', 'him', 'nor', 'did',
      'this', 'she', 'each', 'further', 'where', 'few', 'because', 'doing', 'some', 'are', 'our', 'ourselves',
      'out', 'what', 'for', 'while', 'does', 'above', 'between', 't', 'be', 'we', 'who', 'were', 'here', 'hers',
      'by', 'on', 'about', 'of', 'against', 's', 'or', 'own', 'into', 'yourself', 'down', 'your', 'from', 'her',
      'their', 'there', 'been', 'whom', 'too', 'themselves', 'was', 'until', 'more', 'himself', 'that', 'but',
      'don', 'with', 'than', 'those', 'he', 'me', 'myself', 'these', 'up', 'will', 'below', 'can', 'theirs',
      'my', 'and', 'then', 'is', 'am', 'it', 'an', 'as', 'itself', 'at', 'have', 'in', 'any', 'if', 'again',
      'no', 'when', 'same', 'how', 'other', 'which', 'you', 'after', 'most', 'such', 'why', 'a', 'off', 'i',
      'yours', 'so', 'the', 'having', 'once','back','around','looked','got','hed','like','didnt','ing','hadnt',
      'weve','theyre','theres','youre','wasnt','couldnt','ive','youve','yet','cant','say','want','went','hes',
      'dont','many','whats','done','havent','ill','well','wouldnt','came','chapter','harrys','youd','one','two',
      'going','upon','come','much','way','even','knew','unbridges','yeah'))
  
  book_tdm <- TermDocumentMatrix(book_corpus)
  
  book_matrix <- as.matrix(book_tdm)
  if (layout_selection =="Comparison Cloud") {
  colnames(book_matrix) <- c("Philosopher's Stone","Chamber of Secrets","Prisoner of Azkaban",
                           "Goblet of Fire","Order of the Phoenix","Half Blood Prince",
                           "Deathly Hallows")
  } else {
  book_df <- data.frame(
    word = rownames(book_matrix), 
    # necessary to call rowSums if have more than 1 document
    freq = rowSums(book_matrix),
    stringsAsFactors = FALSE) 
  
  book_df <- book_df[with(
    book_df, 
    order(freq, decreasing = TRUE)), ]
  
  rownames(book_df) <- NULL
  
    
  bar_df <- head(book_df, num_words)
  bar_df$word <- factor(bar_df$word, 
                        levels = bar_df$word, 
                        ordered = TRUE)
   }
  
  if (layout_selection=="Comparison Cloud") {
  cc <- comparison.cloud(book_matrix,
                         scale=c(3,0.7),
                         max.words=300,
                         title.size=1)
  } else {
  p <- ggplot(bar_df, aes(x = word, y = freq)) +
     geom_bar(stat = "identity", fill = "grey60") +
     ggtitle(book_title) +
     xlab(paste("Top", num_words,"Word Stems (Stop Words Removed)")) +
     ylab("Frequency") +
     theme_minimal() +
     scale_x_discrete(expand = c(0, 0)) +
     scale_y_continuous(expand = c(0, 0)) +
     theme(panel.grid = element_blank()) +
     theme(axis.ticks = element_blank()) +
     theme(axis.text.x = element_text(angle = 45, hjust = 0.85,size=12))

  w <-wordcloud(
      book_df$word,
      book_df$freq,
      scale = c(4,1),
      #max.words=200,
      max.words=num_words*5,
      random.order=FALSE,
      colors = gray(seq(0.75,0.1,by=-0.01))
      #colors="black"
      #colors = brewer.pal(8, "Dark2")
      )
  }

  if (layout_selection=="Bar Plot") {
    return(p)
  }   else if (layout_selection=="Word Cloud"){
    return(w)
  } else {
    return(cc)
  } 

  
}

#### SHINY SERVER ####

shinyServer(function(input, output) {
  cat("Press \'ESC\' to exit…\n")
  output$visuals <- renderPlot(
  {
  bar <- barplt(input$whichbk,input$numWords,input$layout)
  print(bar)
  }
                              )
                                      }
            )
