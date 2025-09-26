#' @title Download NWIS Stage Data
#' @description This function fetches daily mean gage height (water stage) data from the USGS National Water Information System (NWIS) for a specified list of sites and date range using the `dataRetrieval` package.
#'
#' @param sites A character vector of USGS monitoring location IDs.
#' @param start_date A character string for the start date of the data query, in 'YYYY-MM-DD' format.
#' @param end_date A character string for the end date of the data query, in 'YYYY-MM-DD' format.
#' @param parameterCd A character string of the USGS parameter code. Defaults to "00065" for Gage height.
#'
#' @return A tibble (`data.frame`) containing the daily stage data. The column names follow the conventions of the `dataRetrieval` package.
#'
download_nwis_stage_data <- function(sites,start_date,end_date,parameterCd="00065"){
  
  # use read_waterdata_daily function from dataRetrieval
  data_out <- read_waterdata_daily(monitoring_location_id=sites,
                                   parameter_code=parameterCd,
                                   statistic_id="00003",
                                   time=c(start_date,end_date))
  
  return(data_out)
}