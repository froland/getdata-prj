require(dplyr)

#############
# Functions #
#############

#
# Concatenate the training and test data sets into a tidy data.frame.
#
concatenate_sets <- function(features, activities) {
        #
        # Reads features from the file "UCI HAR Dataset/features.txt" and filters only 
        # the desired feature names.
        #
        # Returns a data.frame with columns:
        #  * index: the position of that feature in the 561-feature vector
        #  * label: the label of that feature
        #
        read_features <- function() {
                read.table("UCI HAR Dataset/features.txt",
                           col.names = c("index", "label")) %>%
                        filter(grepl("-(mean|std)\\(\\)", label))
        }
        
        #
        # Reads the activities from file "UCI HAR Dataset/activity_labels.txt".
        #
        # Returns a data.frame with columns:
        #  * id: the activity identifier
        #  * label: the label of that activity
        #
        read_activities <- function() {
                read.table("UCI HAR Dataset/activity_labels.txt",
                           col.names = c("id", "label"),
                           colClasses = c("integer", "factor"))
        }

        #
        # Merges the files with feature vector values, activity ids and subjects
        # into a single data.frame.
        #
        # Returns a data.frame with columns:
        #  * activity: the activity label
        #  * subject: the subject identifier
        #  * ...: one column per selected feature with the label as given in the
        #         features data.frame
        #
        merge_files <- function(filename_x, filename_y, filename_subjects) {
                # Read the file containing the feature vector values
                file_set <- read.table(
                        filename_x,
                        stringsAsFactors = FALSE)
                # Reduces the data.frame to only the desired features
                file_set <- file_set[,features$index]
                # Rename columns with the feature labels
                names(file_set) <- features$label

                # Read the subject ids
                file_subjects <- read.table(
                        filename_subjects,
                        stringsAsFactors = FALSE,
                        col.names = c("subject"))
                
                # Read the activity ids
                file_activities <- read.table(
                        filename_y,
                        col.names = c("activity"),
                        stringsAsFactors = FALSE)
                
                # Combine the columns of the former data.frames
                file_set <- cbind(
                        activity_id = file_activities$activity,
                        subject = file_subjects$subject,
                        file_set)

                # Replace the activity_id column by the activity label
                file_set %>%
                        inner_join(activities, by = c("activity_id" = "id")) %>%
                        select(-activity_id) %>%
                        rename(activity = label)
        }

        features <- read_features()
        activities <- read_activities()
        # Read training data
        training_set <- merge_files("UCI HAR Dataset/train/X_train.txt",
                                    "UCI HAR Dataset/train/y_train.txt",
                                    "UCI HAR Dataset/train/subject_train.txt")
        # Read test data
        test_set <- merge_files("UCI HAR Dataset/test/X_test.txt",
                                "UCI HAR Dataset/test/y_test.txt",
                                "UCI HAR Dataset/test/subject_test.txt")
        # Combine rows of the former data.frames
        rbind(training_set, test_set)
}

#
# For each activity, for each subject, computes the mean of the feature vector
# values.
#
summarise_set <- function(to_summarise) {
        to_summarise %>%
                group_by(activity, subject) %>%
                summarise_each(funs(mean))
}

#############
# MAIN PART #
#############

# Gather all data together and make them prettier
full_set <- concatenate_sets(features, activities)
# Compute the means by activity, by subject
summary_set <- summarise_set(full_set)
# Write the result in a flat file called "summary.txt"
write.table(summary_set, file = "summary.txt", row.names = FALSE)
