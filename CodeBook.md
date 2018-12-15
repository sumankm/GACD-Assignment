

# Code Book for Getting and Cleaning Data Course Project
Su Mann
December 2018

## Aims of the Code Book
This code book describes the variables, the data, and any transformations or work that was performed to clean up the data.

## Brief Summary of Data Transformations
After finding a canonical version of the phone data, gather and aggregate functions from the tidyverse dplyr package are used to convert the tables into tidy data.

## Source of Dataset
The raw source material used was obtained from the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Features and Measurements
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autoregression coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

## Initial Loading of Dataframes 
The features_info.txt file is used for reference but not to load into data frames, as it is in free text format.
- features_info.txt: Shows information about (or, meaning of) the variables used on the feature vector in features.txt.

The following data files are loaded into tables.

- features.txt: List of all features. List of 561 different features.
- activity_labels.txt: Links the class labels with their activity name.

- train/X_train.txt: Training set. 7352 observations of 561 variables.
- train/y_train.txt: Training labels or activity_ids for 7352 observations.
- train/subject_train.txt: subject_ids for training, 7352 observations..

- test/X_test.txt: Test set.  2947 observations of 561 variables.
- test/y_test.txt: Test labels or activity_ids for 2947 observations.
- test/subject_test.txt: subject_ids for test, 2947 observations.

Each of these files when converted into dataframes is described next.


- activity_labels.txt: Links the class labels with their activity name.
activity_labels <- activity_labels.txt  
activity_id : Integer
activity : Factor

```
> head(activity_labels)
  activity_id           activity
1           1            WALKING
2           2   WALKING_UPSTAIRS
3           3 WALKING_DOWNSTAIRS
4           4            SITTING
5           5           STANDING
6           6             LAYING
> 
```


- features.txt: List of all features. List of 561 different features.
feature_names <- features.txt
V1 : Integer
V2 : Factor

```
> head(feature_names)
  V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
3  3 tBodyAcc-mean()-Z
4  4  tBodyAcc-std()-X
5  5  tBodyAcc-std()-Y
6  6  tBodyAcc-std()-Z
> 
```


- train/X_train.txt: Training set. 7352 observations of 561 variables.
train_X <- train/X_train.txt 

```
> head(train_X, 1)
  tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z tBodyAcc-mad()-X
1         0.2885845       -0.02029417        -0.1329051       -0.9952786       -0.9831106       -0.9135264       -0.9951121
  tBodyAcc-mad()-Y tBodyAcc-mad()-Z tBodyAcc-max()-X tBodyAcc-max()-Y tBodyAcc-max()-Z tBodyAcc-min()-X tBodyAcc-min()-Y
1       -0.9831846        -0.923527       -0.9347238       -0.5673781       -0.7444125        0.8529474        0.6858446
  tBodyAcc-min()-Z tBodyAcc-sma() tBodyAcc-energy()-X tBodyAcc-energy()-Y tBodyAcc-energy()-Z tBodyAcc-iqr()-X tBodyAcc-iqr()-Y
1        0.8142628     -0.9655228          -0.9999446           -0.999863          -0.9946122       -0.9942308       -0.9876139
  tBodyAcc-iqr()-Z tBodyAcc-entropy()-X tBodyAcc-entropy()-Y tBodyAcc-entropy()-Z tBodyAcc-arCoeff()-X,1 tBodyAcc-arCoeff()-X,2
1         -0.94322           -0.4077471           -0.6793375           -0.6021219              0.9292935             -0.8530111
  tBodyAcc-arCoeff()-X,3 tBodyAcc-arCoeff()-X,4 tBodyAcc-arCoeff()-Y,1 tBodyAcc-arCoeff()-Y,2 tBodyAcc-arCoeff()-Y,3
1              0.3599098            -0.05852638              0.2568915             -0.2248476              0.2641057
  tBodyAcc-arCoeff()-Y,4 tBodyAcc-arCoeff()-Z,1 tBodyAcc-arCoeff()-Z,2 tBodyAcc-arCoeff()-Z,3 tBodyAcc-arCoeff()-Z,4
1            -0.09524563              0.2788514             -0.4650846               0.491936             -0.1908836

--- many more lines not shown here ---
```





- train/y_train.txt: Training labels for 7352 observations.
train_y <- train/y_train.txt

Please note that y_train.txt contains only activity_id but train_y table has been made with a join with activity_labels so that activity column shows human readable activity description.


```
> head(train_y)
  activity_id activity
1           5 STANDING
2           5 STANDING
3           5 STANDING
4           5 STANDING
5           5 STANDING
6           5 STANDING
> 
```




- test/X_test.txt: Test set.  2947 observations of 561 variables.
test_X <- test/X_test.txt 

```
head(test_X, 1)
  tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z tBodyAcc-mad()-X
1         0.2571778       -0.02328523       -0.01465376        -0.938404       -0.9200908       -0.6676833       -0.9525011
  tBodyAcc-mad()-Y tBodyAcc-mad()-Z tBodyAcc-max()-X tBodyAcc-max()-Y tBodyAcc-max()-Z tBodyAcc-min()-X tBodyAcc-min()-Y
1       -0.9252487       -0.6743022       -0.8940875       -0.5545772        -0.466223        0.7172085        0.6355024
  tBodyAcc-min()-Z tBodyAcc-sma() tBodyAcc-energy()-X tBodyAcc-energy()-Y tBodyAcc-energy()-Z tBodyAcc-iqr()-X tBodyAcc-iqr()-Y
1        0.7894967     -0.8777642          -0.9977661          -0.9984138          -0.9343453        -0.975669       -0.9498237
  tBodyAcc-iqr()-Z tBodyAcc-entropy()-X tBodyAcc-entropy()-Y tBodyAcc-entropy()-Z tBodyAcc-arCoeff()-X,1 tBodyAcc-arCoeff()-X,2
1       -0.8304778           -0.1680842           -0.3789955             0.246217              0.5212036             -0.4877931
  tBodyAcc-arCoeff()-X,3 tBodyAcc-arCoeff()-X,4 tBodyAcc-arCoeff()-Y,1 tBodyAcc-arCoeff()-Y,2 tBodyAcc-arCoeff()-Y,3
1              0.4822805            -0.04546211              0.2119551             -0.1348944              0.1308585

--- many more lines not shown here ---
```


- test/y_test.txt: Test labels for 2947 observations.

test_y <- test/y_test.txt

Please note that y_test.txt contains only activity_id but test_y table has been made with a join with activity_labels so that activity column shows human readable activity description.

```
> head(test_y)
  activity_id activity
1           5 STANDING
2           5 STANDING
3           5 STANDING
4           5 STANDING
5           5 STANDING
6           5 STANDING
> 
```


## Main Data Transformations


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

A boolean vector called columns_to_keep is constructed to keep only the fields that match mean|std|subject|activity_id.
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

The first three entries of the table is shown below to give the reader a feel for what it looks like.

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

As we can see, all features and measurements have been now gathered into columns such that each row is a distinct observation, and the table now fulfills all requirements of the tidy data principles.

## Final Notes
Also, some basic sanity checks have been performed to check if NA entries are present, if data types are correct, etc.

