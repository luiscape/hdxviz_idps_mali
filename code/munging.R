# quick analysis of the idp mali data
library(reshape2)
library(ggplot2)

data <- read.csv('data/output_2.csv')
x <- melt(data)

# cleaning
x$variable <- sub("X", "", x$variable)
x$variable <- sub("\\.", "-", x$variable)
x$variable <- sub("\\.", "-", x$variable)
x$variable <- as.Date(x$variable)
names(x) <- c('name', 'date', 'value')

# casting
y <- dcast(x, date ~ name)

# calculating totals
for(i in 1:nrow(y)) {
  y$Total[i] <- sum(y[i, 2:ncol(y)])
}

# making cumulative calculation
z <- y
for (i in 1:(nrow(z)-1)) {
  z[i + 1, 2:ncol(z)] <- z[i, 2:ncol(z)] + z[i + 1, 2:ncol(z)]
}




####################################
####################################
######### Storing for C3 ###########
####################################
####################################
write.csv(y, 'http/data/idp_data.csv', row.names = F)
write.csv(z, 'http/data/idp_data_cummulative.csv', row.names = F)


####################################
####################################
######### Plotting Things ##########
####################################
####################################

ggplot(x) + theme_bw() +
  geom_line(aes(variable, value, color = Name), size = 1.3)
