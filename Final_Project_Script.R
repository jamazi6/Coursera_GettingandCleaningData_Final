#This R script takes raw gyroscopic data from an experiment using samsung smartphones
#and performs the following changes. Make sure your working directory contains the
#"UCI HAR Dataset" before you run this function

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.



library(dplyr) #load dplyr package to use rename() function
library(lubridate) #load lubridate package to use merge() function

#read in variable names from features.txt and assign to a character vector
featurenames <- read.table("UCI HAR Dataset/features.txt")
newcolumnnames <- as.character(featurenames$V2)

#read in train data
Ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names=c("activity"))
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=newcolumnnames)
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))
#read in test data
Ytest <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names=c("activity"))
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=newcolumnnames)
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))


#combine X, Y, and Subject files into train and test tables. 
#Do not combine all tables because we want to rbind trainDF and testDF
trainDF <- cbind(subjectTrain, Ytrain, Xtrain)
testDF <- cbind(subjectTest, Ytest, Xtest)

#before merging the dataframes, we create a test or train variable 
#to preserve this distinction in case it is useful in the future
trainDF$train_or_test <- "train"
testDF$train_or_test <- "test"

#merge test and train dataframes. 
mergedDF <- rbind(trainDF,testDF)

#extract only mean and standard deviation measurements, plus our subject, 
#activity, and train or test variables
filteredDF <- select(mergedDF, matches('mean|std|subject|activity|train_or_test', ignore.case = TRUE))

#replace activity numbers with activity names
replace_name <- function(number){
  if(number==6) number <- "Laying"
  if(number==5) number <- "Standing"
  if(number==4) number <- "Sitting"
  if(number==3) number <- "Walking Downstairs"
  if(number==2) number <- "Walking Upstairs"
  if(number==1) number <- "Walking"
  number
  
}
filteredDF$activity <- sapply(as.numeric(filteredDF$activity), replace_name)

#group dataframe by subject and activity. At this point, we merge test and train 
#data so these variables are lost. If you want to preserve them, change the following sted to:
#DF_grouped <- group_by(filteredDF, subject, activity, train_or_test)
DF_grouped <- group_by(filteredDF, subject, activity)

#summarize dataframe to get mean of observations for each person for each activity
summarize <- summarize_at(DF_grouped, .vars=colnames(DF_grouped[3:88]), .funs=mean)
summarizeDF <- as.data.frame(summarize)

write.csv(summarizeDF, file="Summarized_AccelerometerandGyroscope_Data.csv")
