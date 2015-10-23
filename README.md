---
title: "Getting and Cleaning Data"
author: "niknik324"
date: "23 октября 2015 г."
output: html_document
---

#ReadMe

This is how 'run_analysis.R' script works:

1. We read all the tables we need.

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

2. Merge 6 tables with data.

```r
dataUN <- rbind(cbind(tstsub, tsty, tstX),cbind(trnsub, trny, trnX))
```

3.  Extract only means and std-s for each mesurement.

```r
meanandstd  <- grepl("(-std\\(\\)|-mean\\(\\))",features$V2)
dataUN_FLTR <- dataUN[, -which(meanandstd == FALSE)]
```

4. Create vector with column name and rename our main table with it

```r
cnames <- c('subject','activity',as.character(features[meanandstd == TRUE,2]))
colnames(dataUN_FLTR) <- cnames
```

5. Rename activities with there real names

```r
activity$V2 <- as.character(activity$V2)
for (i in 1:6) {
    dataUN_FLTR[dataUN_FLTR$activity == i,2] <- activity[activity$V1 == i,2]
}
```

6. Use `ddply` from `plyr` package to create one more tidy-data table with means by each activity grouped by subject 

```r
library(plyr)
fu <- function(y) {ddply(y,.(activity),function (x) colMeans(x[,3:68]))}
meanBYactivityANDsubject <- ddply(dataUN_FLTR,.(subject),fu)
```



As a result of this script we get two dataframes: DataUN_FLTR and meanBYactivityANDsubject