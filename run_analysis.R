# This R code is a part of the Assignment for week 4 of 'Getting and Cleaning Data' Course from Coursera
# The follwoing is the description of the problem provided:

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# The actual R code begins from here which does the above sepcified tasks.

#download the fiels from the web and unzip them in the working directory
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
library(data.table)
library(reshape2)
download.file(fileurl,"datazip.zip")
unzip(zipfile="datazip.zip")

#load activity labels and all the features

activitylabels<-data.table::fread("UCI HAR Dataset/activity_labels.txt",col.names = c("classLabels","activityName"))
features<-data.table::fread("UCI HAR Dataset/features.txt",col.names = c("index","featureNames"))
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements<-features[featuresWanted,featureNames]
measurements <- gsub('[()]', '', measurements)

#load train data files
train <- fread("UCI HAR Dataset/train/X_train.txt")[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements) #to rename the coloumn names of train with 'measurement' names
trainActivities <- fread("UCI HAR Dataset/train/Y_train.txt", col.names = c("Activity"))
trainSubjects <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train) #combine all the different files into one dataset

#load test data files
test <- fread("UCI HAR Dataset/test/X_test.txt")[, featuresWanted, with = FALSE]
testActivities <- fread("UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))
testSubjects <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

#merge the two data sets
mergedata<-rbind(train,test,fill=TRUE)

#provide proper labels to the activities in the final merged dataset
#got data from activitylabels dataset 
mergedata[["Activity"]] <- factor(mergedata[, Activity] , levels = activitylabels[["classLabels"]], labels = activitylabels[["activityName"]])
mergedata[["SubjectNum"]] <- as.factor(mergedata[, SubjectNum])

#select data from the mergedata dataset to tidy the data for each subject and their respective activities
mergedata2 <- reshape2::melt(data = mergedata, id = c("SubjectNum", "Activity"))
finaldata <- reshape2::dcast(data = mergedata2, SubjectNum + Activity ~ variable, fun.aggregate = mean)
#final dataset is in finaldata data frame

#write the finaldata to a file
data.table::fwrite(x = finaldata, file = "tidyData.txt", quote = FALSE)

