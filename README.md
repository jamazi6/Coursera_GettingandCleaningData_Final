# Coursera_GettingandCleaningData_Final
Final project of the Coursera Getting and Cleaning Data Course

This R script takes raw gyroscopic data from an experiment using samsung smartphones
in which 30 subjects were asked to perform six activities (laying, standing, sitting, walking
downstairs, walking upstairs, and walking) and performs the following changes. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the 
average of each variable for each activity and each subject.

Make sure your working directory contains the "UCI HAR Dataset" before you run this script.
The final output is a dataframe named "Summarized_AccelerometerandGyroscope_Data". 
It gives the average mean observation for each test subject for each activity type.
