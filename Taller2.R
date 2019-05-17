#Group Members: Sebastian Baixas, Joaquin Fernandez


# First run, uncomment all install.packages, select them all and execute them

# install.packages("tm")
# install.packages("SnowballC")
# install.packages("wordcloud")
# install.packages("RColorBrewer")
# install.packages("quantreg",dependencies=TRUE)

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(quantreg)

# Read csv file

data_set <- read.csv("yelp_reviews_big.csv", header = FALSE)

# Define headers

names(data_set) <- c("review_id", "user_id", "business_id", "stars",
                     "text", "useful", "funny", "cool")

head(data_set)

#Create sub-dataset for better testing
data_set$sum_data <- data_set$useful + data_set$funny + data_set$cool
data_set <- subset(data_set, sum_data < 500)

sub_data_set <- subset(data_set, business_id == "iCQpiavjjPzJ5_3gPD5Ebg")
filtered_sub_set <- subset(data_set, useful >= 1)
filtered_sub_set <- subset(data_set, funny >= 1)
filtered_sub_set <- subset(data_set, cool >= 1)






filtered_sub_set$sum_data <- filtered_sub_set$useful + filtered_sub_set$funny + filtered_sub_set$cool


filtered_graph_data <- data.frame(score=filtered_sub_set$sum_data)
ggplot(filtered_graph_data, aes(score)) + geom_density(kernel = "gaussian")


filtered_graph_data <- data.frame(useful=filtered_sub_set$useful, score=filtered_sub_set$sum_data)
ggplot(filtered_graph_data, aes(useful, score)) + geom_point() + geom_quantile()

filtered_graph_data <- data.frame(stars=filtered_sub_set$stars, score=filtered_sub_set$sum_data)
filtered_graph_data$stars <- as.factor(filtered_graph_data$stars)
ggplot(filtered_graph_data, aes(x=stars, y = score)) + geom_boxplot()

filtered_graph_data <- data.frame(stars=filtered_sub_set$stars, score=filtered_sub_set$sum_data)
ggplot(filtered_graph_data, aes(stars, score)) + geom_bar(stat = "identity")


# Load text to Corpus

docs <- Corpus(VectorSource(data_set$text))
sub_docs <- Corpus(VectorSource(sub_data_set$text))
filtered_docs <- Corpus(VectorSource(filtered_sub_set$text))


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

# useful_docs

filtered_docs <- tm_map(filtered_docs, removePunctuation)
filtered_docs <- tm_map(filtered_docs, removeNumbers)
filtered_docs <- tm_map(filtered_docs, removeWords, stopwords("english"))
filtered_docs <- tm_map(filtered_docs, toSpace, "/")
filtered_docs <- tm_map(filtered_docs, toSpace, "@")
filtered_docs <- tm_map(filtered_docs, toSpace, "-")
filtered_docs <- tm_map(filtered_docs, stripWhitespace)




# Word matrix

sub_dtm <- TermDocumentMatrix(sub_docs)
sub_m <- as.matrix(sub_dtm)
sub_v <- sort(rowSums(sub_m), decreasing = TRUE)
sub_d <- data.frame(word = names(sub_v), freq=sub_v)

head(sub_d, 10)


# Word cloud

set.seed(1234)
wordcloud(words = sub_d$word, freq = sub_d$freq, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35,
          colors=brewer.pal(8, "Dark2"))

# Word matrix

filtered_dtm <- TermDocumentMatrix(filtered_docs)
filtered_m <- as.matrix(filtered_dtm)
filtered_v <- sort(rowSums(filtered_m), decreasing = TRUE)
filtered_d <- data.frame(word = names(filtered_v), freq=filtered_v)

head(filtered_d, 10)

# Word cloud

set.seed(1234)
wordcloud(words = filtered_d$word, freq = filtered_d$freq, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35,
          colors=brewer.pal(8, "Dark2"))


