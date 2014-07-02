# Configuration file that contains all the data configuration needed for the
# right execution of my routines at this project.

# FILES CONFIGURATION

# Name of the file that stores the description of all the clinical data.
# It's not the original file but its transformation in CSV format since
# the original one was codified in XLSX format.
descriptionFile <- paste(baseFolder, "resources/data/clinical_data_HV_CC_LC.csv", sep="")
# Column of the description file that will be used as join point with the
# samples
descriptionColumnLink <- "Number"
# Name of the file that stores the samples of the clinical data.
# It's not the original file since such file has been normalized (transposed
# and changed some of the values such unknown)
samplesFile <- paste(baseFolder, "resources/data/HV_CC_LC_neg.trans.csv", sep="")
# Column of the samples file that will be used as join point with the
# description
samplesColumnLink <- "Sample"
# Name of the file that will be generated from description and samples once
# both files are merged.
mergingFile <- "/tmp/mergingData.csv"

# DATA SPLIT CONFIGURATION
# Percentage of the mergingFile that will be used as training data. Obviously,
# is not necessary to specify the test percentage since is the result of the
# next calculation: 1 - trainingPercentage
trainingPercentage <- 0.7

# Number of subsets in which the training space has to be splitted  for making
# the training of the classifier.
# If -1, it means loocv
# WARNING: loocv turns into a really slow training execution
kfold.crossvalidation <- 0

# CLASS CONFIGURATION
# Position at which the class is stored.
class.position <- 9
# Position at which the sample information starts.
sampleInformationPosition <- 10

# PRINT CONFUGURATION
printMessages <- TRUE
