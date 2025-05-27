# Instructions:
# Question: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999–2008 for 
# Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting 
# system to make a plot answer this question.

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
# each year, source type & with a variable for the sum total of PM2.5 emissions. 

bcNEI <- subset(NEI, fips == "24510")
bc_type_total <- aggregate(Emissions ~ year + type, data = bcNEI, FUN = sum)

# Plot Baltimore City's "Total Emissions" from 1999 to 2008 (data gathered every 3 years) separated 
# by type onto a .png file.

png("plot3.png", width = 680, height = 480)
g <- ggplot(data = bc_type_total, aes(x = year, y = Emissions, color = type)) +
    geom_point(size = 2) + 
    geom_line(size = 1) +
    labs(title = "PM2.5 Emissions in Baltimore City by Source Type (1999 to 2008)",
         x = "Year",
         y = "PM2.5 Emissions (Tons)",
         color = "Source Type")
print(g)
dev.off()