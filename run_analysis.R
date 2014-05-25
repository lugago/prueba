# FIRST TIDY DATA SET

# Set the working directory for "train"
setwd("C:/Users/oscar/Documents/project/train")
# Read set, label and subject for train as tables
train.set <- read.table("X_train.txt")
train.label <- read.table("y_train.txt")
table(train.label)
train.subject <- read.table("subject_train.txt")
# Set the working directory for "test"
setwd("C:/Users/oscar/Documents/project/test")
# Read set, label and subject for test as tables
test.set <- read.table("X_test.txt")
test.label <- read.table("y_test.txt") 
table(test.label) 
test.subject <- read.table("subject_test.txt")
# Merge train and test data sets
merge.set <- rbind(train.set, test.set)
# Merge train and test labels
merge.label <- rbind(train.label, test.label)
# Merge train and test subjects
merge.subject <- rbind(train.subject, test.subject)

# Set working directory for "feautres"
setwd("C:/Users/oscar/Documents/project")
# Read "features"
features <- read.table("features.txt")
# Use regular expressions to get only mean and std from "features"
only.mean.std <- grep("mean\\(\\)|std\\(\\)", features[, 2])
length(only.mean.std) 
# Subset merge.set with mean and std from only.mean.std
merge.set2 <- merge.set[, only.mean.std]
dim(merge.set2) 
# Add column names from "features" to merge.set2 
names(merge.set2) <- features[only.mean.std, 2]

# Set working directory for "activity_labels"
setwd("C:/Users/oscar/Documents/project")
# Read "activity_labels"
activity.label <- read.table("activity_labels.txt")
# Get all the activity labels linked with merge.label values
activity.label2 <- activity.label[merge.label[, 1], 2]
# Set all the activity labels from activity.label2 in merge.label
merge.label[, 1] <- activity.label2
# Add column name "activity" to merge.label
names(merge.label) <- "activity"

# Add column name "subject" to merge.subject
names(merge.subject) <- "subject"
# Merge merge.subject, merge.label and merge.set2 into tidy
tidy <- cbind(merge.subject, merge.label, merge.set2)
dim(tidy) 
# Write the first tidy data set
write.table(tidy, "tidy_data_set.txt") 

# SECOND TIDY DATA SET (AVERAGE FOR EACH VARIABLE, ACTIVITY AND SUBJECT)

# Use ddply to get the mean of each column grouped by "subject" and "activity"
# into tidy2
# Requires plyr package
tidy2 <- ddply(.data = tidy, 
               .variables = c("subject","activity"), 
                .fun = function(x) colMeans(x[,3:68]))
# Write the second tidy data set
write.table(tidy2, "means_tidy.txt") # write out the 2nd dataset
