# Coursera: Getting and Cleaning Data Course Project

#run_analysis.R Description:
# This script will perform the following steps on the UCI HAR Dataset downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# The script assumed that the unzipped UCI HAR Data set sits in the parent directory to where our script is saved

# Step 1: Merge the training and test sets.

#Read Training Data sets then assign column names
features <- read.table('../UCI HAR Dataset/features.txt',header=FALSE,stringsAsFactors = FALSE)
activity_labels <- read.table('../UCI HAR Dataset/activity_labels.txt',header=FALSE,stringsAsFactors = FALSE)
subject_train <- read.table('../UCI HAR Dataset/train/subject_train.txt',header=FALSE,stringsAsFactors = FALSE)
x_train <- read.table('../UCI HAR Dataset/train/x_train.txt',header=FALSE,stringsAsFactors = FALSE)
y_train <- read.table('../UCI HAR Dataset/train/y_train.txt', header = FALSE,stringsAsFactors = FALSE)

colnames(activity_labels) <- c('activityId','activityType')
colnames(subject_train) <- "subjectId"
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"

trainingData <- cbind(y_train, subject_train, x_train)

#Do the same for Test Set
subject_test <- read.table('../UCI HAR Dataset/test/subject_test.txt',header=FALSE,stringsAsFactors = FALSE)
x_test <- read.table('../UCI HAR Dataset/test/x_test.txt',header=FALSE,stringsAsFactors = FALSE)
y_test <- read.table('../UCI HAR Dataset/test/y_test.txt', header = FALSE, stringsAsFactors = FALSE)

colnames(subject_test) <- "subjectId"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"

testData <- cbind(y_test, subject_test, x_test)

#Combine test and train data to form the final Data!
finalData <- rbind(trainingData, testData)

#Keep only data related to mean and standard deviations
keepFeatures<- (grepl("*Id",colnames(finalData)) | grepl("-mean..",colnames(finalData)) & !grepl("-meanFreq..",colnames(finalData)) & !grepl("mean..-",colnames(finalData)) | grepl("-std..",colnames(finalData)) & !grepl("-std()..-",colnames(finalData)));
finalData <- finalData[, keepFeatures]

#Step 3: Appropriately labels the data set with descriptive variable names.
colNames <- gsub("[Mm]ag", "Magnitude", colnames(finalData))
colNames <- gsub("-mean\\()", "Mean", colNames)
colNames <- gsub("-std\\()", "StandardDev", colNames)
colNames <- gsub("^(t)", "Time", colNames)
colNames <- gsub("^(f)", "Freq", colNames)
colNames <- gsub("[Aa]cc", "Acceleration", colNames)
colnames(finalData) <- colNames

#Step 4: Use descriptive activity names to name the activities in the data set.
finalData <- merge(finalData,activity_labels,by='activityId',all.x=TRUE);

#Step 5:  Create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData = aggregate(finalData[,names(finalData) != c('activityId','subjectId','activityType')],by=list(activityId=finalData$activityId,subjectId = finalData$subjectId),mean);
tidyData = merge(tidyData,activity_labels,by='activityId',all.x=TRUE);

# Export the tidyData set
write.table(tidyData, 'tidyData.txt',row.names=TRUE,sep='\t');