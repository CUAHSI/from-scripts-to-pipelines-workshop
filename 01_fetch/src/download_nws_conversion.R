#' @title Download NWS-USGS Site Conversion Data
#' @description This function downloads and combines site cross-reference tables from the National Center for Environmental Prediction (NCEP) HADS system for Texas (TX) and Louisiana (LA). This table links USGS site numbers to their corresponding NWS ID.
#'
#' @return A combined tibble (`data.frame`) containing the USGS-to-NWS site conversion data for the TX and LA regions.
#'
download_nws_conversion <- function(){

  url_tx <- "https://hads.ncep.noaa.gov/USGS/TX_USGS-HADS_SITES.txt"
  url_la <- "https://hads.ncep.noaa.gov/USGS/LA_USGS-HADS_SITES.txt"
  
  conversion_table <- create_table(url_tx) %>%
    bind_rows(create_table(url_la))
  
  return(conversion_table)
}

#' @title Create USGS-NWS Site Conversion Table
#' @description This is a helper function that reads a pipe-delimited text file from the NCEP HADS website and converts it into a clean data frame with standardized column names for site conversion.
#'
#' @param url A character string representing the URL to the HADS text file (e.g., for TX or LA).
#'
#' @return A tibble (`data.frame`) with site cross-reference information and columns:
#' "NWS", "USGS", "GOES", "NWS HSA", "lat", "lon", and "name". The "USGS" column is stripped of spaces.
#'
create_table <- function(url){

  table <- read_delim(url,delim = "|",skip = 4,col_names = FALSE)
  names(table) <- c("NWS","USGS","GOES","NWS HSA","lat","lon","name")
  table$USGS <- gsub(" ","", table$USGS)
  
  return(table)
  
}