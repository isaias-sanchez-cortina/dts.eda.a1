# Assigment 1. Plot 2 . By Isaias Sanchez Cortina (isanchez@doctor.upv.es)

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
# plot2.png : time series of Global_active_power
#             x axes shows "Thu  Fri Sat" labels
##############

# 1st  : Open PNG output device with the required sized
png(filename = "plot2.png", width = 480, height = 480);

# 2nd  : Plot the series Global_active_power vs. ellapsed time in minutes 
  # ... Create a new column indicating the absolute minuted ellapsed from  1/2/2007.
  # NOTE: This is unnecesary, since the resulting column will be simply = 0..(Number of rows -1)
  # But this method will also work with unevenly time-spaced samples and/or missing values.
  origin<- as.numeric(as.POSIXct("1/2/2007", format = "%d/%m/%Y")) ; # cache numeric 1/2/2007
  x[, Minute:=(as.numeric(as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S"))-origin)/60]  
# Plot with lines and w/o title nor xlabel. Neither the axes and box will be shown
#   (axes=F) to allow customization of the x-bottom axes as required in the assigment.
plot(x$Minute, x$Global_active_power, ylab="Global active power (kilowatts)", xlab="", type="l",axes=F);

# 3rd: Draw the missing box and Add Y-axis:
box() ; axis(2); 

# 4th: Draw a customized X-axis with weekdays as labels. 
  # ... Number of tick marks /labels as on the reference fig.
  steps<-3; 
  # ... indexes of the rows correspoding to tick marks:
  marksAt=seq(1 , length(x$Date) , length.out=steps); 
  mytickmarks <- x$Minute[marksAt];
  # ... Now I use a fancy method to automatically generate the labels.
  #     Of course, the following code is equivalent to simply set:
  #     mylabels <- c("Thu","Fri","Sat")
  mylabels <- x[,weekdays(as.POSIXct(Date,format="%d/%m/%Y"),TRUE) ][marksAt]
# Draw X-axis:
axis(1, at = mytickmarks , labels = mylabels )

# Last: End  and save PNG plot :
dev.off();
