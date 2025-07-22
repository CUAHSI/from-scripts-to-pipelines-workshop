download_nws_conversion <- function(){

  url_tx <- "https://hads.ncep.noaa.gov/USGS/TX_USGS-HADS_SITES.txt"
  url_la <- "https://hads.ncep.noaa.gov/USGS/LA_USGS-HADS_SITES.txt"
  
  conversion_table <- create_table(url_tx) %>%
    bind_rows(create_table(url_la))
  
  return(conversion_table)
}

create_table <- function(url){

  table <- read_delim(url,delim = "|",skip = 4,col_names = FALSE)
  names(table) <- c("NWS","USGS","GOES","NWS HSA","lat","lon","name")
  table$USGS <- gsub(" ","", table$USGS)
  
  return(table)
  
}