This is the repo for the Getting and Cleaning Data Course Project

It contains three files:

1. README.md: a description of the repo
2. run_analysis.R: an R script for reading, merging, and cleaning a set of data, and creating a tidy data set 
3. CodeBook.md: a codebook describing the data that can be found in the output of run_analysis.R, tidy_data.txt


This script does the following:

 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names.
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The comments from the script are below. If necessary, a more detailed explanation for the steps taken is provided.


####Check for an existing "data" directory

#### Define the location of the data to be downloaded

#### Download the zip file into the created folder, then extract the files

#### Read in the 'test' (30% of subjects) and 'train' (70% of subjects) datasets

 - The dataset had been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
 - For each group, there were 4 separate pieces of information that needed to be merged:
  - The measured data (X\_test.txt and X\_train.txt)
  - The labels that corresponded to the column names (y\_test.txt and y\_train.txt)
  - The activities that were performed by the subjects (features.txt)
  - The subject ID (subject\_test.txt and subject\_train.txt)
 - The data was loaded in to 7 separate data frames
  - test.data <- X\_test.txt
  - train.data <- X\_train.txt
  - test.activ <- y\_test.txt
  - train.activ <- y\_train.txt
  - features <- features.txt
  - test.sub <- subject\_test.txt
  - train.sub <- subject\_train.txt

#### Bind the activity data to the observational data
 - Before appending the activity and subject ID data to the test/train measurements, to ensure data quality, a check was done to ensure all files had the same number of observations. If not an error would be thrown.
 - If all files contained the same number of observations, the three data frames were bound together
 - To keep space free, upon binding, the old data frames were removed
 - The two new data frames were test\_activ\_sub.data and train\_activ\_sub.data

#### Bind the test\_activ\_sub.data and train\_activ\_sub.data datasets and rename the columns
 - Before merging the complete test and train datasets, to ensure data quality, a check was done to ensure both files had the same number of columns. If not an error would be thrown.
  - If both files contained the same number of columns, the data frames were bound together
 - To keep space free, upon binding, the old data frames were removed
 - The new data frame was all.data
 - Before changing the column names in all.data to the labels in features.txt, the two additional columns that were added to the measured data (activity and subject ID) needed to be handled
  - Two rows were added to the bottom of features.txt: "activity" and "subject_id"
 - Finally, the column names is all.data were replaced by the information in features
 - To keep space free, features was removed

#### Keep only the columns with mean or standard deviation measurements
 - An index was created which identified the columns which contained:
  - Mean caluculations
  - Standard deviation calculations
  - The activity and subject_id variables
 - The data was the subsetted based on that index to keep only the desired data

#### Change activities from numbers to descriptive names
- Activity codes (e.g. 1, 2, 3, etc.) were changed to descriptive names (e.g. Walking, Walking Upstairs, Walking Downstairs, etc.

#### Create a tidy data set with the average of each variable for each subject
- Now that the data had been organized, the means of each measure by activity and subject could be quickly determined

#### Write the newly created tidy data set to a .txt file in the working directory