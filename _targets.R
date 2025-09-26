# import targets library
library(targets)

# define packages needed to execute pipeline
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

# define inputs to pipeline
# USGS gage sites by ID
harvey_sites <- c('USGS-08211520','USGS-08188500','USGS-08030500','USGS-08162000','USGS-08014800')
# start date for retrieving stage data
start_date <- "2017-08-25"
# end date for retrieving stage data
end_date <- "2017-09-12"
# Hurricane Harvey inputs to feed into National Hurricane Center (NHC) query
ocean <- "al"
storm_num <- "09"
year <- "2017"

# import files for each phase receipt
source('01_fetch.R')
source('02_process.R')
source('03_visualize.R')

# combine all targets
c(p1,p2,p3)
