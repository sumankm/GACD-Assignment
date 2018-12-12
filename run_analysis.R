

#--- Basic Housekeeping ---#

# Clean the environment variables
rm(list = ls())

# Set up a data folder to store files
data_folder <- "./"
# Create data folder if necessary
if(!file.exists("data")) {
  dir.create("data")
}
data_folder <- "./data/"


# Set up file download variables
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest.file <- paste0(data_folder,"HAR_Dataset.zip",sep="")
print(dest.file)

# Set up download methods for different operating systems
dl.method <- "curl" # sets default for OSX / Linux
if(substr(Sys.getenv("OS"),1,7) == "Windows") dl.method <- "wininet"


# Download the file if it doesn't already exist  
# It has been verified to work on all major operating systems
if(!file.exists(dest.file)) {
  # Download
	download.file(file.url,
           		destfile = dest.file,
           		method = dl.method, # appropriate download method for  OSX / Linux / Windows
           		mode = "wb") # "wb" means "write binary," and is used for binary files

  # Unzip the file
	unzip(zipfile = dest.file, exdir = data_folder) # unpack the files into subdirectories 
}

# Working data folder
working.folder <- paste0(data_folder, "UCI HAR Dataset/", sep="")
# print(working.folder)

# Load needed libraries
# Loading using lapply is helpful when multiple libraries need to be loaded
libraries <- c("dplyr", "tidyverse")
lapply(libraries, require, character.only = TRUE)
#--- End of Basic Housekeeping ---#




#--- Load feature names and activity labels ---#
# List of all features (561 rows)
features.file <- paste0(working.folder, "features.txt", sep="")
# All activity labels (6 rows)
activity.labels.file <- paste0(working.folder, "activity_labels.txt", sep="")


feature_names <- read.table(features.file, header = F)
activity_labels <- read.table(activity.labels.file, header = F,
                              col.names = c("activity_id", "activity"))
#--- ---#



#--- Load training data ---#
# File with all 561 variables for training set
X_train.file <- paste0(working.folder, "train/X_train.txt", sep="")
# File with 1 variable: activity_id
y_train.file <- paste0(working.folder, "train/y_train.txt", sep="")
# File with 1 variable: subject
subject_train.file <- paste0(working.folder, "train/subject_train.txt", sep="") 

train_X <- read.table(X_train.file, header = F)
colnames(train_X) <- feature_names$V2
train_y <- read.csv(y_train.file, header = F, col.names = c("activity_id")) %>%
                left_join(activity_labels, by = "activity_id")
train_subject <- read.csv(subject_train.file, header = F, col.names = "subject")
#--- ---#




#--- Load test data ---#
# File with all 561 variables for test set
X_test.file <- paste0(working.folder, "test/X_test.txt", sep="")
# File with 1 variable: activity_id
y_test.file <- paste0(working.folder, "test/y_test.txt", sep="")
# File with 1 variable: subject
subject_test.file <- paste0(working.folder, "test/subject_test.txt", sep="")

test_X <- read.table(X_test.file, header = F)
colnames(test_X) <- feature_names$V2
test_y <- read.csv(y_test.file, header = F, col.names = c("activity_id")) %>%
                left_join(activity_labels, by = "activity_id")
test_subject <- read.csv(subject_test.file, header = F, col.names = "subject")
#--- ---#



################################################################################################################
# STEP 1. Merges the training and the test sets to create one data set.
################################################################################################################

train <- cbind(train_X, train_y, train_subject)
test <- cbind(test_X, test_y, test_subject)

phone <- rbind(train, test)

# Somehow I get error here, when trying to convert to tibble format
# phonetbl <- tibble::as_tibble(phone)


################################################################################################################
# STEP 2. Extracts only the measurements on the mean and standard deviation for each measurement.
################################################################################################################

# Print the column names
names(phone)

# Make a boolean vector of columns we want to keep
columns_to_keep <- grepl("mean|std|subject|activity_id", colnames(phone)) & !grepl("meanFreq", colnames(phone))


# Extract canonical dataframe with only the columns we are interested in
canonical.phone <- phone[, columns_to_keep]

# Print the column names
names(canonical.phone)


################################################################################################################
# STEP 3. Uses descriptive activity names to name the activities in the data set.
################################################################################################################

# Convert data frame to tibble format and join with activity_labels
canonical.phone <- tbl_df(canonical.phone)
canonical.phone <- inner_join(canonical.phone, activity_labels)

# Print the column names
names(canonical.phone)

# Re-arrange the columns
canonical.phone <- canonical.phone[,c(67,69,68, 1:66)]

# Print the column names
names(canonical.phone)

################################################################################################################
# STEP 4. Appropriately labels the data set with descriptive variable names.
################################################################################################################


#Store the column names in a temporary variable
temp.colnames <- names(canonical.phone)

#Change the names in the temporary variable
temp.colnames <- str_replace_all(temp.colnames, "Acc", "-acceleration-")
temp.colnames <- str_replace_all(temp.colnames, "Gyro", "-gyroscope-")
temp.colnames <- str_replace_all(temp.colnames, "Mag", "-magnitude")
temp.colnames <- str_replace_all(temp.colnames, "\\(\\)", "")
temp.colnames <- str_replace_all(temp.colnames, "^t", "time-")
temp.colnames <- str_replace_all(temp.colnames, "^f", "frequency-")
temp.colnames <- str_replace_all(temp.colnames, "tBody", "time-body-")
temp.colnames <- str_replace_all(temp.colnames, "BodyBody", "body")
temp.colnames <- str_replace_all(temp.colnames, "--", "-")
#Set the names to lower case
temp.colnames <- tolower(temp.colnames)

#Replace the names in canonical.phone with the ones in the temporary variable.
names(canonical.phone) <- temp.colnames

# Print the column names
names(canonical.phone)



################################################################################################################
# STEP 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
################################################################################################################



# Take the canonical.phone table and collapse columns into key-value pairs.
tidy.phone <- canonical.phone %>% gather(sensor, value, 4:69)

# Aggregate the data, order the columns and order the rows.
tidy.phone <- aggregate(value ~ sensor + activity + subject, data=tidy.phone,
                   mean, na.rm=TRUE) %>%
  select(activity, subject, sensor, value) %>%
  group_by(subject, activity, sensor)

# Make all the column names in lowercase
# In our case, as they are already in lower case, this will have no effect
names(tidy.phone) <- tolower(names(tidy.phone))

# Print the column names
names(tidy.phone)

# Print first 3 lines of data
head(tidy.phone,3)

# Write out tidy data set to a .txt file.
write.table(tidy.phone, "tidy_phone_data.txt", row.name = FALSE)







