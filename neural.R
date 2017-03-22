require(quantmod)
require(nnet)
require(caret)

y <- sin(seq(0, 20, 0.1))
te <- data.frame(y, x1=Lag(y), x2=Lag(y,2))
names(te) <- c("y", "x1", "x2")

model <- train(y ~ x1 + x2, te, method='nnet', linout=TRUE, trace = FALSE,
               #Grid of tuning parameters to try:
               tuneGrid=expand.grid(.size=c(1,5,10),.decay=c(0,0.001,0.1))) 

ps <- predict(model, te)
ps

print(model)
plot(y)
lines(ps, col=2)

remove(te)
remove(model)
remove(ps)
remove(y)