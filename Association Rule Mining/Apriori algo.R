
#Implementing Apriori Algorithm

#read transactions
df_groceries <- read.csv("C:/Users/Nav/Downloads/GC.csv")  
str(df_groceries) 

#to see data
View(df_groceries)

#to sort data according to member number
df_sorted <- df_groceries[order(df_groceries$Member_number),]
View(df_groceries)
is.numeric(df_sorted$Member_number)   #check if the member number is numeric


#convert memberr to numeric if not 
df_sorted$Member_number <- as.numeric(df_sorted$Member_number)

#convert item desc into categorical format if not
df_sorted$itemDescription <- factor(df_sorted$itemDescription)


#to see a summary of the dataset
str(df_sorted)


# convert dataframe to transaction using deplyr


#if deplyr package already exists in any other package we unload it to avoid conflict
if(sessionInfo()['basePkgs']=="dplyr" | sessionInfo()['otherPkgs']=="dplyr"){
  detach(package:deplyr, unload = TRUE)
}

#to change default library folder

.libPaths("C:/Users/Nav/Documents/R")

#install and use the plyr library
install.packages("plyr")
library(plyr)


#group all the items that we bought together; by same customer number on the same date
df_itemList <- ddply(df_groceries,c("Member_number","Date"),
                     function(df1)paste(df1$itemDescription,collapse = ","))


#remove member number and date
df_itemList$Member_number <- NULL
df_itemList$Date <- NULL

colnames(df_itemList) <- c("itemList")

#write csv format
write.csv(df_itemList,"C:/Users/Nav/Documents/R/ItemList.csv", quote = FALSE, row.names = TRUE )



#-----------------------association rule mining algorithm : apriori--------------------------#

#load package required
install.packages("arules")
library(arules)

#convert csv file to basket format
txn = read.transactions(file="C:/Users/Nav/Documents/R/ItemList.csv",rm.duplicates = FALSE, format = "basket", sep = ",", cols=1)

#remove quotes from transactions if there are any
txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)


#run apriori algorithm
basket_rules <- apriori(txn, parameter = list(minlen=2, sup=0.001, conf = 0.01, target = "rules"))

#view rules
inspect(basket_rules)

#convert to dataframe & view; optional 
df_basket <- as(basket_rules,"data.frame")
df_basket$confidence <- df_basket$confidence * 100
df_basket$support <- df_basket$support * 100


#split lhs & rhs into two columns
install.packages("reshape2")
library(reshape2)

df_basket <- transform(df_basket,rules = colsplit(rules,pattern = "=>", names = c("lhs","rhs")))
View (df_basket)

#remove curly brackets
df_basket$rules$lhs <- gsub("[[:punct:]]","",df_basket$rules$lhs)
df_basket$rules$rhs <- gsub("[[:punct:]]","",df_basket$rules$rhs)

#convert to character
df_basket$rules$lhs <- as.character(df_basket$rules$lhs)
df_basket$rules$rhs <- as.character(df_basket$rules$rhs)

.libPaths("C:/Users/Nav/Documents/R")
library(stringi)  #to use string and characters
install.packages("dplyr")
library(dplyr)

# selecting where there is yogurt in lhs and showing rhs corresponding to it
df_basket$rules %>% filter(stri_detect_fixed(lhs,"yogurt")) %>% select(rhs)

#plot the rules
.libPaths("C:/Users/Nav/Documents/R")

install.packages("arulesViz")
library(arulesViz)
plot(df_basket$lhs)
#install.packages("grid")
#library(grid)

plot(basket_rules, method = "grouped", control = list(k=5))

plot(basket_rules[1:10,],method = "graph", control = list(type="items"))

plot(basket_rules[1:10,],method = "paracoord", control=list(alpha=.5, reorder = TRUE))

itemFrequencyPlot(txn, topN = 5)

plot(basket_rules[1:10], measure = c("support","lift"),shading = "confidence", interactive = T)




