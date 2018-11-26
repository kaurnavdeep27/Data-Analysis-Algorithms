library(MASS)         #library for datsets
library(rpart)

head(birthwt)
View(birthwt)

hist(birthwt$bwt)   #histogram acc to weight

summary(birthwt)

table(birthwt$low)

pie(table(birthwt$low))

hist(birthwt$low)     #0  1
#                     130 59      130/59=68.5%

cols <- c('low', 'race', 'smoke', 'ht', 'ui')

birthwt[cols] <- lapply(birthwt[cols], as.factor)
birthwt$low = as.factor(birthwt$low)

is.factor(birthwt$low)

#use cross validation function set.seed
set.seed(1)   # number in bracket dosent have any significance it can be anything
set.seed(23)

train <- sample(1:nrow(birthwt), 0.750 * nrow(birthwt))  # train using 75% of data

birthwTree <- rpart(low ~.-bwt, data = birthwt[train,], method = 'class')       #we want to predict low and we will take all attributes except birthweight

#to create a tree
plot(birthwTree, margin = 0.2, main="Tree")

#to display text on tree
text(birthwTree, cex=1.0)

summary(birthwTree)


birthwPred <- predict(birthwTree, birthwt[-train,], type = 'class')  
table(birthwPred, birthwt[-train, ]$low)
#birthwPred  0  1
#0 25  7
#1 11  5            accuracy is (25+5)/(25+5+7+11) = 63%












