# Instructions
# Question: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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

# Filter NEI data frame for Baltimore City motor vehicle soruces. 
bc_vehicles <- NEI %>%
    filter(fips == "24510") %>%
    filter(SCC %in% vehicles_scc$SCC)

# Summarize (reframe) data, sum 'Emissions' by year. 
bc_vehicles_sum <- bc_vehicles %>% 
    group_by(year) %>%
    reframe(Emissions = sum(Emissions))

# Plot Emissions of motor vehicles sources in Baltimore City by year to a .png graphics device.
png("plot5.png", width = 640, height = 480)
print(
    ggplot(bc_vehicles_sum, aes(x = year, y = Emissions)) +
        geom_point(size = 2, color = "purple") +
        geom_line(size = 1, color = "thistle2") + 
        labs(title = "PM2.5 Emissions from Motor Vehicle Sources in Baltimore City (1999 - 2008)",
             xlab = "Year",
             ylab = "Total Emissions (Tons)") + 
        theme_minimal()
)
dev.off()