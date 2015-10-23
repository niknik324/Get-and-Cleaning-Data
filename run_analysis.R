features <- read.table('features.txt')
activity <- read.table("activity_labels.txt")

tstX <- read.table('test/X_test.txt')
tsty <- read.table('test/y_test.txt')
tstsub <- read.table('test/subject_test.txt')

trnX <- read.table('train/X_train.txt')
trny <- read.table('train/y_train.txt')
trnsub <- read.table('train/subject_train.txt')

dataUN <- rbind(cbind(tstsub, tsty, tstX),cbind(trnsub, trny, trnX))

meanandstd  <- grepl("(-std\\(\\)|-mean\\(\\))",features$V2)
dataUN_FLTR <- dataUN[, -which(meanandstd == FALSE)]


activity$V2 <- as.character(activity$V2)
for (i in 1:6) {
    dataUN_FLTR[dataUN_FLTR$activity == i,2] <- activity[activity$V1 == i,2]
}


cnames <- c('subject','activity',as.character(features[meanandstd == TRUE,2]))
colnames(dataUN_FLTR) <- cnames


library(plyr)
fu <- function(y) {ddply(y,.(activity),function (x) colMeans(x[,3:68]))}
meanBYactivityANDsubject <- ddply(dataUN_FLTR,.(subject),fu)