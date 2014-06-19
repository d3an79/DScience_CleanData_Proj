DScience_CleanData_Proj - Codebook
==================================

Information on the origional data
=================================

The origional dataset was obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


Details on the origional variables are given below taken directly from the "features_info.txt" file found in the unzipped dataset.

"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean"

Further information on the files in the dataset can be found from the "README.txt" file found in the unzipped dataset

"- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1]."





How was the data manipulated
============================

The following steps outline the process that the run_analysis.R script undertakes in order to produce the tidydataset.

prerequisites - The run_analysis.R script will test for "sqldf" and "reshape2" and load them if they are not present. If these steps are being
completed manually then it will be necessary to run install.packages("desiredPackage") and library(desiredPackage).

Join the test and train datasets together
-----------------------------------------

1). Read the required files into memory
		actLabs <- read.table("./UCI HAR Dataset/activity_labels.txt")
		featLabs <- read.table("./UCI HAR Dataset/features.txt")
		xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
		ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
		subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
		xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
		ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
		subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")  
2). Add the corresponding subject and activity data to the training dataset
		trainMerge <- cbind(subtrain, ytrain, xtrain)
3). Add the corresponding subject and activity data to the test dataset
		testMerge <- cbind( subtest, ytest, xtest)
4). Create a dataframe containing both datasets
		fullMerge <- rbind(trainMerge, testMerge)
	
Extract only the mesurements on the mean and standard deviation for each measurement
------------------------------------------------------------------------------------
	
5). Return from the features labels the positions of all the variables that end in mean() or std(). This ensures that
    all 33 measurement variables have only their relating mean and std values. This process also disregards the 
	additional vectors that where obtained by averaging the signals in a signal window sample.
		reqCols <- sqldf("select v1 from featLabs where v2 like \"%mean()%\" or v2 like \"%std()%\" ")
6). Format the returned positions as a vector
		reqCols <- reqCols[,1]
7). Add 2 to the value of each position to account for the subject and activity columns joined at the beginning of the dataset.
		adjCols <- reqCols + 2
8). Add the values 1 & 2 to the vector to ensure that the subject and activity columns will also be extracted.
		adjCols <- c(1:2, adjCols)
9). Create a new data frame containing only the required data.
		newdf <- fullMerge[,adjCols]
		
Use descriptive activity names to name the activities in the data set
---------------------------------------------------------------------

10). use sqldf to join the activity data from newdf to the activity description in actLabs and assigns it to the activity column in newdf.
		newdf[,2] <- sqldf("select actLabs.v2 from newdf inner join actLabs on newdf.v1_1 = actLabs.v1")
		
Appropriately label the data set with descriptive variable names
-----------------------------------------------------------------

11). Use the position numbers of the required variables in the features labels (created in step 5) to return the descriptive variable names.
		dfNames <- featLabs[featLabs[[1]] %in% reqCols, 2]
12). Create a new vector of labels with Subject and Activity added to the beginning of it.
		adjdfNames <- c("Subject","Activity",as.vector(dfNames))
13). Replace instances of "-" with "_".
		adjdfNames <- gsub("-", "_", adjdfNames)
14). Remove any instances of brackets from the labels.
		adjdfNames <- gsub("\\(\\)", "", adjdfNames)
15). Assign the new label names to the data frame.
		colnames(newdf) <- adjdfNames
16). Write a copy of the merged and labelled data frame to a text file.
		write.table(newdf, "tidyData.txt", row.names=FALSE, quote=FALSE) 
		
Create a second, independent tidy data set with the average of each variable for each activity and each subject
---------------------------------------------------------------------------------------------------------------

17). Return label names of the measure variables
		dfNames <- adjdfNames[3:length(adjdfNames)]
18). 'Melts' the dataset into a tall skinny dataset based on the combination of both id variables with the measure variables
		dfMelt <- melt(newdf, id=c("Subject","Activity"), measure.vars= dfNames)
19). Casts the melted data to hold the mean of each measure variable for each combination of subject and activity
		tidydf <- dcast(dfMelt, Subject + Activity ~ variable, mean)
20). Return the header names for all of the 'measure' variables
		newHeads <- colnames(tidydf[,3:ncol(tidydf)])
21). Concatenates "Mean_Of_" to the beginning of each of the returned values in order to explicitly show the difference from the original variables
		newHeads <- paste0("Mean_of_", newHeads)
22). Adds Subject and Activity to the beginning of the list
		newHeads <- c("Subject","Activity", newHeads)
23). Reapplies the header names to the tidy dataset
		colnames(tidydf) <- newHeads
24). Write the completed tidy dataset to a text file.
		write.table(tidydf, "tidyData2.txt", row.names=FALSE, quote=FALSE)

		
variable names
==============

Variables 1 & 2 are text variables that give details on the subject id of the participant and the activity that they where undertaking.

The following 66 variables are the mean values of the origional dataset values (as detailed at the beginning of this document)
that pertain to the mean and standard deviation values.

All of the variable names for the means have had "Mean_of_" appended to the beginning of them in order to differentiate them from the origional values

01 Subject
02 Activity
03 Mean_of_tBodyAcc_mean_X
04 Mean_of_tBodyAcc_mean_Y
05 Mean_of_tBodyAcc_mean_Z
06 Mean_of_tBodyAcc_std_X
07 Mean_of_tBodyAcc_std_Y
08 Mean_of_tBodyAcc_std_Z
09 Mean_of_tGravityAcc_mean_X
10 Mean_of_tGravityAcc_mean_Y
11 Mean_of_tGravityAcc_mean_Z
12 Mean_of_tGravityAcc_std_X
13 Mean_of_tGravityAcc_std_Y
14 Mean_of_tGravityAcc_std_Z
15 Mean_of_tBodyAccJerk_mean_X
16 Mean_of_tBodyAccJerk_mean_Y
17 Mean_of_tBodyAccJerk_mean_Z
18 Mean_of_tBodyAccJerk_std_X
19 Mean_of_tBodyAccJerk_std_Y
20 Mean_of_tBodyAccJerk_std_Z
21 Mean_of_tBodyGyro_mean_X
22 Mean_of_tBodyGyro_mean_Y
23 Mean_of_tBodyGyro_mean_Z
24 Mean_of_tBodyGyro_std_X
25 Mean_of_tBodyGyro_std_Y
26 Mean_of_tBodyGyro_std_Z
27 Mean_of_tBodyGyroJerk_mean_X
28 Mean_of_tBodyGyroJerk_mean_Y
29 Mean_of_tBodyGyroJerk_mean_Z
30 Mean_of_tBodyGyroJerk_std_X
31 Mean_of_tBodyGyroJerk_std_Y
32 Mean_of_tBodyGyroJerk_std_Z
33 Mean_of_tBodyAccMag_mean
34 Mean_of_tBodyAccMag_std
35 Mean_of_tGravityAccMag_mean
36 Mean_of_tGravityAccMag_std
37 Mean_of_tBodyAccJerkMag_mean
38 Mean_of_tBodyAccJerkMag_std
39 Mean_of_tBodyGyroMag_mean
40 Mean_of_tBodyGyroMag_std
41 Mean_of_tBodyGyroJerkMag_mean
42 Mean_of_tBodyGyroJerkMag_std
43 Mean_of_fBodyAcc_mean_X
44 Mean_of_fBodyAcc_mean_Y
45 Mean_of_fBodyAcc_mean_Z
46 Mean_of_fBodyAcc_std_X
47 Mean_of_fBodyAcc_std_Y
48 Mean_of_fBodyAcc_std_Z
49 Mean_of_fBodyAccJerk_mean_X
50 Mean_of_fBodyAccJerk_mean_Y
51 Mean_of_fBodyAccJerk_mean_Z
52 Mean_of_fBodyAccJerk_std_X
53 Mean_of_fBodyAccJerk_std_Y
54 Mean_of_fBodyAccJerk_std_Z
55 Mean_of_fBodyGyro_mean_X
56 Mean_of_fBodyGyro_mean_Y
57 Mean_of_fBodyGyro_mean_Z
58 Mean_of_fBodyGyro_std_X
59 Mean_of_fBodyGyro_std_Y
60 Mean_of_fBodyGyro_std_Z
61 Mean_of_fBodyAccMag_mean
62 Mean_of_fBodyAccMag_std
63 Mean_of_fBodyBodyAccJerkMag_mean
64 Mean_of_fBodyBodyAccJerkMag_std
65 Mean_of_fBodyBodyGyroMag_mean
66 Mean_of_fBodyBodyGyroMag_std
67 Mean_of_fBodyBodyGyroJerkMag_mean
68 Mean_of_fBodyBodyGyroJerkMag_std