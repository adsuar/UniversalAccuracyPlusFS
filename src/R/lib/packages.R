# Installation of the RServe package
install.packages('Rserve',,'http://www.rforge.net/')

# Install package that contains Naive Bayes classifier
install.packages("e1071")

# Install package that contains sensitivity, specificity, etc. functionalities
install.packages("caret")

# Install package for rfe backwards selection function (though rfe is from
# caret package, this package is a dependency)
install.packages("kernlab")

# Install packages for using the roc and auc functions.
install.packages("pROC")
