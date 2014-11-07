
# Ensure numeric data is to be read properly and Dates will be in English
Sys.setlocale("LC_ALL","C") 

# The uncompressed data is assumed to be found on the current folder:
file<-"household_power_consumption.txt"

###### Read the data between 2007-02-01 and 2007-02-02 
# Speed improvement trick: 
#    Only the required samples will be parsed and stored on a data frame
#    - For that, first load into memory the whole raw data (no parsing is performed)
L<- readLines(file)
# Now find the dates (cheap computing parsing is performed)
skip <- grep("^1/2/2007;", L)[1] - 1      # returns 66637
nrows <- grep("^3/2/2007", L)[1] - skip   # returns 2881
# Note that this includes the 2007-03-01 00:00:00, 
# just for the shake of obtaining the label 'Sat' in an automatic and fancy way
# Read selected data from file:
library(data.table)
x<-fread(file,header=F, sep = ";",  stringsAsFactors = F,  na.strings = "?" , colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")  , skip=skip, nrows=nrows);
# Column Names are missing because fread started at line skip+1...
# Parse names from the in-memory raw file and use them as the colNames for x.
setnames(x,as.character(read.table(file,header=FALSE, sep = ";", colClasses=c("character"), nrows=1)))
rm(L); # the raw data is no longer to be used 

############## 
# # plot1.png : red histrogram of Global_active_power
##############
# 1st  : Open PNG output device with the required sized
png(filename = "plot1.png", width = 480, height = 480, pointsize = 12);

# 2nd: plot Histogram with a default number of bins.
hist(x$Global_active_power,col="red", main="Global active power",xlab="Global active power (kilowatts)",ylab="Frequency");

# Last: End  and save PNG plot :
dev.off();
