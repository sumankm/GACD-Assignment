
rm(list = ls())

x <- rep(c("a", "b", "c"), 20)
y <- rep(c(1, 1, 0), 20)

class(x)  # -> "character"
class(y)  # -> "numeric"

x1 <- factor(x)
y1 <- factor(y)

class(x1)  # -> "factor"
class(y1)  # -> "factor"

library(varhandle)
x2 <- unfactor(x)
y2 <- unfactor(y)

class(x2)  # -> "character"
class(y2)  # -> "numeric"


z <- factor(c("A","B","C","D","A")); 
as.numeric(levels(z))[z] 

