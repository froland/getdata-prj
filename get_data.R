url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "getdata-projectfiles-UCI HAR Dataset.zip"
download.file(url, zipFile, mode = "wb")
unzip(zipFile)
