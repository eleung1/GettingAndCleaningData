## Author: Eric Leung
##
## Tidy up the data collected from the accelerometers from the Samsung
## Galaxy S smartphone.
## Raw data is in UCI_HAR_Dataset.zip, located in the same directory as this R file.
##
## Acceptance criteria:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
getTidyData <- function() {
  ## Unzip the raw dataset into "raw_data" folder  
  unzip("UCI_HAR_Dataset.zip", overwrite = TRUE, exdir = "./raw_data")
  
  ## -------------------- Load helper functions -------------------- ##
  source("helper_get_dataset.R")
  source("helper_get_subjects.R")
  source("helper_get_labels.R")
  
  ## -------------------- Reading data into memory -------------------- ##
  trainingSet <- getDataSet("./raw_data/UCI HAR Dataset/train/X_train.txt")
  testSet <- getDataSet("./raw_data/UCI HAR Dataset/test/X_test.txt")
  trainingLabels <- getLabels("./raw_data/UCI HAR Dataset/train/y_train.txt")
  testLabels <- getLabels("./raw_data/UCI HAR Dataset/test/y_test.txt")
  trainingSubjects <- getSubjects("./raw_data/UCI HAR Dataset/train/subject_train.txt")
  testSubjects <- getSubjects("./raw_data/UCI HAR Dataset/test/subject_test.txt")
  
  ## ---------- Merge the training set and test set to create one data set --------##
  mergedSet <- rbind(trainingSet, testSet)
  mergedLabels <- rbind(trainingLabels, testLabels)
  mergedSubjects <- rbind(trainingSubjects, testSubjects)
  
  ## ---------- We only want mean and std deviation for each measurement -----##
  ## mean and standard deviation meansurements have "-mean()" and "-std()" as column names
  mergedSet_mean_std <- mergedSet[, grepl("-mean\\(\\)|-std\\(\\)", names(mergedSet))]
  
  ## ---------- Combining subjects, labels, and dataset together ---------- ##
  combinedSet <- cbind(mergedSubjects, mergedLabels, mergedSet_mean_std)
  
  ## ---------- Sort by Subject ID, then Acitivity name ------------------- ##
  combinedSet <- combinedSet[order(combinedSet$Subject, combinedSet$Activity),]
  
  ## ----- Dataset with average of each variable for each activity and each subject ----#
  tidyData <- aggregate(combinedSet, by=list(SubjectGroup=combinedSet$Subject, ActivityGroup=combinedSet$Activity), FUN = mean, na.rm = TRUE)
  
  ## Dropping the original Subject and activity columns
  tidyData <- tidyData[, !(names(tidyData) %in% c("Subject", "Activity"))]
  
  ## Return tidy data
  tidyData
}