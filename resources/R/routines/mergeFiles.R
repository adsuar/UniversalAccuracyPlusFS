dat1 <- read.csv(file=descriptionFile,head=TRUE,sep=",")
dat2 <- read.csv(file=samplesFile,head=TRUE,sep=",")

# Merging of both data sets in one single file taking as a common point the columns Number and Sample.
dataMerged <- merge(x=dat1,y=dat2,by.x="Number",by.y="Sample")
# Function that stored the resultant data set in a disk file.
write.csv(dataMerged,file=dataMergedFile,quote=FALSE,row.names=FALSE)

# The following data code will get the size of the training data set.
n <- dim(dataMerged)[1]
train.size <- round(0.7*n)

# We define the rows that belong to the training data set.
train_index <- sample(seq_len(nrow(dataMerged)), size = train.size)

# Creation of the train and test data set
train <- dataMerged[train_index, ]
test <- dataMerged[-train_index, ]

