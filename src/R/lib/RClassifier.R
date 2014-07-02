# Library that will help us to work with classifiers

# We load the library that contains the different classifiers
library(e1071)

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
trainClassifierSVM <- function(corpus,cPosition,kfold=0) {
   # The class column should be categorical, not numeric.
   # Poor performance
   # classifier <- svm(corpus[,-cPosition],as.factor(corpus[,cPosition]))
   if(kfold == -1) kfold <- dim(corpus)[1] 
   
   classifier <- svm(corpus[,-cPosition],as.factor(corpus[,cPosition]),type="nu-classification",nu = 0.2, cross=kfold, probability=TRUE)
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
