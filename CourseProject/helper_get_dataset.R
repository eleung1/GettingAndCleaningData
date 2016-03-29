## Author: Eric Leung
##
## Read dataset and featureNames from file.
## Replace the resulting dataframe's column/variable names with 
## the corresponding featureNames.
##
## filePathDataSet: A path to the dataset text file.
getDataSet <- function(filePathDataSet){
  ## Read data from file
  dataSet <- read.table(filePathDataSet)
  featureNames <- read.table("./raw_data/UCI HAR Dataset/features.txt")
  
  ## Rename column names of training set with proper feature names
  colnames(dataSet) <- featureNames[,2]
  dataSet
}