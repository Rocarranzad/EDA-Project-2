# Instructions
# Question: Compare emissions from motor vehicle sources in Baltimore City with emissions from 
# motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen 
# greater changes over time in motor vehicle emissions?

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

# Load .rds files. 
NEI <- read_rds("./data/summarySCC_PM25.rds")
SCC <- read_rds("./data/Source_Classification_Code.rds")

# Identify motor vehicle sources.
vehicles_scc <- SCC %>%
    filter(str_detect(EI.Sector, "Vehicles")) %>%
    select(SCC)

# Filter NEI data frame for Baltimore City ("24510") and Los Angeles County ("06037") motor vehicle sources. 
city_vehicles <- NEI %>%
    filter(fips %in% c("24510", "06037")) %>%
    filter(SCC %in% vehicles_scc$SCC)

# Rename fips to city names so plotting is easier.
city_vehicles$fips[city_vehicles$fips == "24510"] <- "Baltimore City"
city_vehicles$fips[city_vehicles$fips == "06037"] <- "Los Angeles County"

# Summarize (reframe) both data frames, sum 'Emissions' by year. 
city_vehicles_sum <- city_vehicles %>% 
    group_by(year, fips) %>%
    reframe(Emissions = sum(Emissions))

# Plot Emissions of motor vehicles sources in Baltimore City by year to a .png graphics device.
png("plot6.png", width = 640, height = 480)
print(
    ggplot(city_vehicles_sum, aes(x = year, y = Emissions, color = fips)) +
        geom_point(pch = 21, size = 2) +
        geom_line(size = 0.5) + 
        labs(title = "PM2.5 Emissions from Motor Vehicle Sources in Baltimore City and Los Angeles County (1999 - 2008)",
             xlab = "Year",
             ylab = "Total Emissions (Tons)",
             color = "County") + 
        theme_minimal()
)
dev.off()