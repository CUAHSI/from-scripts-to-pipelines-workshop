
library(targets)

tar_option_set(
  packages = c(
    'tidyverse',
    'dataRetrieval',
    'httr2',
    'tools',
    'sf',
    'xml2',
    'leaflet',
    'RColorBrewer',
    'htmlwidgets',
    'tigris'
  )
)

# Set 01_fetch pipeline configurations
# site and date inputs
harvey_sites <- c('08211520','08188500','08030500','08162000','08014800')
start_date <- "2017-08-25" # Date samples begin
end_date <- "2017-09-12" # Date samples end
# storm inputs
ocean <- "al"
storm_num <- "09"
year <- "2017"

source('01_fetch.R')
source('02_process.R')
source('03_visualize.R')

# Combine all targets from each phase recipe
c(p1,p2,p3)
