##Getting and Cleaning Data -- Course Project: run_analysis.R
##
##This script does the following:
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names. 
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Check for an existing "data" directory
if(!file.exists("./data")){dir.create("./data")}


## Define the location of the data to be downloaded
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


## Download the zip file into the created folder, then extract the files
download.file(fileURL, destfile="./data/humanactivity.zip")
unzip(".//data/humanactivity.zip", exdir=".//data")


## Read in the 'test' (30% of subjects) and 'train' (70% of subjects) datasets
test.data <- read.table(".//data/UCI HAR Dataset/test/X_test.txt")         ## Observations for the test subjects
train.data <- read.table(".//data/UCI HAR Dataset/train/X_train.txt")      ## Observations for the training subjects
test.activ <- read.table(".//data/UCI HAR Dataset/test/y_test.txt")        ## Activities performed by test subjects
train.activ <- read.table(".//data/UCI HAR Dataset/train/y_train.txt")     ## Activities performed by the training subjects
features <- read.table(".//data/UCI HAR Dataset/features.txt",
                       stringsAsFactors = F)                               ## Names of measurements (dataset column names)
test.sub <- read.table(".//data/UCI HAR Dataset/test/subject_test.txt")    ## Subject ID for the test subjects
train.sub <- read.table(".//data/UCI HAR Dataset/train/subject_train.txt") ## Subject ID for the training subjects


## Bind the activity data to the observational data
if(identical(nrow(test.data), nrow(test.activ), nrow(test.sub)) == TRUE){  ## If an equal number of rows, then
        test_activ_sub.data <- cbind(test.data, test.activ, test.sub)      ## Append the activity, subject ID
        rm(test.data); rm(test.activ); rm(test.sub)                        ## Remove the old data tables
} else {                                                                   ## If NOT an equal number of rows,
        print("Rows Not Equal")                                            ## Throw an error
}

if(identical(nrow(train.data), nrow(train.activ), nrow(train.sub)) == TRUE){  ## If an equal number of rows, then
        train_activ_sub.data <- cbind(train.data, train.activ, train.sub)     ## Append the activity
        rm(train.data); rm(train.activ); rm(train.sub)                        ## Remove the old data tables
} else {                                                                      ## If NOT an equal number of rows,
        print("Rows Not Equal")                                               ## Throw an error
}


## Bind the test_activ_sub.data and train_activ_sub.data datasets and rename the columns
if(identical(names(test_activ_sub.data), names(train_activ_sub.data)) == TRUE){  ## If an equal number of cols, then
        all.data <- rbind(test_activ_sub.data, train_activ_sub.data)             ## Bind the datasets together
        rm(test_activ_sub.data); rm(train_activ_sub.data)                        ## Remove the old data tables
} else {                                                                         ## If NOT an equal number of rows,
        print("Columns Not Equal")                                               ## Throw an error
}

features[562,] <- c(562, "activity")    ## Add a name to the activity column previously added
features[563,] <- c(563, "subject_id")  ## Add a name to the subject column previously added
names(all.data) <- features$V2          ## Rename the columns
rm(features)


## Keep only the columns with mean or standard deviation measurements
mean.sd <- which(grepl("mean()", colnames(all.data), fixed = T) == TRUE | 
                 grepl("std()", colnames(all.data), fixed = T) == TRUE | 
                 grepl("activity", colnames(all.data), fixed = T) == TRUE | 
                 grepl("subject_id", colnames(all.data), fixed = T) == TRUE)
all.data <- all.data[, mean.sd]


## Change activities from numbers to descriptive names
all.data$activity[all.data$activity ==1] <- "WALKING"
all.data$activity[all.data$activity ==2] <- "WALKING_UPSTAIRS"
all.data$activity[all.data$activity ==3] <- "WALKING_DOWNSTAIRS"
all.data$activity[all.data$activity ==4] <- "SITTING"
all.data$activity[all.data$activity ==5] <- "STANDING"
all.data$activity[all.data$activity ==6] <- "LAYING"

## Create a tidy data set with the average of each variable for each subject
tidy.data <- all.data %>% group_by(subject_id, activity) %>% summarise_each(funs(mean))
rm(all.data)

## Write the newly created tidy data set to the working directory
write.table(tidy.data, file = "tidy_data.txt", row.names = F)