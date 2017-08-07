# Downloading the zipfile from the web and saving it in the working directory
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destfile <- paste0(getwd(),"/","eda_project1.zip")
download.file(fileurl, destfile, method = "curl", quiet = TRUE)

# Unziping the downloaded file 
unzip("eda_project1.zip")

# Loading dplyr package
library(dplyr)

# Reading the text file into R
hpc <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, 
                       na.strings = "?")

# Creating a newdate column to filter 
hpc <- mutate(hpc, newdate = 
                      as.POSIXct(Date, 
                                 tz=Sys.timezone(location = TRUE), 
                                 "%d/%m/%Y"))

# Filtering only required dates 
hpc <- filter(hpc, newdate == "2007-02-01" | newdate == "2007-02-02")

# Merging Date and Time columns and then creating a POSIXct "datetime" column 
hpc$datetime <- paste(hpc$Date, hpc$Time)

hpc <- mutate(hpc, newdatetime = 
                      as.POSIXct(datetime, 
                                 tz=Sys.timezone(location = TRUE), 
                                 "%d/%m/%Y %H:%M:%S"))

# Creating png graphic device
png(filename = "plot3.png", width = 480, height = 480, units = "px")

# Creating plot3 line graph
plot(hpc$newdatetime, hpc$Sub_metering_1, type = "l", 
     xlab = "", ylab = "Energy sub metering")
lines(hpc$newdatetime, hpc$Sub_metering_2, type = "l", col = "red")
lines(hpc$newdatetime, hpc$Sub_metering_3, type = "l", col = "blue")

# Creating legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, lwd=1, col=c("black", "red", "blue"))

# Closing graphics device
dev.off()

# Removing data and values created from global environment
rm("hpc")
rm("destfile")
rm("fileurl")

# Deleting files created for this script
file.remove("eda_project1.zip")
file.remove("household_power_consumption.txt")