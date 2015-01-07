#--------------------------------------------------------

#read in train/test

test <- read.csv("test.csv")
train <- read.csv("train.csv")

#factorizing 
train_factor <- train
train_factor$weather <- factor(train$weather)
train_factor$holiday <- factor(train$holiday)
train_factor$workingday <- factor(train$workingday)
train_factor$season <- factor(train$season)

test_factor <- test
test_factor$weather <- factor(test$weather)
test_factor$holiday <- factor(test$holiday)
test_factor$workingday <- factor(test$workingday)
test_factor$season <- factor(test$season)

#create time column by stripping out timestamp
train_factor$time <- substring(train$datetime,12,20)
test_factor$time <- substring(test$datetime,12,20)
str(train_factor)

#factorize new timestamp column
train_factor$time <- factor(train_factor$time)
test_factor$time <- factor(test_factor$time)

#create day of week column
train_factor$day <- weekdays(as.Date(train_factor$datetime))
train_factor$day <- as.factor(train_factor$day)
test_factor$day <- weekdays(as.Date(test_factor$datetime))
test_factor$day <- as.factor(test_factor$day)

aggregate(train_factor[,"count"],list(train_factor$day),mean)

#create Sunday variable
train_factor$sunday[train_factor$day == "Sunday"] <- "1"
train_factor$sunday[train_factor$day != "1"] <- "0"

test_factor$sunday[test_factor$day == "Sunday"] <- "1"
test_factor$sunday[test_factor$day != "1"] <- "0"

#convert to factor
train_factor$sunday <- as.factor(train_factor$sunday)
test_factor$sunday <- as.factor(test_factor$sunday)

#convert time and create $hour as integer to evaluate
train_factor$hour<- as.numeric(substr(train_factor$time,1,2))
test_factor$hour<- as.numeric(substr(test_factor$time,1,2))


#convert hour back to factor
train_factor$hour <- as.factor(train_factor$hour)
test_factor$hour <- as.factor(test_factor$hour)

#install party package
#install.packages('party')
library('party')

#build our formula
formulaCasual <- casual ~ season + holiday + workingday + weather + temp + atemp + humidity + hour + sunday
formulaRegistered <- registered ~ season + holiday + workingday + weather + temp + atemp + humidity + hour + sunday

#build our model
fitCasual.ctree <- ctree(formulaCasual, data=train_factor)
fitRegistered.ctree <- ctree(formulaRegistered, data=train_factor)

fitCasual.cforest <- cforest(formulaCasual, data=train_factor)
fitRegistered.cforest <- cforest(formulaRegistered, data=train_factor)

#examine model for variable importance
fitCasual.cforest
fitRegistered.cforest

#run model against test data set
predictCasual.ctree <- predict(fitCasual.ctree, test_factor)
predictRegistered.ctree <- predict(fitRegistered.ctree, test_factor)

all.ctree <- predictCasual.ctree+predictRegistered.ctree
#build a dataframe with our results
submit.ctree <- data.frame(datetime = test$datetime, count=floor(all.ctree))

#write results to .csv for submission
write.csv(submit.ctree, file="submitionWithTreeesVersion1.csv",row.names=FALSE)

#fitRegistered.cforest <- cforest(formulaRegistered, data=train_factor,controls=cforest_unbiased(ntree=50))
#forestRegisteredTest <- treeresponse(fitRegistered.cforest, newdata=test_factor, OOB = TRUE)
#forestCasualTestValues <-sapply(forestCasualTest, function(x){as.numeric(x[1])})
#forestRegisteredTestValues <-sapply(forestRegisteredTest, function(x){as.numeric(x[1])})
#allValuesAre <-forestCasualTestValues+forestRegisteredTestValues