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
png(filename = "plot1.png", width = 480, height = 480, units = "px")

# Creating plot1 histogram
hist(hpc$Global_active_power, col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")

# Closing graphics device
dev.off()

# Removing data and values created from global environment
rm("hpc")
rm("destfile")
rm("fileurl")

# Deleting files created for this script
file.remove("eda_project1.zip")
file.remove("household_power_consumption.txt")