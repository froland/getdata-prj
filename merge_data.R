require(dplyr)
require(reshape2)

read_features <- function() {
        read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, col.names = c("index", "label"))
}

concatenate_sets <- function(features) {
        merge_files <- function(filename_x, filename_y, filename_subjects) {
                classes <- rep("numeric", length = nrow(features))
                file_set <- read.table(filename_x, col.names = features$label, colClasses = classes, stringsAsFactors = FALSE)
                file_subjects <- read.table(filename_subjects, stringsAsFactors = FALSE, col.names = c("subject"))
                file_labels <- read.table(filename_y, col.names = c("activity"), stringsAsFactors = FALSE)
                
                file_set <- cbind(activity_id = file_labels$activity, subject = file_subjects$subject, file_set)

                activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("id", "label"), colClasses = c("integer", "factor"), stringsAsFactors = FALSE)
                
                file_set %>%
                        inner_join(activity_labels, by = c(activity_id = "id")) %>%
                        rename(activity = label) %>%
                        select(-activity_id)
        }
        
        training_set <- merge_files("UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt", "UCI HAR Dataset/train/subject_train.txt")
        test_set <- merge_files("UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/test/subject_test.txt")
        rbind(training_set, test_set)
}

summarise_set <- function(to_summarise) {
        to_summarise %>%
                select(activity, subject, contains(".mean.."), contains(".std..")) %>%
                melt(id = c("activity", "subject")) %>%
                group_by(activity, subject, variable) %>%
                summarise(mean(value))
}

features <- read_features()
full_set <- concatenate_sets(features)
summary_set <- summarise_set(full_set)
write.table(summary_set, file = "summary.txt", row.names = FALSE)
