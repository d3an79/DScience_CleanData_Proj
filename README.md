DScience_CleanData_Proj
=======================

This is the course project for the getting and cleaning data module in the data scientists toolbox specialisation on Coursera by Johns Hopkins Bloomberg School of public health

An outline of the tasks can be seen below taken directly from the project assignment page.

"The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
Good luck!"


This directory contains:
------------------------

A codebook detailing the variables used in the resluting tify dataset.  
the sript 'run_analysis.R' which will produce two txt datasets.

Additional txt files contained in the unzipped data are also included.

"UCI_HAR_Dataset_README.txt" gives details on the trial undertaken and some of the files found in the unzipped data.  
"features_info.txt" outlines the variables used in the origional data


The script was written on 16/06/14 using R 3.0.3 for Windows and can be with the following steps:  
load the script into R  
Ensure the working directory for R contains the unzipped UCI_HAR_Dataset  
Type 'run_analysis()'

This will create two datasets:  
tidyData.txt which is the merged and labeled test and train datasets.  
tidyData2.txt which contains the tidy dataset as outlined by the course project.

If the merged train and test dataset is required to be loaded into memory then  
the following command can be used:  
dFrame <- run_analysis()

Otherwise either dataset can be read with the command  
dFrame <- read.table("tidyData.txt", header=TRUE)  
Or  
dFrame <- read.table("tidyData2.txt", header=TRUE)  

