require(dplyr)
require(reshape2)

read_features <- function() {
        read.table("UCI HAR Dataset/features.txt", col.names = c("index", "label")) %>%
                filter(grepl("-(mean|std)\\(\\)", label))
}

concatenate_sets <- function(features) {
        merge_files <- function(filename_x, filename_y, filename_subjects) {
                file_set <- read.table(filename_x, stringsAsFactors = FALSE)[,features$index]
                names(file_set) <- features$label
                file_subjects <- read.table(filename_subjects, stringsAsFactors = FALSE, col.names = c("subject"))
                file_labels <- read.table(filename_y, col.names = c("activity"), stringsAsFactors = FALSE)
                
                file_set <- cbind(activity_id = file_labels$activity, subject = file_subjects$subject, file_set)

                activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("id", "label"), colClasses = c("integer", "factor"), stringsAsFactors = FALSE)
                
                file_set %>%
                        inner_join(activity_labels, by = c("activity_id" = "id")) %>%
                        select(-activity_id) %>%
                        rename(activity = label)
        }
        
        training_set <- merge_files("UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt", "UCI HAR Dataset/train/subject_train.txt")
        test_set <- merge_files("UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/test/subject_test.txt")
        rbind(training_set, test_set)
        training_set
}

summarise_set <- function(to_summarise) {
        to_summarise %>%
                melt(id = c("activity", "subject"), variable.name = "feature") %>%
                group_by(activity, subject, feature) %>%
                summarise(mean = mean(value))
}

features <- read_features()
full_set <- concatenate_sets(features)
summary_set <- summarise_set(full_set)
write.table(summary_set, file = "summary.txt", row.names = FALSE)
