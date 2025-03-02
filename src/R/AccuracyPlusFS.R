# Main file that will manage the execution of the whole project.

# DEBUG ONLY
# The following routing clears all the workspace (so no old instantiation
# of any variable or funtion will be active yet).
rm(list=ls(all=TRUE))

# Base folder for all the files that are stored at this project.
baseFolder <- "/home/adsuar/workspace/trabajo/UniversalAccuracyPlusFS/"

# We store the current folder
initial.folder <- getwd()

# We change the current folder
setwd(baseFolder)

# We set the properties needed by the functions to develop the project.
source("src/R/config/properties.R")
# We install the dependencies if needed.
# source("src/R/lib/packages.R")
# We load the my general purpose auxiliar functions.
source("src/R/lib/RUtils.R")
# We load the auxiliar functions that will help us to work with files
source("src/R/lib/RFiles.R")
# We load the auxiliar functions that will help us to work with sets of data
source("src/R/lib/RSets.R")
# We load the auxiliar functions of classifiers that I've developed
source("src/R/lib/RClassifier.R")
# We load the project heuristics
source("src/R/lib/RAccuracyPlusFSClass.R")

# Clear the screen
cls()
# Heuristics of the project
initialize()
# Creation of the sets of data needed to work
# At this point, we've defined both sets of data and won't be re-calculated
# again in this execution
createTrainAndTestData()

# First Step -- Calculate Sensitivity, Specificity, PPV, NPV and AUC graph
analyzeDataAccuracy(0)
# Second Step -- Calculate Accuracy for 5,10,20 and 50
printMessage ("\n\nANALYZING ACCURACY FOR DIFFERENT AMOUNTS OF MEASUREMENTS\n")
printMessage ("========================================================\n\n")

printMessagesOld <- printMessages
printMessages <- FALSE
measurements <- c(5,10,20,50)
accuracyMeasurements <- matrix(c(0,0,0,0),nrow=1,ncol=4)
colnames(accuracyMeasurements) <- c("5","10","20","50")
rownames(accuracyMeasurements) <- c("accuracy")
position <- 1
for(i in measurements) {
   analyzeDataAccuracy(i,1)
   accuracyMeasurements[1,position] <- diagnosticAccuracy.accuracy
   position <- position + 1
}
printMessages <- printMessagesOld
printMessage("The accuracy of the different measurements is:\n\n")
printMatrix(accuracyMeasurements)

#Third Step -- Calculate Sensitivity, Specifitivity, PPV and NPV for Gender, Age, Histology and Stage
class.position.old <- class.position
class.size.old <- class.size
printMessage ("\n\nANALYZING ACCURACY FOR GENDER\n")
printMessage ("=============================\n\n")
class.position <- 4
class.size <- 2
#analyzeDataAccuracy(0,0)

printMessage ("\n\nANALYZING ACCURACY FOR AGE\n")
printMessage ("==========================\n\n")
class.position <- 5
class.size <- 55
# This calculation won't be executed since due to the high number of different
# classes regarding to the size of data, R can't calculate the confusionMatrix.
# In my previous tests, the prediction only gets no more than 10 different ages.
# If both test and train set don't have the same classes identified,the 
# calculation of the confusionMatrix won't be able to be executed.
#analyzeDataAccuracy(0,0)

printMessage ("\n\nANALYZING ACCURACY FOR HISTOLOGY\n")
printMessage ("===============================\n\n")
class.position <- 7
class.size <- 2
# This calculation works sometimes, depending on the creation of the train and
# test set. If both test and train set don't have the same classes identified,
# the calculation of the confusionMatrix won't be able to be executed.
#analyzeDataAccuracy(0,0)

printMessage ("\n\nANALYZING ACCURACY FOR STAGE\n")
printMessage ("============================\n\n")
class.position <- 8
class.size <- 13
# This calculation won't be executed since due to the high number of different
# classes regarding to the size of data, R can't calculate the confusionMatrix.
# In my previous tests, the prediction only gets no more than 4 or 5 different
# stages.
# If both test and train set don't have the same classes identified,the 
# calculation of the confusionMatrix won't be able to be executed.
#analyzeDataAccuracy(0,0)

class.position <- class.position.old
class.size <- class.size.old

# IDENTIFICATION OF THE BEST 20 FEATURES
RFE <- getBestVariables()

# We restore the current folder to the previous one
setwd(initial.folder)
