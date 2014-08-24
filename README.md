-------------------------------------------------------------------------------
Coursera - Getting and Cleaning Data - Course Project
2014-08-24
-------------------------------------------------------------------------------

I used a single script (run_analysis.R) to combine, analyze, and tidy up the data.

It is assumed that the file is run in the same directory as the data to be analyzed;
that is, the "UCI HAR Dataset" directory of the data downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data to analyze was contained primarily in three files for each of the two
sets of data: the test data, and the training data. The test data could be found
in X_test.txt, containing the test data measurements; subject_test.txt, containing
the data on which subject each of the test data lines corresponded to; y_test.txt,
containing the activity which the subject was doing on each line of the test data.
Matching files could be found for the training data: X_train.txt, subject_train.txt,
and y_train.txt.

After reading this data into R, I appended first the subjects, and then the activities
to the end of the test and training data as additional columns.  Then I appended the
two data sets together using rbind, resulting in a single complete data set of 10299
rows.

I then read in the names of the data from the original data set (from features.txt),
and used grep to determine which of those columns contained a mean or standard
deviation, creating a subset of the data containing only those columns.

I then replaced the names of the columns with more readable and consistent names.

Using the reshape2 package, I used the melt function to place each measurement on a
separate line, then used dcast to calculate the mean of each of these measurements
for each Subject/Activity pair.

Finally, the resulting data was written out to the tab-delimited tidy_data.txt file.


-------------------------------------------------------------------------------
Data Set Contents
-------------------------------------------------------------------------------

run_analysis.R : The script used to create the final, tidy data set.
README.md : This file, which explains the behavior of run_analysis.R.
CodeBook.md : Lists the variables in the tidy data set, as well as descriptions
					and ranges of those variables.
tidy_data.txt : This is the final, tidy data set, uploaded to Coursera.


-------------------------------------------------------------------------------
License information from original dataset:
-------------------------------------------------------------------------------
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
