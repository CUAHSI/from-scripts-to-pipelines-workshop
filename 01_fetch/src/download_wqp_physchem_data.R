
#' @title Download WQP data using dataRetrieval fxns
#' @description This function downloads data from the Water Quality Portal (WQP)
#' using the functions in the package `dataRetrieval`. Given a state, county,
#' and date range, the function will return the sample results for physical and
#' chemical from water media stored in WQP.
#' 
#' @param state character string giving the full state name, e.g. "Wisconsin"
#' @param county character string giving the full county name, e.g. "Brown"
#' @param start_date character or Date value giving the first date to include,
#' expects the string to be formatted as `YYYY-MM-DD`
#' @param end_date character or Date value giving the last date to include,
#' expects the string to be formatted as `YYYY-MM-DD`
#' 
download_wqp_physchem_data <- function(state, county, start_date, end_date) {
  wqp_data <- readWQPdata(service = "Result", # This is currently set to WQX legacy
                          profile = "resultPhysChem",
                          sampleMedia = c('water', 'Water'),
                          characteristicName = c('Chloride', 
                                                 'Phosphorus', 
                                                 'Nitrate'), 
                          statecode = state,
                          countycode = county,
                          startDateLo = start_date,
                          startDateHi = end_date)
  if(length(wqp_data$MonitoringLocationIdentifier) == 0) {
    stop('No data returned. Choose a new location.')
  } else {
    return(wqp_data) 
  }
}
