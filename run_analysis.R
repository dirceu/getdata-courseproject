# This script does the following:
#  * Merges the training and the test sets to create one data set.
#  * Extracts only the measurements on the mean and standard deviation for each measurement. 
#  * Uses descriptive activity names to name the activities in the data set
#  * Appropriately labels the data set with descriptive variable names. 
#  * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Author: Dirceu Pereira Tiegs

# setup necessary packages and data set files
install.packages("gdata", "plyr", "reshape2")
library(gdata)
library(plyr)
library(reshape2)
setwd("/Users/dirceu/Desktop/getdata-courseproject")
if(!file.exists("UCI HAR Dataset/README.txt")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="data.zip", method="curl")
    unzip("data.zip")
    file.remove("data.zip")
}

# open and prepare features data
features <- read.table("UCI HAR Dataset/features.txt", sep="", stringsAsFactors=FALSE)
features$V2 <- gsub("^t", "Time.", features$V2)
features$V2 <- gsub("^f", "Frequency.", features$V2)
features$V2 <- gsub("[()]", "", features$V2)
features$V2 <- gsub("[-+,]", ".", features$V2)

# open and set type of test / train data (for merging later)
test.data <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features$V2)
test.data$Type <- "Test"
train.data <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features$V2)
train.data$Type <- "Train"

# add other columsn for merging later
test.data$Subject <- read.table("UCI HAR Dataset/test/subject_test.txt")$V1
train.data$Subject <- read.table("UCI HAR Dataset/train/subject_train.txt")$V1
test.data$ActivityID <- read.table("UCI HAR Dataset/test/y_test.txt")$V1
train.data$ActivityID <- read.table("UCI HAR Dataset/train/y_train.txt")$V1

# merge data
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("ActivityID", "ActivityLabel"))
test.data <- merge(test.data, activity.labels, by.x="ActivityID", by.y="ActivityID", all.x=TRUE)
train.data <- merge(train.data, activity.labels, by.x="ActivityID", by.y="ActivityID", all.x=TRUE)
merged.data <- rbind(test.data, train.data)

# get columns related with standard deviation and mean values
cols <- matchcols(merged.data, with=c("std", "mean"), method="or")
tidy.data <- merged.data[, c("Subject", "ActivityLabel", "Type", cols$std, cols$mean)]
write.csv(tidy.data, "tidy_data.csv")

# create a new dataset with descriptive labels
ids <- matchcols(tidy.data, with=c("Subject", "ActivityLabel"), method="or")
values <- matchcols(tidy.data, without=c("Subject", "ActivityLabel", "Type"), method="or")
descriptive.data <- melt(tidy.data, id=ids, measure.vars=values)

# create a new dataset with the average of each value from descriptive.data
average.data <- ddply(descriptive.data, .(Subject, ActivityLabel, variable), summarize, mean=mean(value))
write.csv(average.data, "average_data.csv")