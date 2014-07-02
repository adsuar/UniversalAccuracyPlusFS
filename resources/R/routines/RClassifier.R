# We load the library that contains the different classifiers
library(e1071)

# Function that loads the corpus
# The arguments are:
# - fileName: name and path of the file where the corpus
#   to be loaded is stored at.
loadCorpus <- function(fileName) {
   corpus <- read.csv(file=fileName,head=TRUE,sep=",")
   return(corpus)
}

# Function that trains the Naive Bayes classifier
# The arguments are:
# - corpus: the corpus data set used to train the classifier
# - cPosition: the column at which the class is specified
trainClassifierNB <- function(corpus,cPosition) {
   # The class column should be categorical, not numeric.
   classifier <- naiveBayes(corpus[,-cPosition],as.factor(corpus[,cPosition]))
   return(classifier)
}

# Function that trains the Support Vector Machines classifier
# The arguments are:
# - corpus: the corpus data set used to train the classifier
# - cPosition: the column at which the class is specified
trainClassifierSVM <- function(corpus,cPosition) {
   # The class column should be categorical, not numeric.
   # Poor performance
   # classifier <- svm(corpus[,-cPosition],as.factor(corpus[,cPosition]))
   classifier <- svm(corpus[,-cPosition],as.factor(corpus[,cPosition]),type="nu-classification",nu = 0.2)
   return(classifier)
}

# Function that predicts to which class belongs a new entry
# The arguments are:
# - classifier: classifier that will be used to make the prediction
# - entriesToClassify: the test corpus
classify <- function(classifier,entriesToClassify) {
   prediction <- predict(classifier, entriesToClassify)
   return (prediction)
}

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


# Function that dumps into disk a data structure in CSV format.
# The arguments are:
# - data: data structure to be dumped.
# - fileName: name of the file to be created.
storeAsCSV <- function(data,fileName) {
   # Function that stores a given data set into disk.
   write.csv(data,file=fileName,quote=FALSE,row.names=FALSE)
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