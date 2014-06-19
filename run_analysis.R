# Program to download and merge two data sets for the data science
# getting and cleaning data project.
#
# The output of this file will be a tidy dataset as defined by the
# criteria in the project brief
#
# Written by Dean Findlay 16/06/14 using R 3.0.3  - Windows

# Starts the program running
run_analysis <- function()
{

  # Checks to see if sqldf is installed and downloads and readies if not.
  suppressWarnings(
    if(require("sqldf")){
      print("sqldf is loaded correctly")
    } else {
      print("trying to install sqldf")
      install.packages("sqldf")
      if(require(sqldf)){
        print("sqldf installed and loaded")
      } else {
        stop("could not install sqldf")
      }
    })

  # Checks to see if reshape2 is installed and downloads and readies if not.
  suppressWarnings(
    if(require("reshape2")){
      print("reshape2 is loaded correctly")
    } else {
      print("trying to install reshape2")
      install.packages("reshape2")
      if(require(reshape2)){
        print("reshape2 installed and loaded")
      } else {
        stop("could not install reshape2")
      }
    })

  # Read all required tables into memory
  actLabs <- read.table("./UCI HAR Dataset/activity_labels.txt")
  featLabs <- read.table("./UCI HAR Dataset/features.txt")
  xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
  ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
  subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
  ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
  subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

  # merge the training dataset together
  trainMerge <- cbind(subtrain, ytrain, xtrain)

  # merge the test dataset together
  testMerge <- cbind( subtest, ytest, xtest)

  # Create a new data frame with training and test datasets in it
  fullMerge <- rbind(trainMerge, testMerge)

  # return a list of the row numbers from featLabs where the text
  # description in column 2 contains the word 'mean' or 'std'
  reqCols <- sqldf("select v1 from featLabs where v2 like \"%mean()%\" or v2 like \"%std()%\" ")
  # formats reqCols as a vector
  reqCols <- reqCols[,1]
  # a value of 2 is added to reqCols to create adjCols which takes into 
  # account the subject & activity columns in the first 2 columns of the dataset.
  adjCols <- reqCols + 2
  # adds the values 1 & 2 to the beginning of the adjCols so that 
  # the subject and activity data will also be extracted.
  adjCols <- c(1:2, adjCols)
  # Creates the newdf dataset containing only the required columns as set out by adjCols
  newdf <- fullMerge[,adjCols]


  # join the activity data from newdf to the activity description 
  # in actLabs and assigns it to the activity data in newdf
  newdf[,2] <- sqldf("select actLabs.v2 from newdf inner join actLabs on newdf.v1_1 = actLabs.v1")


  # use reqCols to return the descriptive names from featLabs.
  dfNames <- featLabs[featLabs[[1]] %in% reqCols, 2]
  # creates adjdfNames with "Subject" & "Activity" added to the front of dfNames
  adjdfNames <- c("Subject","Activity",as.vector(dfNames))  
  # replaces instances of "-" with "_"
  adjdfNames <- gsub("-", "_", adjdfNames)
  # removes instances of brackets
  adjdfNames <- gsub("\\(\\)", "", adjdfNames)  
  # uses adjdfNames to assign column names in newdf
  colnames(newdf) <- adjdfNames
  # writes the completed data frame to a text file called tidyData.txt
  write.table(newdf, "tidyData.txt", row.names=FALSE, quote=FALSE)  
  
  
  # return label names of the measure variables
  dfNames <- adjdfNames[3:length(adjdfNames)]  
  # melts the dataset into a tall skinny dataset based on the combination
  # of both id variables with the measure variables
  dfMelt <- melt(newdf, id=c("Subject","Activity"), measure.vars= dfNames)
  # casts the melted data to hold the mean of each measure variable
  # for each combination of subject and activity
  tidydf <- dcast(dfMelt, Subject + Activity ~ variable, mean)
  # return the header names for all of the 'measure' variables
  newHeads <- colnames(tidydf[,3:ncol(tidydf)])
  # concatenates "Mean_Of_" to the beginning of each of the returned values
  # in order to explicitly show the difference from the original variables
  newHeads <- paste0("Mean_of_", newHeads)
  # adds Subject and Activity to the beginning of the list
  newHeads <- c("Subject","Activity", newHeads)
  # reapplies the header names to the tidy dataset
  colnames(tidydf) <- newHeads
  write.table(tidydf, "tidyData2.txt", row.names=FALSE, quote=FALSE)
  newdf
}