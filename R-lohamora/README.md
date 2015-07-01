Text Visualization of Harry Potter Series
=========================================

| **Name**  | Anuj Saxena  |
|----------:|:-------------|
| **Email** | anujsaxenaa@gmail.com |

Live Version:- https://anujsaxenaa.shinyapps.io/R-lohamora

## Instructions ##

Please install the following packages:
```
library(ggplot2)
library(wordcloud)
library(shiny)
require(tm)        
require(SnowballC)
library(grDevices)
```
Run the following:
```
shiny::runGitHub('ShinyApplications', 'anujsaxenaa', subdir='R-lohamora')
```
## Discussion ##
![IMAGE](bar_plot.png)
To check for the most occuring words in each book. The word-slider lets you browse through up to 60 words.
![IMAGE](word_cloud.png)
In the wordcloud, the size of the word represents the frequency. The color helps us segment this more visibly.
![IMAGE](comparison_cloud.png)
Comparision cloud lets us compare the frequency of occurrences across all the Harry Potter books. They may take a while to appear so kindly be patient.
