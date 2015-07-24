Getting and cleaning data project
=================================

This is my submission for the project of the Coursera course Getting and
Cleaning Data by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD.

The course website is found on [Coursera](https://class.coursera.org/getdata-030).

File descriptions
-----------------

In this repository, you will find the following files:

 * get_data.R: Downloads the project data. After running this, you'll find the
   zip file "getdata-projectfiles-UCI HAR Dataset.zip" in the current folder.
 * run_analysis.R: This script analyses the raw data and create a new file
   "feature_means.txt" which contains the analysis results.
 * getdata-projectfiles-UCI HAR Dataset.zip: the [raw data file][1].
 * UCI HAR Dataset_info.txt: explanation of the raw data from
   getdata-projectfiles-UCI HAR Dataset.zip
 * features_means.txt: the result of running the analyse_data.R script on the
   data obtained with the get_data.R script. This is the wide form as mentioned
   in the rubric as either long or wide form is acceptable, see 
   https://class.coursera.org/getdata-030/forum/thread?thread_id=107 for 
   discussion.
 * feature_means_info.md: the codebook explaining the content and structure
   of the feature_means.txt file.
   
Reading feature_means.txt
-------------------------

You can read the feature_means.txt file with the following R snippet.

```{r}
data_filename <- "feature_means.txt"
data <- read.table(data_filename, header = TRUE)
View(data)
```

License
-------

Use of the raw dataset in publications must be acknowledged by referencing the [following publication][1] 

[1]: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
