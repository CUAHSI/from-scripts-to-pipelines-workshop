#' @title Download flood stage data from the National Weather Service
#' @description This function downloads current flood stage information from the 
#' National Weather Service (NWS) API for a specified list of U.S. Geological Survey 
#' (USGS) sites. It uses a provided cross-reference table to convert the USGS site
#' numbers to their corresponding NWS IDs, then loops through each NWS ID to make
#' an API request. The function returns a tibble with the original site data along 
#' with the newly retrieved flood stage and units.
#' 
#' @param nws_conversion A data.frame or tibble that acts as a cross-reference 
#' between USGS and NWS site identifiers. It must contain at least two columns: 
#' a USGS column with USGS site numbers and a NWS column with the corresponding 
#' NWS IDs.
#' @param sites A character vector of USGS site numbers for which to download flood
#'stage data.
#' 
#' @return A tibble with a row for each site requested. The output includes the 
#' original site_no column along with new columns for the corresponding NWS ID, 
#' flood stage (the value of the minor flood stage), and stage units.
#' 
download_nws_data <- function(nws_conversion, sites){

  sites <- tibble("site_no"=sub("USGS-", "", sites)) %>%
    left_join(select(nws_conversion, NWS, USGS), 
              by = c("site_no"="USGS"))
  
  # Setup an empty table to build
  flood_stage_xwalk <- tibble()
  # For each site, capture the flood stage and units
  for(i in sites$NWS){
    
    url <- paste0("https://api.water.noaa.gov/nwps/v1/gauges/",i)
    
    response_data <- request(url) %>%
      req_perform() %>%
      resp_body_json()
    
    flood_stage_xwalk <- flood_stage_xwalk %>% 
      bind_rows(tibble(NWS = i,
                       flood_stage = response_data$flood$categories$minor$stage,
                       stage_units = response_data$flood$stageUnits))
  }
  # Join the flood information with the site data
  sites <- sites %>% 
    left_join(flood_stage_xwalk, by = 'NWS')
  
  return(sites)
}