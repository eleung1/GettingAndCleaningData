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
  
  ## -------------------- Reading data into memory -------------------- ##
  ## Read training set.  
  ## (7352 obs, 561 vars)
  trainingSet <- read.table("./raw_data/UCI HAR Dataset/train/X_train.txt")
  
  ## Read training labels. This corresponds to activity names. 
  ## (7352 obs, 1 var) 
  trainingLabels <- read.table("./raw_data/UCI HAR Dataset/train/y_train.txt")
  
  ## Read training subjects.  
  ## Each row identifies the subject who performed the activity in the training set. 
  ## Its range is from 1 to 30.
  ## (7352 obs, 1 var)
  trainingSubjects <- read.table("./raw_data/UCI HAR Dataset/train/subject_train.txt")
  
  ## Feature names.  This will be used as column names.
  ## (561 obs, 2 vars)
  featureNames <- read.table("./raw_data/UCI HAR Dataset/features.txt")
  
  ## Activity names.  This will be used to identify activities.
  ## (6 obs, 2 vars)
  activityNames <- read.table("./raw_data/UCI HAR Dataset/activity_labels.txt")
  
  ## -------------------- Renaming columns -------------------- ##
  ## Rename column names of training set with proper feature names
  colnames(trainingSet) <- featureNames[,2]
  
  ## Rename column name of trainingSubjects to Subject
  colnames(trainingSubjects) <- c("Subject")
  
  ## Rename column name of trainingLabels to Activity.
  colnames(trainingLabels) <- c("Activity")
  
  ## Rename column names of activity names.
  colnames(activityNames) <- c("id", "name")
  
  ## ---------- Replace activity labels with full activity names ---------- ##
  trainingLabels <- activityNames$name[trainingLabels$Activity]
  
  ## ---------- We only want mean and std deviation for each measurement -----##
  ## mean and standard deviation meansurements have "-mean()" and "-std()" as column names
  trainingSet_mean_std <- trainingSet[, grepl("-mean\\(\\)|-std\\(\\)", names(trainingSet))]
  
  ## ---------- Combining data together ---------- ##
  combined <- cbind(trainingSubjects, trainingLabels, trainingSet_mean_std)
  
  combined
}