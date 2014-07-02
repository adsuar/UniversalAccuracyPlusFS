# Library that defines the different functions needed for the project
# plus the variables needed.

# Function that initializes the project loading the data information and
# creating the derivated structures.
initialize <- function() {
   # Import the caret package that has misc functions for training and plotting
   # classification and regression models.
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
   #assign("trainer", trainClassifierNB(corpus,position),envir = .GlobalEnv);
   #trainer <- trainClassifierNB(corpus,position);
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
   
   accuracyData <- confusionMatrix(prediction,reference)
   
   assign("diagnosticAccuracy.data",accuracyData,envir = .GlobalEnv)
   assign("diagnosticAccuracy.matrix",matrix(accuracyData$byClass[1:12],nrow=3,ncol=4),envir = .GlobalEnv)
   assign("diagnosticAccuracy.accuracy",accuracyData$overall[[1]],envir = .GlobalEnv)
}

printDiagnosticAccuracyData <- function() {
   printMessage ("\n\nDIAGNOSTIC ACCURACY DATA\n")
   printMessage ("========================\n\n")
   
   printMessage("\tThe accuracy of the prediction model is: ",diagnosticAccuracy.accuracy,"\n")
   
   for(i in 1:3) {
      printMessage("\tClass ",i-1,":\n")
      printMessage("\t\tSensitivity: ",diagnosticAccuracy.matrix[i,1],"\n")
      printMessage("\t\tSpecificity: ",diagnosticAccuracy.matrix[i,2],"\n")
      printMessage("\t\tPPV: ",diagnosticAccuracy.matrix[i,3],"\n")
      printMessage("\t\tNPV: ",diagnosticAccuracy.matrix[i,4],"\n\n")
   }
}

analyzeDataAccuracy <- function(sizeOfMeasures,analysis=0) {
   n <- class.position + sizeOfMeasures
   
   if(sizeOfMeasures <= 0) n <- dim(dataset.merged)[2]
   
   # 1) Train Classifier
   generateClassifier(dataset.train[,class.position:n],1,kfold.crossvalidation)
   # 2) Execute the clasification
   result <- classifyEntries(trainer,dataset.test[,sampleInformationPosition:n])
   # 3) Generate the diagnostic accuracy data
   generateDiagnosticAccuracyData(result,dataset.test[,class.position])
   # 4) Print the results
   if(analysis == 0) {
      printDiagnosticAccuracyData()
   } else if (analysis == 1) {
      printMessage("Size ", sizeOfMeasures, " - The diagnostic accuracy is: ", diagnosticAccuracy.accuracy,"\n\n")
   }
}
