#Peer review assignment on course "Getting & cleaning Data"
#Project submitted by Andy Devos - 10/07/2016

#The script does the below steps as requested:
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names.
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#preparatory steps
#download data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip?accessType=DOWNLOAD"
download.file(fileUrl, destfile="./data/human_activity.zip", mode="wb") #, method="curl")

#data on features for training & test
trainingset <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/train/X_train.txt"))
testset <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/test/X_test.txt"))

#activity labels
trainingactivity <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/train/y_train.txt"))
testactivity <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/test/y_test.txt"))

#subject data
trainingsubject <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/train/subject_train.txt"))
testsubject <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/test/subject_test.txt"))


#check names of both sets & check whether the names are the same
names(trainingset)
names(testset)
sum(names(trainingset)==names(testset))==length(names(trainingset))
nrow(trainingset)
nrow(testset)
ncol(trainingset)==ncol(testset)
#add extra variable to indicate whether it's from the training or test set
trainingset$train_test <- "train"
testset$train_test <- "test"

str(trainingactivity)
str(testactivity)

str(trainingsubject)
str(testsubject)
table(trainingsubject)
table(testsubject)

#step1 - merge
#merge data (merge(all=TRUE) does not give the same result as rbind!!)
train_testset <- rbind(trainingset, testset)
nrow(train_testset)
ncol(train_testset)
head(train_testset$train_test)

#README <- read(unzip("./data/human_activity.zip", "UCI HAR Dataset/README.txt"))
#features_info <- read(unzip("./data/human_activity.zip", "UCI HAR Dataset/features_info.txt"))
features <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/features.txt"))
names(train_testset) <- features$V2 

#merge train & test files on activity & subject
train_testactivity <- rbind(trainingactivity, testactivity)
head(train_testactivity)
nrow(train_testactivity)
ncol(train_testactivity)

train_testsubject <- rbind(trainingsubject, testsubject)
head(train_testsubject)
nrow(train_testsubject)
ncol(train_testsubject)

#set names
names(train_testactivity) <- c("activity")
names(train_testsubject) <- c("subject")

#merge different files
subject_activity <- cbind(train_testsubject, train_testactivity)
all_data <- cbind(train_testset,subject_activity)
head(all_data)
nrow(all_data)
ncol(all_data)


#step2
#extract measurements on mean and std
varlistmean <- grep("*mean()", features$V2)
varliststd <- grep("*std()", features$V2)
features$V1[varlistmean]

data_means <- all_data[,varlistmean]
data_stdev <- all_data[,varliststd]
head(data_means,10)
head(data_stdev,10)
subset_data <- all_data[,c(features$V2[varlistmean], features$V2[varliststd], "activity", "subject")]
selectedcols <- c(as.character(features$V2[varlistmean]), as.character(features$V2[varliststd]), "activity", "subject")
#selectedcols
subset_data <- subset(all_data,select=selectedcols )


#step3
#descriptive activity names to name the activities
activity_labels <- read.table(unzip("./data/human_activity.zip", "UCI HAR Dataset/activity_labels.txt"))
head(activity_labels)
levels(activity_labels)
table(activity_labels)

#factor to get descriptive labels on activity
subset_data$activity_factor <- factor(subset_data$activity, levels=c(6,4,5,1,3,2), labels=c("LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"))
head(subset_data$activity,30)
head(subset_data$activity_factor,30)



#step4
#make the variable names clearer by replacing the abbreviations
names(subset_data)
names(subset_data) <- gsub("^t", "time", names(subset_data))
names(subset_data)  <- gsub("^f", "frequency", names(subset_data))
names(subset_data)  <- gsub("*Acc", "Acceleration", names(subset_data))
names(subset_data)  <- gsub("*Gyro", "Angularvelocity", names(subset_data))
names(subset_data)  <- gsub("*Jerk", "Jerksignal", names(subset_data))
names(subset_data)  <- gsub("*Mag", "Magnitude", names(subset_data))
names(subset_data)


#step5
#tidy data set
#make average by subject & activity
library(plyr)
table(subset_data$`timeBodyAcceleration-mean()-X`)
summarize(subset_data$`timeBodyAcceleration-mean()-X`)
#counts crossing subject & activity: xt_bysubject_activity <- xtabs( ~ subject + activity, data= subset_data)
xt_bysubject_activity <- aggregate( ~ subject + activity, data= subset_data, mean)
head(xt_bysubject_activity)
write.table( xt_bysubject_activity, file="./data/averages_bysubject_activity.txt", row_names=FALSE) #, row.names= TRUE, col.names=TRUE)

#code book
install.packages("memisc")
library("memisc")
codebook(subset_data)
codebook_bysubject_activity <- codebook(xt_bysubject_activity)
Write(codebook_bysubject_activity, file="./data/CodeBook.md")

