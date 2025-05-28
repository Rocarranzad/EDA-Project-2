# Instructions
# Questions: Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999–2008?

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

# Identify coal combustion-related sources.
coal_combustion_scc <- SCC %>%
    filter(str_detect(Short.Name, "Coal"), str_detect(SCC.Level.One, "Combustion")) %>%
    select(SCC)

# Filter NEI data set to include only coal combustion-related sources.
coal_nei <- NEI %>%
    filter(SCC %in% coal_combustion_scc$SCC)

# Summarize (reframe) data, sum 'Emissions' by year. 
coal_nei_sum <- coal_nei %>% 
    group_by(year) %>%
    reframe(Emissions = sum(Emissions))

# Plot Emissions of coal combustion_related sources by year to a .png graphics device.
png("plot4.png", width = 640, height = 480)
print(
    ggplot(coal_nei_sum, aes(x = year, y = Emissions)) +
        geom_point(size = 2, color = "sienna1") +
        geom_line(size = 1, color = "tomato") + 
        labs(title = "PM2.5 Emissions from Coal Combustion-Related Sources (1999 - 2008)",
             xlab = "Year",
             ylab = "Total Emissions (Tons)") + 
        theme_minimal()
)
dev.off()