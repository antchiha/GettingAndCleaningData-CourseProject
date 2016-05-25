# Getting And Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Load the activity and feature info from downloaded data-set
2. Loads both the training and test datasets
3. Loads the activity and subject data for each dataset, and merges those
   columns with the dataset
4. Merges the two traning and testdatasets
5. Keep only those columns which reflect a mean or standard deviation
6. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair.

The end result is shown in the file `tidyData.txt`.
