Getting and Cleaning Data Course Project
========================================

Author: Dirceu Pereira Tiegs

The run_analysis.R script does the following:
* Merges the training and the test sets to create one data set (tidy_data.csv).
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject (average_data.csv).

Variables
---------

* *features*: Features read from the dataset to be used as column names.
* *train.data:* Train dataset. We later add the "Subject", "ActivityID", "ActivityLabel" and "Type" columns.
* *test.data:* Test dataset. We later add the "Subject", "ActivityID", "ActivityLabel" and "Type" columns.
* *merged.data:* Combination of train.data and test.data.
* *tidy.data*: Dataset with "Subject", "ActivityLabel", "Type" and all columns related to standard deviation or mean values.
* *descriptive.data*: Tidy dataset with descriptive labels.
* *average.data*: Dataset with the average of each value from descriptive.data.

Flow
----

* The script reads the "features.txt" file and perform some basic cleanup on the "V2" column (changing "f_" to "Frequency_", removing "(" and ")" and other special characters, etc.);
* The test and train datasets are read and a new column, "Type", is added to tell them apart once we merge both of them;
* The "Subject" column is added to train.data and test.data;
* The "ActivityID" column is added to train.data and test.data;
* The "ActivityLabel" column is added to train.data and test.data based on each observation's ActivityID;
* The train and test datasets are merged into the merged.data variable;
* Using "matchcols" from the "gdata" package, the script gets all columns related to standard deviation or mean values from the dataset and use it to create a new variable (tidy.data) which is also saved to "tidy_data.csv";
* Using "melt" from the "reshape2" package, the script reshapes the dataset, transforming what used to be columns into observations;
* Using "ddply" from the "plyr" package, the script summarizes the data values using averages and set them by activity and subject into a new variable (average.data), which is also saved to "average_data.csv". 