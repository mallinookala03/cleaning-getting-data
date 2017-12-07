## STEP 1: Merges the training and the test sets to create one data set

# 1.1 Reading files

# 1.1.1 Reading trainings tables:

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


# 1.1.2 Reading testing tables:

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


# 1.1.3 Reading feature vector:

features <- read.table('./UCI HAR Dataset/features.txt')



# 1.2 Assigning column names:

colnames(x_train) <- features$V2
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"


colnames(x_test) <- features$V2
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"



# 1.3 Merging all data in one set:

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)



## STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

# 2.1 determine which columns contain "mean()" or "std()"
meanstdcols <- grepl("mean\\(\\)", colnames(setAllInOne)) |
    grepl("std\\(\\)", colnames(setAllInOne))

# 2.2 ensure that we also keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# 2.3 remove unnecessary columns
setAllInOne <- setAllInOne[, meanstdcols]


## STEP 3: Uses descriptive activity names to name the activities in the data set.
## STEP 4: Appropriately labels the data set with descriptive activity names. 

# convert the activityId column from integer to factor
setAllInOne$activityId <- factor(setAllInOne$activityId, labels=c("Walking",
    "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


## STEP 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 5.1 create the tidy data set
melted <- melt(setAllInOne, id=c("subjectId","activityId"))
tidy <- dcast(melted, subjectId+activityId ~ variable, mean)

# 5.2 write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)


