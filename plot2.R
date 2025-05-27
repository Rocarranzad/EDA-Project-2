# Instructions 
# Question: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this 
# question.

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

# Subset monitor readings from Baltimore City, Maryland create a table with with an observation for 
# each year & with a variable for the sum total of PM2.5 emissions. 
bcNEI <- subset(NEI, fips == "24510")
bcTotal_Year <- aggregate(Emissions ~ year, data = bcNEI, FUN = sum)
bcTotal_Year$Emissions <- bcTotal_Year$Emissions / 1e3

# Plot Baltimore City's "Total Emissions" from 1999 to 2008 (data gathered every 3 years) onto a 
# .png file.
png("plot2.png", width = 640, height = 480)
plot(x = bcTotal_Year$year, y = bcTotal_Year$Emissions, 
     type = "b", lwd = 2, col = "salmon",
     main = "Baltimore City's Total PM2.5 Emissions, All Sources (1999 to 2008)",
     xlab = "Year",
     ylab = "Total Emissions (Thousand Tons)")
grid()
dev.off()