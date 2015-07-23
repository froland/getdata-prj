require(dplyr)
require(reshape2)

features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, col.names = c("index", "label"))
features <- mutate(features, include = grepl(".*-mean\\(\\)", label) | grepl(".*-std\\(\\)", label), xlass = ifelse(include, "numeric", "NULL"))

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, col.names = c("id", "label"), colClasses = c("integer", "factor"))

merge_files <- function(filename_x, filename_y, filename_subjects) {
        file_set <- read.table(filename_x,  colClasses = features$xlass, col.names = features$label, stringsAsFactors = FALSE)
        file_subjects <- read.table(filename_subjects, stringsAsFactors = FALSE, col.names = c("subject"))
        file_labels <- read.table(filename_y, col.names = c("activity"), stringsAsFactors = FALSE)
        
        file_set <- cbind(activity_id = file_labels$activity, subject = file_subjects$subject, file_set)

        file_set %>%
                inner_join(activity_labels, by = c(activity_id = "id")) %>%
                rename(activity = label) %>%
                select(-activity_id)
}

training_set <- merge_files("UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt", "UCI HAR Dataset/train/subject_train.txt")
test_set <- merge_files("UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/test/subject_test.txt")
all_set <- rbind(training_set, test_set)
included_features <- filter(features, include)
melted_set <- melt(all_set, id = c("activity", "subject"), variable.name = "measure", value.name = "value")
by_activity_subject <- group_by(melted_set, activity, subject, measure)
summary_set <- summarise(by_activity_subject, mean(value))
write.table(summary_set, file = "summary.txt", row.names = FALSE)
