
# README file for Getting and Cleaning Data Course Project
Suman Mann
December 12, 2018

# Introduction
This README file explains how the script run_nalysis.R works.  The aim here is to document the crucial parts of the script, not to detail every aspect of it.


## What the Script Aims to Do
The script run_analysis.R takes in the given source files from a zip file and finally converts the data into tidy format.  The messy data is ingested and tidy data file is the ultimate output of the script. As we can see, the main two files for training and test data sets have 561 columns each to begin with, along with some smaller files.   Having such a large number of columns in a table is not a problem, by itself; however, the main problem here is that each observation is spread out in many columns, i.e., data  is "messy". Having messy data means that data is not in a format that is easy to analyze: hence the need to convert it to the tidy data format, to make analysis either possible or easy.

According to *The Elements of Data Analytic Style: A guide for people who want to analyze data* by Jeff Leek, the point of creating a tidy data set is to get the data into a format that can be easily shared, computed on, and analyzed. The four general principles of tidy data are:
- Each variable you measure should be in one column
- Each different observation of that variable should be in a different row
- There should be one table for each “kind” of variable
- If you have multiple tables, they should include a column in the table that allows them to be linked

So the main objective of this exercise is to convert the given messy data into tidy data. 

## Libraries Needed
Only the dplyr package is needed for this script.

## Source of Dataset
The raw source material used was obtained from the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## How the Script Ingests Source Files and Conevrts Data into Tidy Format
Basic description of the data files is given below.  The CodeBook.md file gives much more details about the data and transformations.

- README.txt: Introdoction of the Human Activity Recognition Using Smartphones Dataset.

- features_info.txt: Shows information about (or, meaning of) the variables used on the feature vector in features.txt.

- features.txt: List of all features. List of 561 different features.

- activity_labels.txt: Links the class labels with their activity name.

- train/X_train.txt: Training set. 7352 observations of 561 variables.

- train/y_train.txt: Training labels for 7352 observations.

- test/X_test.txt: Test set.  2947 observations of 561 variables.

- test/y_test.txt: Test labels for 2947 observations.


Please kindly note that in showing the steps below only the important parts of the codes are shown.  For details, please refer directly to run_analysis.R.

### Step 1
Step 1 merges the training and the test sets to create one data set.  Training data and test data are first go through column binding and then the resulting tables are combined to produce a new table called phone.

```
train <- cbind(train_X, train_y, train_subject)
test <- cbind(test_X, test_y, test_subject)
phone <- rbind(train, test)
```

The phone dataframe has 10299 observations of 564 variables.

### Step 2
Step 2 extracts only the measurements on the mean and standard deviation for each measurement.

A boolean vector called columns_to_keep is consructed to keep only the fields that match mean|std|subject|activity_id.
Then a new table called canonical.phone is extracted out of it.

```
canonical.phone <- phone[, columns_to_keep]
```

canonical.phone has 10299 observations of 69 variables.

### Step 3
Step 3 uses descriptive activity names to name the activities in the data set. And columns are re-arranged in preparation for data gathering.

```
canonical.phone <- tbl_df(canonical.phone)
canonical.phone <- inner_join(canonical.phone, activity_labels)

canonical.phone <- tbl_df(canonical.phone)
canonical.phone <- inner_join(canonical.phone, activity_labels)
canonical.phone <- canonical.phone[,c(67,69,68, 1:66)]
```


### Step 4
Step 4 appropriately labels the data set with descriptive variable names.

```
temp.colnames <- names(canonical.phone)

temp.colnames <- str_replace_all(temp.colnames, "Acc", "-acceleration-")
temp.colnames <- str_replace_all(temp.colnames, "Gyro", "-gyroscope-")
temp.colnames <- str_replace_all(temp.colnames, "Mag", "-magnitude")
temp.colnames <- str_replace_all(temp.colnames, "\\(\\)", "")
temp.colnames <- str_replace_all(temp.colnames, "^t", "time-")
temp.colnames <- str_replace_all(temp.colnames, "^f", "frequency-")
temp.colnames <- str_replace_all(temp.colnames, "tBody", "time-body-")
temp.colnames <- str_replace_all(temp.colnames, "BodyBody", "body")
temp.colnames <- str_replace_all(temp.colnames, "--", "-")


names(canonical.phone) <- temp.colnames
```

### Step 5
In Step 5, from the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Substeps are
- Take the canonical.phone table and collapse columns into key-value pairs.  
- Aggregate the data, order the columns and order the rows.

```
tidy.phone <- canonical.phone %>% gather(sensor, value, 4:69)


tidy.phone <- aggregate(value ~ sensor + activity + subject, data=tidy.phone,
                   mean, na.rm=TRUE) %>%
  select(activity, subject, sensor, value) %>%
  group_by(subject, activity, sensor)
```

The final output is the tidy.phone table

The first three entries of the table is shown below to giove the reader a feel for what it looks like.

```
> head(tidy.phone,3)
# A tibble: 3 x 4
# Groups:   subject, activity, sensor [3]
  activity subject sensor                                           value
  <fct>      <int> <chr>                                            <dbl>
1 LAYING         1 frequency-body-acceleration-jerk-magnitude-mean -0.933
2 LAYING         1 frequency-body-acceleration-jerk-magnitude-std  -0.922
3 LAYING         1 frequency-body-acceleration-jerk-mean-x         -0.957
```

As we can see, all features and measurements have been now gathered into columns such that each row is a distinct observation, amnd the table now fulfills all requiremenst of the tidy data principles.

## Final Notes
Also, some basic sanity checks has been performed to check if NA entries are present in original data. As the check is done at the beginning, it is not necesary to repeat the check for tables created later.

 




