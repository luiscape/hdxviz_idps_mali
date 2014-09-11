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

# calculating averages
for(i in 1:nrow(y)) {
  y$Average[i] <- rowMeans(y[i, 2:ncol(y)])
}

y$Average <- ceiling(y$Average)


# calculating totals
for(i in 1:nrow(y)) {
  y$Total[i] <- sum(y[i, 2:ncol(y)])
}

total_data <- data.frame(date = y$date, total = y$Total)


# loading data for scatter plot
data <- read.csv('data/output_population.csv')



####################################
####################################
######### Storing for C3 ###########
####################################
####################################
write.csv(total_data, 'http/data/idps_total_data.csv', row.names = F)
write.csv(y, 'http/data/idp_data_timeseries.csv', row.names = F)
write.csv(data, 'http/data/idp_data_scatterplot.csv', row.names = F)


####################################
####################################
######### Plotting Things ##########
####################################
####################################

ggplot(x) + theme_bw() +
  geom_line(aes(variable, value, color = Name), size = 1.3)
