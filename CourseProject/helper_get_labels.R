## Author: Eric Leung
##
## Helper method to get Activity name of each observation from text file.
## filePathLabels: A path to the labels text file.
getLabels <- function(filePathLabels){
  ## Read labels of each observation from file (values 1-6, each representing an activity)
  labels <- read.table(filePathLabels)
  
  ## Read the Acitvity labels mapping.  Col1 = label id; Col2 = Activity name
  activityNames <- read.table("./raw_data/UCI HAR Dataset/activity_labels.txt")
  colnames(activityNames) <- c("id", "name")
  
  ## Rename column name of labels to Activity.
  colnames(labels) <- c("Activity")
  
  ## Replace label ids with full activity names
  labels[,1] <- activityNames$name[labels$Activity]
  
  labels
}