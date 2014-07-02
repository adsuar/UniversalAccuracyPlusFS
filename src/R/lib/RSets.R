# Library that contains functions needed to manage sets of data.

# Function that merges two data structures in a single one.
# The arguments are:
# - dat1: first data structure.
# - dat1Link: name of the column of the first structure that'll help us to 
#             merge both structures. 
# - dat2: second data structure.
# - dat1Link: name of the column of the second structure that'll help us to 
#             merge both structures. 
mergeData <- function(dat1, dat1Link, dat2, dat2Link) {
   # Merging of both data sets in one single file taking as a common point the columns Number and Sample.
   dataMerged <- merge(x=dat1,y=dat2,by.x=dat1Link,by.y=dat2Link)
   
   return (dataMerged)
}

# Function that creates the index for training and test structures.
# The arguments are:
# - data: data structure to be analyzed.
# - trainPerc: percentage of the training set.
getTrainIndex <- function(data,trainPerc) {
   # The following data code will get the size of the training data set.
   n <- dim(data)[1]
   train.size <- round(trainPerc*n)
   
   # We define the rows that belong to the training data set.
   train_index <- sample(seq_len(nrow(data)), size = train.size)
   
   return (train_index);
}

# Function that creates the training set.
# The arguments are:
# - data: data structure to be analyzed.
# - trainIndex: indexes to create the training set.
getTrainingSet <- function(data, trainIndex) {
   return (data[trainIndex, ])
}

# Function that creates the test set.
# The arguments are:
# - data: data structure to be analyzed.
# - trainIndex: indexes to create the test set.
getTestSet <- function(data, trainIndex) {
   return (data[-trainIndex, ])
}
