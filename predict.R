require(quantmod)
require(nnet)
require(caret)
require(neuralnet)

# Data as lists
inData <- read.table("C:/Users/Micha³/Desktop/Mownity/Parser/annealing/input.txt")
outData <- read.table("C:/Users/Micha³/Desktop/Mownity/Parser/annealing/output.txt")

# Combined data frames
combinedData <- data.frame(inData, outData)
colnames(combinedData) <- c("I1", "I2", "I3","I4" ,"I5", "O1")

set.seed(998)
inTraining <- createDataPartition(combinedData$O1, p =.75, list=FALSE)
training <- combinedData[inTraining,]
testing <- combinedData[-inTraining,]

# Resampling, chosen k-fold cross validation
fitControl <- trainControl( method = "repeatedcv",
                            number = 20,
                            repeats = 20)

# Resampling, chosen k-fold cross validation
fitControlPLS <- trainControl( method = "repeatedcv",
                            number = 80,
                            repeats = 80)

# Tuning grid
gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9),
                        n.trees = (1:3)*50,
                        shrinkage = 0.1)

# Fit the model - Stochastic Gradient Boosting 
set.seed(825)
gbmFit3 <- train( O1 ~ I1 + I2 + I3 + I4 + I5, data = training,
                  method = "gbm",
                  trControl = fitControl,
                  verbose = FALSE,
                  tuneGrid = gbmGrid)

# Fit the model - Partial least squares
set.seed(1234)
gbmFit3 <- train( O1 ~ I1 + I2 + I3 + I4 + I5, data = training,
                  method = "pls",
                  ncomp = 10,
                  trControl = fitControl)



# Quantile Regression Forests
XTrain <- combinedData[inTraining, 1:5]
XTest <- combinedData[-inTraining, 1:5]
YTrain <- combinedData[inTraining, 6]
YTest <- combinedData[-inTraining, 6]

qrf <- quantregForest(x=XTrain, y=YTrain, mtry = 3, nodesize = 50, ntree = 50)
plot(qrf)
quant.outofbag <-predict(qrf)
quant.newdata <-predict(qrf, newdata=XTest)

newdataFrame <- data.frame(quant.newdata)
colnames(newdataFrame) <- c("q1", "q2", "q3")


# Predict the values
estimate <- predict(gbmFit3, newdata = testing)

estimateFrame = data.frame(estimate)
variance = testing$O1 - estimateFrame$estimate
meanVariance <- mean(abs(variance))
print(meanVariance)

# Prints
print(gbmFit1)
print(gbmFit2)
print(gbmFit3)
print(estimate)
print(estimate2)

# Quantile regression forests
quantileRegressionForests <- function(tries, node, trees){
  
  # Data as tables
  inData <- read.table("C:/Users/Micha³/Desktop/Mownity/Parser/annealing/input.txt")
  outData <- read.table("C:/Users/Micha³/Desktop/Mownity/Parser/annealing/output.txt")
  
  # Combined data frames
  combinedData <- data.frame(inData, outData)
  colnames(combinedData) <- c("I1", "I2", "I3","I4" ,"I5", "O1")
  
  ## Quantile Regression Forests training set
  set.seed(998)
  inTraining <- createDataPartition(combinedData$O1, p =.75, list=FALSE)
  XTrain <- combinedData[inTraining, 1:5]
  XTest <- combinedData[-inTraining, 1:5]
  YTrain <- combinedData[inTraining, 6]
  YTest <- combinedData[-inTraining, 6]
  
  # Predict the data
  qrf <- quantregForest(x=XTrain, y=YTrain, mtry = tries, nodesize = node, ntree = trees)
  plot(qrf)
  quant.outofbag <-predict(qrf)
  quant.newdata <-predict(qrf, newdata=XTest)
  
  newdataFrame <- data.frame(quant.newdata)
  colnames(newdataFrame) <- c("q1", "q2", "q3")
  
  variance = testing$O1 - newdataFrame
  meanVariance <- mean(abs(variance$estimate))
  meanInput <- mean(combinedData$O1)
  print(meanInput)
  print(meanVariance)
}


# Gradient boosting function
stochasticGradientBoosting <- function( knumbers, krepeats, useGrid, depth, treesNo, shrink){
  
  # Data as tables
  inData <- read.table("C:/Users/Micha³/Desktop/Mownity/Parser/annealing/input.txt")
  outData <- read.table("C:/Users/Micha³/Desktop/Mownity/Parser/annealing/output.txt")
  
  # Combined data frames
  combinedData <- data.frame(inData, outData)
  colnames(combinedData) <- c("I1", "I2", "I3","I4" ,"I5", "O1")
  
  # Create training sets
  set.seed(998)
  inTraining <- createDataPartition(combinedData$O1, p =.75, list=FALSE)
  training <- combinedData[inTraining,]
  testing <- combinedData[-inTraining,]
  
  # Resampling, chosen k-fold cross validation
  fitControl <- trainControl( method = "repeatedcv",
                              number = knumbers,
                              repeats = krepeats)
  
  # Use or don't use grid
  if(useGrid){
    
    # Tuning grid
    gbmGrid <-  expand.grid(interaction.depth = depth,
                            n.trees = treesNo,
                            shrinkage = shrink)
    
    # Fit the model with user-defined grid
    set.seed(825)
    gbmFit <- train( O1 ~ I1 + I2 + I3 + I4 + I5, data = training,
                      method = "gbm",
                      trControl = fitControl,
                      verbose = FALSE,
                     tunegrid = gbmGrid)
  } else{
    
    # Fit the model without user-defined grid
    set.seed(825)
    gbmFit <- train( O1 ~ I1 + I2 + I3 + I4 + I5, data = training,
                     method = "gbm",
                     trControl = fitControl,
                     verbose = FALSE)  
  }
  
  # Print the model
  print(gbmFit)
  
  # Predict the output
  estimate <- predict(gbmFit, newdata = testing)
  
  # Calculate mean variance
  estimateFrame = data.frame(estimate)
  variance = testing$O1 - estimateFrame
  meanVariance <- mean(abs(variance$estimate))
  print(meanVariance)
}


#Remove crap
remove(XTest)
remove(XTrain)
remove(quant.newdata)
remove(quant.outofbag)
remove(YTest)
remove(YTrain)
remove(estimate2)
remove(gbmFit2)
remove(qrf)
remove(inData)
remove(outData)   
remove(combinedData)
remove(inTraining)
remove(testing)
remove(training)
remove(fitControl)
remove(inDataFrame)
remove(outDataFrame)
remove(gbmFit1)
remove(estimate)
remove(gbmGrid)
remove(estimateFrame)
remove(variance)
remove(fitControlPLS)
remove(gbmFit3)
remove(newdataFrame)
