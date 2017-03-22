inData <- scan("C:/Users/Micha³/Desktop/in.txt", sep=",")
outData <- scan("C:/Users/Micha³/Desktop/out.txt", sep=",")
myFrame <- data.frame(inData, outData)
meanIn <- mean(myFrame$inData)
myFrame$inData <- myFrame$inData - meanIn
plot(myFrame$inData, myFrame$outData, type="b")

fit <- lm(myFrame$outData ~ poly(myFrame$inData, 8, raw=TRUE))
print(summary(fit))


plot(myFrame$inData, myFrame$outData, type="p", lwd=3)
equation <- function(x) fit$coefficient[9]*x^8 + fit$coefficient[8]*x^7 + fit$coefficient[7]*x^6+ fit$coefficient[6]*x^5 + fit$coefficient[5]*x^4 + fit$coefficient[4]*x^3 + fit$coefficient[3]*x^2 + fit$coefficient[2]*x + fit$coefficient[1]
curve(equation, from = -5, to = 5, col="red", lwd=2)
points(myFrame$inData, myFrame$outData, type="p", lwd=3)

remove(inData)
remove(outData)
remove(myFrame)
remove(meanIn)
remove(fit)
remove(equation)



