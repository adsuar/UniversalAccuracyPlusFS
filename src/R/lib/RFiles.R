# Library that contains functions to manage files.

# Function that loads the corpus
# The arguments are:
# - fileName: name and path of the file where the corpus
#   to be loaded is stored at.
loadCSVFile <- function(fileName) {
   corpus <- read.csv(file=fileName,head=TRUE,sep=",")
   return(corpus)
}

# Function that dumps into disk a data structure in CSV format.
# The arguments are:
# - data: data structure to be dumped.
# - fileName: name of the file to be created.
storeAsCSV <- function(data,fileName) {
   # Function that stores a given data set into disk.
   write.csv(data,file=fileName,quote=FALSE,row.names=FALSE)
}

