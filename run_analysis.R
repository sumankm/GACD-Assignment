

#--- Basic Housekeeping ---#
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
                              col.names = c("Activity_id", "Activity"))
#--- ---#



#--- Load training data ---#
# File with all 561 variables for training set
X_train.file <- paste0(working.folder, "train/X_train.txt", sep="")
# File with 2 variables: activity_id, activity name
y_train.file <- paste0(working.folder, "train/y_train.txt", sep="")
# File with 1 variable: subject ID
subject_train.file <- paste0(working.folder, "train/subject_train.txt", sep="") 

train_X <- read.table(X_train.file, header = F)
colnames(train_X) <- feature_names$V2
train_y <- read.csv(y_train.file, header = F, col.names = c("Activity_id")) %>%
                left_join(activity_labels, by = "Activity_id")
train_subject <- read.csv(subject_train.file, header = F, col.names = "Subject")
#--- ---#




#--- Load test data ---#
# File with all 561 variables for test set
X_test.file <- paste0(working.folder, "test/X_test.txt", sep="")
# File with 2 variables: activity_id, activity name
y_test.file <- paste0(working.folder, "test/y_test.txt", sep="")
# File with 1 variable: subject ID
subject_test.file <- paste0(working.folder, "test/subject_test.txt", sep="")

test_X <- read.table(X_test.file, header = F)
colnames(test_X) <- feature_names$V2
test_y <- read.csv(y_test.file, header = F, col.names = c("Activity_id")) %>%
                left_join(activity_labels, by = "Activity_id")
test_subject <- read.csv(subject_test.file, header = F, col.names = "Subject")
#--- ---#



################################################################################################################
# STEP 1. Merges the training and the test sets to create one data set.
################################################################################################################

train <- cbind(train_X, train_y, train_subject)
test <- cbind(test_X, test_y, test_subject)

phonedata <- rbind(train, test)

# Somehow I get error here, when trying to convert to tibble format
# phonetbl <- tibble::as_tibble(phonedata)


################################################################################################################
# STEP 2. Extracts only the measurements on the mean and standard deviation for each measurement.
################################################################################################################


nms <- names(phonedata)

keepnames <- grepl("mean|std|Subject|Activity", colnames(phonedata)) & !grepl("meanFreq|Activity_id", colnames(phonedata))

# keepnames <- grepl("-mean|-std|Subject|Activity", colnames(phonedata)) 

# Extract canonical dataframe
df_canon <- phonedata[, keepnames]

nms_canon <- names(df_canon)
print(nms_canon)


################################################################################################################
# STEP 3. Uses descriptive activity names to name the activities in the data set
################################################################################################################


################################################################################################################
# STEP 4. Appropriately labels the data set with descriptive variable names.
################################################################################################################





################################################################################################################
# STEP 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
################################################################################################################









