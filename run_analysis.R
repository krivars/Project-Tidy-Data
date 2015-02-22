# This script reads data collected from accelerators from the Samsung Galaxy S smartphone.
# The input data is divided in test and training data, and the measurements are separate from the 
# test subject id and the id of the activity measured. The goal of this script is therefore to 
# put together all the data of the training and the test sets into one tidy dataset.

# Read in test data, which is split into measurements, activities and subject ids.
testDataMeasures <-  read.table("./UCI HAR Dataset/test/X_test.txt")
testDataActivity <-  read.table("./UCI HAR Dataset/test/y_test.txt")
testSubject <-  read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read in training data
trainingDataMeasures <-  read.table("./UCI HAR Dataset/train/X_train.txt")
trainingDataActivity <-  read.table("./UCI HAR Dataset/train/y_train.txt")
trainingSubject <-  read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read in column names from the features file provided
colNames <- read.table("./UCI HAR Dataset/features.txt")

# Read in labels for the six activites tested 
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Put together subject ids, activities and measurements for test data
testData <- cbind(testSubject,testDataActivity,testDataMeasures)
# Put together subject ids, activities and measurements for training data
trainingData <-cbind(trainingSubject,trainingDataActivity,trainingDataMeasures)
# Put together test and training data
mergedData <- rbind(testData,trainingData)
# Name the two first columns subjectid and activity and the rest according to the names from the features file
names(mergedData) <- c("subjectid","activity",as.character(colNames[,2]))

# Find and extract only columns which are mean() and std() of measures.
# Measures for meanFreq() or averages related to angles are not included.
actualCol <- c(1,2,grep(".*(mean\\(\\)|std\\(\\)).*",names(mergedData)))
# Extract only these columns and create a new dataframe
actualData <- mergedData[,actualCol]
# Remove illegal characters (, ) and -
names(actualData) <- gsub("\\(|\\)|-","",names(actualData))

# Make the columns for activities into factors so they are more descriptive
f <- factor(actualData[,2],activityLabels[,1],activityLabels[,2])
actualData[,2] <- f

# Group the data according to subjectid and activity, to make it ready for averaging over these groups
meltedData <- melt(actualData, id=c("subjectid","activity"))
# Calculate the average of each measurements in each group (subjectid,activity)
castedData <- dcast(meltedData, subjectid + activity ~ variable, mean)

# Write the result to a txt.file, including column names, excluding row names.
write.table(castedData,"./tidydataset.txt",row.names=FALSE)