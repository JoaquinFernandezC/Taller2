# First run, uncomment all install.packages, select them all and execute them

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

head(data_set)

#Create sub-dataset for better testing

sub_data_set <- subset(data_set, business_id == "iCQpiavjjPzJ5_3gPD5Ebg")

# Load text to Corpus

docs <- Corpus(VectorSource(data_set$text))
sub_docs <- Corpus(VectorSource(sub_data_set$text))

inspect(sub_docs)

# Clean special characters(punctiation, extra space, numbers, etc.)

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, stripWhitespace)

# sub_docs

sub_docs <- tm_map(sub_docs, removePunctuation)
sub_docs <- tm_map(sub_docs, removeNumbers)
sub_docs <- tm_map(sub_docs, removeWords, stopwords("english"))
sub_docs <- tm_map(sub_docs, toSpace, "/")
sub_docs <- tm_map(sub_docs, toSpace, "@")
sub_docs <- tm_map(sub_docs, toSpace, "-")
sub_docs <- tm_map(sub_docs, stripWhitespace)

inspect(sub_docs)


