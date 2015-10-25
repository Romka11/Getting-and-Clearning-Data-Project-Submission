#Getting and Cleaning Data Course ProjectSolution: 
Merges the training and the test sets to create one data set.
First, using R bind:#
  
X_test <- read.table("~/R/Course Project/X_test.txt", quote="\"", comment.char="")

X_train <- read.table("~/R/Course Project/X_train.txt", quote="\"", comment.char="")

merged_x_test_train<-rbind(X_test,X_train)

y_test <- read.table("~/R/Course Project/y_test.txt", quote="\"", comment.char="")

y_train <- read.table("~/R/Course Project/y_train.txt", quote="\"", comment.char="")

merged_y_test_train<-rbind(y_test,y_train)

subject_test <- read.table("~/R/Course Project/subject_test.txt", quote="\"", comment.char="")

subject_train <- read.table("~/R/Course Project/subject_train.txt", quote="\"", comment.char="")

merged_subject_test_train<-rbind(subject_test,subject_train)

#Second, using Cbind:#

finalmerge<cbind(merged_x_test_train,merged_y_test_train,merged_subject_test_train)

#Name columns with features#
colnames(merged_x_test_train, do.NULL = TRUE, prefix = "")
colnames(merged_x_test_train)<-features[,2]

#Extracts only the measurements on the mean and standard deviation for each measurement#

answer2<-finalmerge[,grepl("mean|std", colnames(finalmerge))]

#Uses descriptive activity names to name the activities in the data set#

names(finalmerge)[names(finalmerge)=="V1"] <- "activity_type"
names(finalmerge)[563] <- "subject_number"

new_activity_type<-plyr::mapvalues(finalmerge$activity_type, 1:6,c("WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING","STANDING","LAYING"))
mergebeforetidy<-cbind(finalmerge,new_activity_type)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.#

tidyset_before_sum<-tidyset[,grepl("mean|std", colnames(tidyset))]
group_by(mergebeforetidy,activity_type,subject_number)

tidyset_before_sum %>% summarise_each(funs(mean))

finalset<-tidyset_before_sum %>% summarise_each(funs(mean))

#saves tidy set in as a .txt file for submission#
write.table(finalset, "C:/Users/shapiro/My Documents/tidyset.txt", sep="\t",row.name=FALSE)


