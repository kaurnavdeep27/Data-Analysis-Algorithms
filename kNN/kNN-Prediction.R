
#importing data
dataCancer <- read.csv("C:/Users/Nav/Documents/Data_Prostate_Cancer.csv",stringsAsFactors = FALSE)

#view the data of csv file
View(dataCancer)

# to see if data is structured or not
str(dataCancer)     

#removing first column from the data as it contains id number
dataCancer <- dataCancer[-1]

table(dataCancer$diagnosis_result)

#renaming labels as Benign and Malignant from B & M
dataCancer$diagnosis <- factor(dataCancer$diagnosis_result, levels = c("B", "M"), labels = c("Benign", "Malignant"))

#to get result in percentage and round off data to 1
round(prop.table(table(dataCancer$diagnosis)) * 100, digits = 1)

#function to normalize data
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }

#normalizing only 8 separate variable columns as we will use only those
dC_normalized <- as.data.frame(lapply(dataCancer[2:9], normalize))

#checking if this variable has been normalized
summary(dC_normalized$radius)

#Creating training and testing data
CancerData_training <- dC_normalized[1:70, ]
CancerData_testing <- dC_normalized[71:100, ]

CancerData_train_labels <- dataCancer[1:70,1]
CancerData_test_labels <- dataCancer[71:100,1]


install.packages("class")
library(class)

#using kNN
Cancer_prediction <- knn(train = CancerData_training,test = CancerData_testing,cl = CancerData_train_labels, k=9)

install.packages("gmodels")

library(gmodels)

#to check accuracy using crosstable()
CrossTable(x=CancerData_test_labels, y=Cancer_prediction, prop.chisq=FALSE)

