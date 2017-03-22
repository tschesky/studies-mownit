library(mlbench)
library(caret)

data(Sonar)

set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)


set.seed(825)
gbmFit1 <- train(Class ~ ., data = training,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)

set.seed(666)
gbmFit2 <- train(Class ~ ., data = training,
                 method = "leapBackward",
                 trControl = fitControl)

print(gbmFit1)
estimate <- predict(gbmFit1, newdata = testing)

remove(Sonar)
remove(inTraining)
remove(testing)
remove(training)
remove(fitControl)
remove(gbmFit1)