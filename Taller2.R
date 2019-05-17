#First run, uncomment all install.packages, select them all and execute them

# install.packages("tm")
# install.packages("SnowballC")
# install.packages("wordcloud")
# install.packages("RColorBrewer")

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

# Read csv file

data_set <- read.csv("yelp_reviews_big.csv", header = FALSE)

# Define headers

names(data_set) <- c("review_id", "user_id", "business_id", "stars",
                     "text", "useful", "funny", "cool")

