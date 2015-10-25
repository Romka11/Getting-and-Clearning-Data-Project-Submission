# Getting-and-Clearning-Data-Project-Submission
This Readme file contains both code and my detailed explanations.  The run_analysis.R file contains the code and only high level comments showing the code corresponding to assignment steps 1-5.  

Merges the training and the test sets to create one data set.
To accomplish the task above, we need to use both R bind and C bind functions.  We bring both test and train  .txt files into R.  Note: I am not showing the dim(file) or head(file) commands below, but of course I had to use them to figure out which files to bind, since dim(file) shows me the number of rows and columns.  
1.	R bind:
a.	 X_test <- read.table("~/R/Course Project/X_test.txt", quote="\"", comment.char="")
  
X_train <- read.table("~/R/Course Project/X_train.txt", quote="\"", comment.char="")

merged_x_test_train<-rbind(X_test,X_train)
b.	 y_test <- read.table("~/R/Course Project/y_test.txt", quote="\"", comment.char="")
  y_train <- read.table("~/R/Course Project/y_train.txt", quote="\"", comment.char="")
merged_y_test_train<-rbind(y_test,y_train)
subject_test <- read.table("~/R/Course Project/subject_test.txt", quote="\"", comment.char="")
subject_train <- read.table("~/R/Course Project/subject_train.txt", quote="\"", comment.char="")
merged_subject_test_train<-rbind(subject_test,subject_train)
2.	Name columns with features—this step names 561 columns of my 561 column data file using the names provided in the features.txt file.  
a.	features <- read.table("~/R/Course Project/features.txt", quote="\"", comment.char="")
b.	colnames(merged_x_test_train, do.NULL = TRUE, prefix = "")
c.	colnames(merged_x_test_train)<-features[,2]
3.	Cbind:
a.	 finalmerge<cbind(merged_x_test_train,merged_y_test_train,merged_subject_test_train)
finalmerge is the file that has 563 columns.  The last two columns (562,563) are numbers of activity type and numbers of subjects participating in the activity.  
Extracts only the measurements on the mean and standard deviation for each measurement.  
Here I used the grep function to only keep the columns that contain the string “mean” or “std”.  
4.	 answer2<-finalmerge[,grepl("mean|std", colnames(finalmerge))]
Uses descriptive activity names to name the activities in the data set.  
In steps 5 and 6 below I renamed the columns 562 and 563 to “activity_type” and “subject_number”, so that it is clearer what the columns represent.  
5.	names(finalmerge)[names(finalmerge)=="V1"] <- "activity_type"
6.	names(finalmerge)[names(finalmerge)=="V1.1"] <-"subject_number"

In step 7 below I used plyr::mapvalues to create a new column that had verbal explanations for each of activity numbers 1:6.  I then added that row to table with a cbind.  
7.	new_activity_type<plyr::mapvalues(finalmerge$activity_type,1:6,c("WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING","STANDING","LAYING"))
   mergebeforetidy<-cbind(finalmerge,new_activity_type)

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
First, I used “group by” function to group by activity type and by subject number.  
tidyset<-group_by(mergebeforetidy,activity_type,subject_number)


Then, I made sure that I only have columns with “mean” and “std” values in them.  I ended up with 79 columns.  

tidyset_before_sum<-tidyset[,grepl("mean|std", colnames(tidyset))]
group_by(mergebeforetidy,activity_type,subject_number)

Below, I used “summarise each” function to get the mean of each grouping.  I finalized the work by renaming the dataset into “finalset”.  
tidyset_before_sum %>% summarise_each(funs(mean))

finalset<-tidyset_before_sum %>% summarise_each(funs(mean))


The below tidyset.txt file is submitted to Coursera.  

write.table(finalset, "C:/Users/shapiro/My Documents/tidyset.txt", sep="\t",row.name=FALSE)



