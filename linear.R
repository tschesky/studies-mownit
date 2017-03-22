inData <- scan("C:/Users/Micha³/Desktop/in.txt", sep=",")
outData <- scan("C:/Users/Micha³/Desktop/out.txt", sep=",")

myFrame <- data.frame(inData, outData)
plot(myFrame$inData, myFrame$outData, type ="b")

print(cor(myFrame$inData, myFrame$outData))

fit <- lm(outData ~ inData)
print(fit)
abline(fit)

remove(inData)
remove(outData)
remove(myFrame)
remove(fit)