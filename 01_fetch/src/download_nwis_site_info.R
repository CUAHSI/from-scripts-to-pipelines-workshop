#' @title Download NWIS Site Information
#' @description This function retrieves descriptive information and geographic coordinates for a list of specified USGS sites using the `dataRetrieval` package's `read_waterdata_monitoring_location` function.
#'
#' @param site_num A character vector of USGS site numbers (e.g., 'USGS-08211520').
#'
#' @return An `sf` object (simple features data frame) containing the site information,
#' including site ID, name, and location geometry.
#'
download_nwis_site_info <- function(site_num){
  
  # use read_waterdata_monitoring_location function from dataRetrieval
  site_info <- read_waterdata_monitoring_location(site_num)

  return(site_info)
}