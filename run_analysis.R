

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
libraries <- c("dplyr")
lapply(libraries, require, character.only = TRUE)


features.file <- paste0(working.folder, "features.txt", sep="")
activity.labels.file <- paste0(working.folder, "activity_labels.txt", sep="")

### Load feature names and activity labels
feature_names <- read.table(features.file, header = F)
activity_labels <- read.table(activity.labels.file, header = F,
                              col.names = c("activity_id", "activity_name"))

# Load training data
X_train.file <- paste0(working.folder, "train/X_train.txt", sep="")
y_train.file <- paste0(working.folder, "train/y_train.txt", sep="")
subject_train.file <- paste0(working.folder, "train/subject_train.txt", sep="")

train_X <- read.table(X_train.file, header = F)
train_y <- read.csv(y_train.file, header = F, col.names = c("activity_id")) %>%
                left_join(activity_labels, by = "activity_id")
train_subject <- read.csv(subject_train.file, header = F, col.names = "subject")


# Load test data
X_test.file <- paste0(working.folder, "test/X_test.txt", sep="")
y_test.file <- paste0(working.folder, "test/y_test.txt", sep="")
subject_test.file <- paste0(working.folder, "test/subject_test.txt", sep="")

test_X <- read.table(X_test.file, header = F)
test_y <- read.csv(y_test.file, header = F, col.names = c("activity_id")) %>%
                left_join(activity_labels, by = "activity_id")
test_subject <- read.csv(subject_test.file, header = F, col.names = "subject")


