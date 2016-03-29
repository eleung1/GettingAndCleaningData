## Author: Eric Leung
##
## Helper method to get subjects from the text file.
## filePathSubjects: A path to the subjects text file.
getSubjects <- function(filePathSubjects){
  ## Read data from file
  subjects <- read.table(filePathSubjects)
  
  ## Rename column name of subjects to Subject
  colnames(subjects) <- c("Subject")
  
  subjects
}