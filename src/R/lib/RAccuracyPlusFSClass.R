# Library that defines the different functions needed for the project
# plus the variables needed.

# Function that initializes the project loading the data information and
# creating the derivated structures.
initialize <- function() {
   # Import the caret package that has misc functions for training and plotting
   # classification and regression models.
   # Dependencies -- NEED TO TEST
   library(lattice)
   library(ggplot2)

   library(caret)

   printMessage ("\nINITIALIZATION PROCESS\n")
   printMessage ("======================\n\n")
   printMessage ("\n\tLoading the description of the clinical data at: ",descriptionFile,"\n")
   dat1 <- loadCSVFile(descriptionFile)
   printMessage ("\t\tThe two dimensions are: ",dim(dat1)[1],"x",dim(dat1)[2],"\n")
   printMessage ("\n\tLoading the samples of the clinical data at: ", samplesFile,"\n")
   dat2 <- loadCSVFile(samplesFile)
   printMessage ("\t\tThe two dimensions are: ",dim(dat2)[1],"x",dim(dat2)[2],"\n")
   printMessage ("\n\tMerging description and samples into one single resource\n\n")
   
   # Assign the merging result to a global variable.
   assign("dataset.merged", mergeData(dat1, descriptionColumnLink, dat2, samplesColumnLink),envir = .GlobalEnv)
   
   printMessage ("\t\tThe two dimensions are: ",dim(dataset.merged)[1],"x",dim(dataset.merged)[2],"\n")
   printMessage ("\n\tSaving merged data at ",mergingFile, " for debugging purposes\n\n")
   storeAsCSV(dataset.merged,mergingFile)
}

# Function that'll create the training and test data sets.
createTrainAndTestData <- function() {
   printMessage ("\n\nCREATING DATA SETS\n")
   printMessage ("==================\n\n")
   
   # We get the number of rows (samples) of the project.
   n <- dim(dataset.merged)[1]
   # We get the number of 
   assign("train.size",ceiling(0.7*n),envir = .GlobalEnv)
   
   printMessage("\n\tThe number of training samples will be: ", train.size,"\n")
   printMessage("\n\tThe number of test samples will be: ", n-train.size,"\n")
   
   # We define the rows that'll belong to the training data set.
   #train.index <- sample(seq_len(nrow(dataset.merged)), size=train.size)
   assign("train.index",sample(seq_len(nrow(dataset.merged)), size=train.size),envir = .GlobalEnv)
   
   # Creation of the train and test data set
   assign("dataset.train",dataset.merged[train.index,],envir = .GlobalEnv)
   assign("dataset.test",dataset.merged[-train.index,],envir = .GlobalEnv)
}

# Function that trains the classifier and instantiates it.
generateClassifier <- function(corpus,position,kfold=0) {
   printMessage ("\n\nTRAINING CLASSIFIER\n")
   printMessage ("===================\n\n")
   
   
   printMessage ("\n\tTraining the SVM classifier\n\n")
   assign("trainer", trainClassifierSVM(corpus,position,kfold),envir = .GlobalEnv)
   
   #printMessage ("\n\tTraining the NB classifier\n\n")
   #assign("trainer", trainClassifierNB(corpus,position),envir = .GlobalEnv);
}

# Function that predicts to which classes belongs a new set of entries.
classifyEntries <- function(classifier,entriesToClassify) {
   printMessage ("\n\nCLASSIFYING NEW ENTRIES\n")
   printMessage ("=======================\n\n")
   
   printMessage("\tThe dimensions of the data to classify are: ",dim(entriesToClassify),"\n\n")
   prediction <- predict(classifier,entriesToClassify)
   return(prediction)
}

# Function that generates the different values needed from the confusionMatrix
generateDiagnosticAccuracyData <- function(prediction,reference) {
   printMessage ("\n\nGENERATING DIAGNOSTIC ACCURACY DATA\n")
   printMessage ("===================================\n\n")
   
   #cat(prediction)
   #cat("\n\n")
   #cat(reference)
   
   accuracyData <- confusionMatrix(prediction,reference)
   
   nData <- class.size*4
   size <- class.size
   if(class.size == 2) {
      nData <- 4
      size <- 1
   }
   
   assign("diagnosticAccuracy.data",accuracyData,envir = .GlobalEnv)
   assign("diagnosticAccuracy.matrix",matrix(accuracyData$byClass[1:nData],nrow=size,ncol=4),envir = .GlobalEnv)
   assign("diagnosticAccuracy.accuracy",accuracyData$overall[[1]],envir = .GlobalEnv)
}

# Function that will print the diagnostic accuracy data
printDiagnosticAccuracyData <- function() {
   printMessage ("\n\nDIAGNOSTIC ACCURACY DATA\n")
   printMessage ("========================\n\n")
   
   printMessage("\tThe accuracy of the prediction model is: ",diagnosticAccuracy.accuracy,"\n")
   
   size <- class.size
   if(class.size == 2) size <- 1
   
   for(i in 1:size) {
      printMessage("\tClass ",i-1,":\n")
      printMessage("\t\tSensitivity: ",diagnosticAccuracy.matrix[i,1],"\n")
      printMessage("\t\tSpecificity: ",diagnosticAccuracy.matrix[i,2],"\n")
      printMessage("\t\tPPV: ",diagnosticAccuracy.matrix[i,3],"\n")
      printMessage("\t\tNPV: ",diagnosticAccuracy.matrix[i,4],"\n\n")
   }
}

# Function that will execute a certain analysis of the accuracy of a given
# environment
analyzeDataAccuracy <- function(sizeOfMeasures,analysis=0) {
   n <- class.sampleInformationPosition + sizeOfMeasures - 1
   
   if(sizeOfMeasures <= 0) n <- dim(dataset.merged)[2]
   
   columnsTrain <- c(class.position,class.sampleInformationPosition:n)
   columnsTest  <- c(class.sampleInformationPosition:n)
   
   # 1) Train Classifier
   generateClassifier(dataset.train[,columnsTrain],1,kfold.crossvalidation)
   # 2) Execute the clasification
   result <- classifyEntries(trainer,dataset.test[,columnsTest])
   # 3) Generate the diagnostic accuracy data
   generateDiagnosticAccuracyData(result,dataset.test[,class.position])
   # 4) Print the results
   if(analysis == 0) {
      printDiagnosticAccuracyData()
   } else if (analysis == 1) {
      printMessage("Size ", sizeOfMeasures, " - The diagnostic accuracy is: ", diagnosticAccuracy.accuracy," for " , n , " as maximum position\n\n")
   }
}
