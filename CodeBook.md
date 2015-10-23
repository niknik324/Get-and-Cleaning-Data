---
title: "Getting and Cleaning Data"
author: "niknik324"
date: "23 октября 2015 г."
output: html_document
---

#CodeBook




## Where the data comes from

One of the most exciting areas in all of data science right now is wearable computing - see for example this article. 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
The data we have been working with represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 



## Original files

* features_info.txt: Information about the variables.
* features.txt: List of all features.
* activity_labels.txt: Activity name.
* train/X_train.txt: Training set.
* train/y_train.txt: Training labels.
* train/subject_train.txt: List of subjects
* test/X_test.txt: Test set.
* test/y_test.txt: Test labels.
* test/subject_test.txt: List of subjects




## What is inside

####Main tables (X_train and X_test) have 561 columns. This is some brief information about them.

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
arCoeff(): Autorregresion coefficients with Burg order equal to 4
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




## How we read data

We read all the tables we need.

```r
features <- read.table('features.txt')
activity <- read.table("activity_labels.txt")

tstX <- read.table('test/X_test.txt')
tsty <- read.table('test/y_test.txt')
tstsub <- read.table('test/subject_test.txt')

trnX <- read.table('train/X_train.txt')
trny <- read.table('train/y_train.txt')
trnsub <- read.table('train/subject_train.txt')
```




## How we merge anf filter data

```r
dataUN <- rbind(cbind(tstsub, tsty, tstX),cbind(trnsub, trny, trnX))
```

Extract only means and std-s for each mesurement.

```r
meanandstd  <- grepl("(-std\\(\\)|-mean\\(\\))",features$V2)
dataUN_FLTR <- dataUN[, -which(meanandstd == FALSE)]
```




## How we rename variables and activities

Create vector with column name and rename our main table with it

```r
cnames <- c('subject','activity',as.character(features[meanandstd == TRUE,2]))
colnames(dataUN_FLTR) <- cnames
```

Rename activities with there real names

```r
activity$V2 <- as.character(activity$V2)
for (i in 1:6) {
    dataUN_FLTR[dataUN_FLTR$activity == i,2] <- activity[activity$V1 == i,2]
}
```




## How we create additional data set

Use `ddply` from `plyr` package to create one more tidy-data table with means by each activity grouped by subject 

```r
library(plyr)
fu <- function(y) {ddply(y,.(activity),function (x) colMeans(x[,3:68]))}
meanBYactivityANDsubject <- ddply(dataUN_FLTR,.(subject),fu)
```




## What do we get

As a result of this script we get two dataframes: DataUN_FLTR and meanBYactivityANDsubject
First one have 68 columns:

    subjet-id
    
    activity
    
    and std and mean values of 11 parametrs in 3 dimensions.
    
    
The second one bases on same columns, but contains mean values of data in DataUN_FLTR  grouped by activity name for each subject. 
