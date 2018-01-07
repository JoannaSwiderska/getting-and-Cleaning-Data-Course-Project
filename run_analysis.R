library(plyr)

## 1.Merge the training and the test sets to create one data set

#Loading data files
x_train <- read.table("train/X_train.txt")
str(x_train)
y_train <- read.table("train/y_train.txt")
str(y_train)
subject_train <- read.table("train/subject_train.txt")
str(subject_train)

x_test <- read.table("test/X_test.txt")
str(x_test)
y_test <- read.table("test/y_test.txt")
str(y_test)
subject_test <- read.table("test/subject_test.txt")
str(subject_test)

# Creating x,y and subject data sets
x_data <- rbind(x_train, x_test)
str(x_data)
y_data <- rbind(y_train, y_test)
str(y_data)
subject_data <- rbind(subject_train, subject_test)
str(subject_data)


## 2.Extract only the measurements on the mean and standard deviation for each measurement.

# Loading features
features <- read.table("features.txt")
str(features)

# improve feature names ...
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])
# and get only the data with mean and std dev information
mean_std_features <- grep(".*Mean.*|.*Std.*", features[,2])

# subset x_data with feature indexes hat inclides mean and std dev
x_data <- x_data[, mean_std_features]


## 3.Use descriptive activity names to name the activities in the data set

# Loading activity labels
activities <- read.table("activity_labels.txt")
str(activities)

# replace values in y_data with proper activity names 
# and change column name
y_data[, 1] <- activities[y_data[, 1], 2]


## 4. Appropriately label the data set with descriptive variable names
# change column names
names(x_data) <- features[mean_std_features, 2]
names(y_data) <- "activity"
names(subject_data) <- "subject"


## 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

#Combine all the data sets into one
all_data <- cbind(x_data, y_data, subject_data)
str(all_data)

# Create new data set with the average of each variable
# counted for each activity and subject:
# * Split data frame by activity and subject
# * apply mean function for first 86 col
# * and return results in a data frame
tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:86]))
str(tidy_data)

# save the results
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
