UniversalAccuracy
=================

Project that has examines a set of data and execute several analysis from different points of view.

Packages to Install
-------------------

In **resources/R/packages.R** we can find the different packages that we need to install:

- *e1071* package (so we can invoke the NaiveBayes or the SVM classifier)
- *caret* package (so we can get sensitivity, specificity, etc.)
- *kernlab* package (so we can use the RFE backwards selection function)
- *pROC* package (so we can use the roc functions)

Parametrization
---------------

You can find at **src/R/config/properties.R** the different properties you can set to customize your project.

At **src/R/AccuracyPlusFS.R** you can modify too an important parameter, **baseFolder** that points to the base folder of the project.

Data Preprocessing
------------------

I've developed a routine at **tools** named **normalize.sh** that has helped me to normalize data. At the beginning I had the information as it is at **resources/client_files** and I executed two steps:

a) Transform the **Clinical data_HV_CC_LC.xlsx** file into a CSV file.
b) Normalize both files. Thus, the values of the features were normalized and the structure of HV_CC_LC_neg.csv file as modified (transposed).

This step won't be executed again since at **resources/data** is the information already normalized.

Execution
---------

The execution of the project is very simple. Once you've loaded R, you have to invoke the main file of our R project.

Such R main file is located at **src/R/** and is named **AccuracyPlusFS.R**.

The loading process is as follows:

source("path/to/the/project/src/R/AccuracyPlusFS.R")


Results
-------

Once the project is executed, you'll see the following results at the screen:

- **INITIALIZATION PROCESS**: We load all the information and merge it into a single file.
- **CREATING DATA SETS**: We create the train and test data sets. The splitting of the data is made randomly.
- **Analyze the data accuracy for the 70/30 model**: We train the classifier, classify the test data set and generate the diagnostic accuracy data, which includes the plotting of the ROC curve. The ROC and AUC data are calculated for a three-classes environment, but the function that'll plot the result works only in a two-classes environment.
- **ANALYZING ACCURACY FOR DIFFERENT AMOUNTS OF MEASUREMENTS**: We show the accuracy for 4 different sizes of features. Such features aren't got randomly. 
- **ANALYZING ACCURACY OF GENDER**: Analyze the classification by gender.
- **ANALYZING ACCURACY OF AGE**: Analyze the classification by age. This calculation won't be able to be done. If both test and train set don't have the same classes identified,the calculation of the confusionMatrix won't be able to be executed.
- **ANALYZING ACCURACY OF HISTOLOGY**: Analyze the classification by histology. This calculation won't be able to be done. If both test and train set don't have the same classes identified,the calculation of the confusionMatrix won't be able to be executed.
- **ANALYZING ACCURACY OF STAGE**: Analyze the classification by stage. This calculation won't be able to be done. If both test and train set don't have the same classes identified,the calculation of the confusionMatrix won't be able to be executed.
- **IDENTIFY THE 20 BEST MEASUREMENTS**: The 20 best measurements or features are calculated and ploted into files at /tmp. I've used the **rfe** function of the **caret** packaged to perform the identification of the best 20 features.
