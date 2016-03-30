Getting and Cleaning Data: Course Project
=========================================

###  1. The raw data
UCI_HAR_Dataset.zip

###  2. A tidy data set
tidyData.txt

###  3. A code book describing each variable and its values in the tidy data set.
CodeBook.md

###  4. An explicit and exact recipe from raw data to tidy data.
*  Clone my git repository to your local machine.
```
git clone https://github.com/eleung1/GettingAndCleaningData.git
```
*  Examine the <b>CourseProject</b> directory that is cloned onto your local machine. In your RStudio (or R console), set your working directory to this directory.  

*  The raw data is in <b>UCI_HAR_Dataset.zip</b> which is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip on 2016-03-26 17:43 ET
md5sum: d29710c9530a31f303801b6bc34bd895

*  run_analysis.R contains the logic that turns the raw data to tidy data.  Open that file in the editor and let's walk through what it is doing.

*  run_analysis.R has one function called getTidyData()

*  It starts off with unzipping the raw data UCI_HAR_Dataset.zip into a new folder called raw_data in the same directory.
```
unzip("UCI_HAR_Dataset.zip", overwrite = TRUE, exdir = "./raw_data")
```

*  Then it loads the 3 R-scripts containing helper functions to help us extract the different raw data.
```
source("helper_get_dataset.R")
source("helper_get_subjects.R")
source("helper_get_labels.R")
```

*  helper_get_dataset.R contains a helper function getDataSet().  It is responsible for loading the training and test set from file to memory.  It will also rename the columns with descriptive variable names which is provided in features.txt.

*  helper_get_subjects.R contains a helper function  getSubjects().  It is responsible for loading the training and test subjects from file to memory.  It will also rename the column name to "Subject".

* helper_get_labels.R contains a helper function getLabels().  It is responsible for loading the labels from file to memory.  It will also replace the labels with their corresponding activity names.

* Next, run_analysis.R will use these 3 helper methods to load training and test data into memory:
```
trainingSet <- getDataSet("./raw_data/UCI HAR Dataset/train/X_train.txt")
testSet <- getDataSet("./raw_data/UCI HAR Dataset/test/X_test.txt")
trainingLabels <- getLabels("./raw_data/UCI HAR Dataset/train/y_train.txt")
testLabels <- getLabels("./raw_data/UCI HAR Dataset/test/y_test.txt")
trainingSubjects <- getSubjects("./raw_data/UCI HAR Dataset/train/subject_train.txt")
testSubjects <- getSubjects("./raw_data/UCI HAR Dataset/test/subject_test.txt")
```

*  Then we merge the training and test data together to create one data set:
```
mergedSet <- rbind(trainingSet, testSet)
mergedLabels <- rbind(trainingLabels, testLabels)
mergedSubjects <- rbind(trainingSubjects, testSubjects)
```

*  Extracts only the measurements on the mean and standard deviation for each measurement.  
```
mergedSet_mean_std <- mergedSet[, grepl("-mean\\(\\)|-std\\(\\)", names(mergedSet))]
```

*  Combining the training set, labels, and subjects together so we have one observation per row, and one variable per column.
```
combinedSet <- cbind(mergedSubjects, mergedLabels, mergedSet_mean_std)
```

*  Sorting by Subject, then Activity.
```
combinedSet <- combinedSet[order(combinedSet$Subject, combinedSet$Activity),]
```

*  Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
tidyData <- aggregate(combinedSet, by=list(SubjectGroup=combinedSet$Subject, ActivityGroup=combinedSet$Activity), FUN = mean, na.rm = TRUE)
```

*  The aggregate step will apply the mean() to all columns.  The original Subject and Activity columns now contains the mean of their values, which is not what we want in the final tidyData.  Removing them.  
```
tidyData <- tidyData[, !(names(tidyData) %in% c("Subject", "Activity"))]
```

*  Done. Return the tidyData.