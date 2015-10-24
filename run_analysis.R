#Loading all core elements
train = read.table("train/X_train.txt")
test = read.table("test/X_test.txt")
sub_train = read.csv("train/subject_train.txt", header = FALSE)
sub_test = read.csv("test/subject_test.txt", header = FALSE)
act_lab = read.csv("activity_labels.txt", header = FALSE, sep = "")
features = read.csv("features.txt",header = FALSE, sep="")
train_act = read.csv("train/y_train.txt", header = FALSE)
test_act = read.csv("test/y_test.txt", header = FALSE)

# Merging training and testing set
sub = rbind(sub_train, sub_test)
data = rbind(train, test)
act = rbind(train_act, test_act)


#Giving names to features
names(data) = features[,2]

#Merging feature mesurements, subjects ids and activities
data = cbind(data, sub, act)
names(data)[562]=c("Subject")
names(data)[563]=c("Activity")

#Selecting appropriate columns
features_wanter <- grep(".*mean.*|.*std.*", features[,2])
columns = c(features_wanter,562,563)
data = data[,columns]

#Changing avtivity and subject into factors
data$Subject = as.factor(data$Subject)
data$Activity = as.factor(data$Activity)

#Changing activity ids into labels
act_lab$V2 = as.character(act_lab$V2)
for (i in act_lab[,1]){
        data$Activity = gsub(i,act_lab[i,2], data$Activity)
}
data$Activity = as.factor(data$Activity)

#Creating tidy data set
result = aggregate(data, by=list(activity = data$Activity, subject=data$Subject), mean)
result[,83] = NULL
result[,82] = NULL
write.table(result, "tidy.txt", sep="\t")