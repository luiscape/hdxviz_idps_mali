# quick analysis of the idp mali data
library(reshape2)
library(ggplot2)

# loading data for time series
data <- read.csv('data/output_2.csv')
x <- melt(data)

# cleaning
x$PCODE <- NULL
x$Country <- NULL
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


# loading data for scatter plot
data <- read.csv('data/output_population.csv')



####################################
####################################
######### Storing for C3 ###########
####################################
####################################
write.csv(y, 'http/data/idp_data_timeseries.csv', row.names = F)
write.csv(data, 'http/data/idp_data_scatterplot.csv', row.names = F)


####################################
####################################
######### Plotting Things ##########
####################################
####################################

ggplot(x) + theme_bw() +
  geom_line(aes(variable, value, color = Name), size = 1.3)
