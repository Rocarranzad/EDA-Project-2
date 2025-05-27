# Instructions:
# Question: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for 
# each of the years 1999, 2002, 2005, and 2008.

# Load relevant package. 

library(tidyverse)

# Download data. The zip file contains two files: 
# PM2.5 Emissions Data (summarySCC_PM25.rds)
# Source Classification Code Table (Source_Classification_Code.rds)

if (!file.exists("data")) {
    dir.create("data")
    fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url = fileurl, destfile = "./data/NEI_data.zip")
    dateDownloaded <- date()
    unzip("./data/NEI_data.zip", exdir = "./data")
    file.remove("./data/NEI_data.zip")
}

NEI <- read_rds("./data/summarySCC_PM25.rds")
SCC <- read_rds("./data/Source_Classification_Code.rds")

# Create a table with with an observation for each year & with a variable for the sum total 
# of PM2.5 emissions. 
Total_Year <- aggregate(Emissions ~ year, data = NEI, FUN = sum)
Total_Year$Emissions <- Total_Year$Emissions / 1e6

# Plot "Total Emissions" from 1999 to 2008 (data gathered every 3 years) onto a .png file.
png("plot1.png", width = 640, height = 480)
plot(x = Total_Year$year, y = Total_Year$Emissions, 
     type = "b", lwd = 2, col = "blue",
     main = "Total PM2.5 Emissions, All Sources (1999 to 2008)",
     xlab = "Year",
     ylab = "Total Emissions (Million Tons)")
grid()
dev.off()