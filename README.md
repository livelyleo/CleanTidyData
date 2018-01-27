# CleanTidyData
Getting And Cleaning Data Course Assignment Week 4

## Details of the process to obtain tidy data set

- Download the zip files in the working directory
- Unzip all the files using 'unzip' function
- load 'reshape2' and 'data.table' libraries in the workspace
- Download the activity and feature info in appropriate variables
- Select only the mean and std measurements from the complete data set and store the vector in 'measurements' variable.
- Download the training data set and perform gsub, grep functions to identify and clean the variable names which correspond to different measurement types.
- Combine the data from the activities and subject files to the final train data set
- Repeat the process for test data set as well
- Combine both train and test data sets into one 'mergedata' data frame
- Use melt and dcast functions from reshape2 library to arrange the data according to the subject and activity type for each subject
- This is a tidy data set
- Write the tidy data set into final text file 'tidydata.txt'
