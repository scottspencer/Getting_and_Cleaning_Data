# Read in each of the three files that contain some part of the test data.
test_data <- read.table("./test/X_test.txt")
test_subjects <- read.table("./test/subject_test.txt")
test_activities <- read.table("./test/y_test.txt")

# Then do the same for the training data.
train_data <- read.table("./train/X_train.txt")
train_subjects <- read.table("./train/subject_train.txt")
train_activities <- read.table("./train/y_train.txt")

# Append the subject and activity data to test_data and train_data as the last two columns
test_data[, 562] <- test_subjects
test_data[, 563] <- test_activities
train_data[, 562] <- train_subjects
train_data[, 563] <- train_activities

# Combine the two sets of data into one combined data frame.
all_data <- rbind(test_data, train_data)

# Read in the column names from the "features.txt" file.
features <- read.table("features.txt")

# Use the second column of "features" (the provided variable names) to set the column names.
names(all_data) <- c(as.character(features[, 2]), "Subject", "Activity")

# Clean up the no longer needed objects.
rm(test_data, train_data, test_activities, test_subjects, train_activities, train_subjects, features)

# Subset the data to find only the fields which are a mean or standard deviation by using grep to find
# all of the columns which contain "mean" or "std" in their names, and then adding on the Subject and Activity.

mean_and_std_measures <- all_data[, c(grep(pattern="mean|std", x=names(all_data)), 562, 563)]

# Read in the activity labels from activity_labels.txt.
activity_labels <- read.table("activity_labels.txt")

# Convert the last column (Activity) to a factor
mean_and_std_measures[, 81] <- as.factor(mean_and_std_measures[, 81])

# Then, adjust the factor levels of the activity column to the provided labels.
levels(mean_and_std_measures[, 81]) <- activity_labels[, 2]

# Discard the no longer needed activity_labels
rm(activity_labels)

######################## Steps here to relabel the variables to something more readable
names(mean_and_std_measures) <- c(
        "body_linear_acceleration_mean_x",
        "body_linear_acceleration_mean_y",
        "body_linear_acceleration_mean_z",
        "body_linear_acceleration_std_x",
        "body_linear_acceleration_std_y",
        "body_linear_acceleration_std_z",
        "body_gravity_acceleration_mean_x",
        "body_gravity_acceleration_mean_y",
        "body_gravity_acceleration_mean_z",
        "body_gravity_acceleration_std_x",
        "body_gravity_acceleration_std_y",
        "body_gravity_acceleration_std_z",
        "body_linear_acceleration_jerk_mean_x",
        "body_linear_acceleration_jerk_mean_y",
        "body_linear_acceleration_jerk_mean_z",
        "body_linear_acceleration_jerk_std_x",
        "body_linear_acceleration_jerk_std_y",
        "body_linear_acceleration_jerk_std_z",
        "body_angular_velocity_mean_x",
        "body_angular_velocity_mean_y",
        "body_angular_velocity_mean_z",
        "body_angular_velocity_std_x",
        "body_angular_velocity_std_y",
        "body_angular_velocity_std_z",
        "body_angular_velocity_jerk_mean_x",
        "body_angular_velocity_jerk_mean_y",
        "body_angular_velocity_jerk_mean_z",
        "body_angular_velocity_jerk_std_x",
        "body_angular_velocity_jerk_std_y",
        "body_angular_velocity_jerk_std_z",
        "body_linear_acceleration_magnitude_mean",
        "body_linear_acceleration_magnitude_std",
        "body_gravity_acceleration_magnitude_mean",
        "body_gravity_acceleration_magnitude_std",
        "body_linear_acceleration_jerk_magnitude_mean",
        "body_linear_acceleration_jerk_magnitude_std",
        "body_angular_velocity_magnitude_mean",
        "body_angular_velocity_magnitude_std",
        "body_angular_velocity_jerk_magnitude_mean",
        "body_angular_velocity_jerk_magnitude_std",
        "fft_linear_acceleration_mean_x",
        "fft_linear_acceleration_mean_y",
        "fft_linear_acceleration_mean_z",
        "fft_linear_acceleration_std_x",
        "fft_linear_acceleration_std_y",
        "fft_linear_acceleration_std_z",
        "fft_linear_acceleration_mean_freq_x",
        "fft_linear_acceleration_mean_freq_y",
        "fft_linear_acceleration_mean_freq_z",
        "fft_linear_acceleration_jerk_mean_x",
        "fft_linear_acceleration_jerk_mean_y",
        "fft_linear_acceleration_jerk_mean_z",
        "fft_linear_acceleration_jerk_std_x",
        "fft_linear_acceleration_jerk_std_y",
        "fft_linear_acceleration_jerk_std_z",
        "fft_linear_acceleration_jerk_mean_freq_x",
        "fft_linear_acceleration_jerk_mean_freq_y",
        "fft_linear_acceleration_jerk_mean_freq_z",
        "fft_angular_velocity_jerk_mean_x",
        "fft_angular_velocity_jerk_mean_y",
        "fft_angular_velocity_jerk_mean_z",
        "fft_angular_velocity_jerk_std_x",
        "fft_angular_velocity_jerk_std_y",
        "fft_angular_velocity_jerk_std_z",
        "fft_angular_velocity_jerk_mean_freq_x",
        "fft_angular_velocity_jerk_mean_freq_y",
        "fft_angular_velocity_jerk_mean_freq_z",
        "fft_linear_acceleration_magnitude_mean",
        "fft_linear_acceleration_magnitude_std",
        "fft_linear_acceleration_magnitude_mean_freq",
        "fft_linear_acceleration_jerk_magnitude_mean",
        "fft_linear_acceleration_jerk_magnitude_std",
        "fft_linear_acceleration_jerk_magnitude_mean_freq",
        "fft_angular_velocity_magnitude_mean",
        "fft_angular_velocity_magnitude_std",
        "fft_angular_velocity_magnitude_mean_freq",
        "fft_angular_velocity_jerk_magnitude_mean",
        "fft_angular_velocity_jerk_magnitude_std",
        "fft_angular_velocity_jerk_magnitude_mean_freq",
        "Subject",
        "Activity"
    )

# Load the reshape2 package, and use melt to create a separate line for each measurement in mean_and_std_measures.
library(reshape2)
melted_data <- melt(data=mean_and_std_measures, id.vars=c("Subject", "Activity"), measure.vars=c(names(mean_and_std_measures[, 1:79])))

# Then use dcast to reshape the data again, resulting in a single line for each Subject/Activity pair, and columns for the
# averages of each of the measurements.
tidy_data <- dcast(melted_data, Subject + Activity ~ variable, mean)

# Finally, write the resulting data set out to a text file.
write.table(x=tidy_data, file="tidy_data.txt", row.names=FALSE, quote=FALSE, sep="\t")