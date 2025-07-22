download_nwis_stage_data <- function(sites,start_date,end_date,parameterCd="00065"){
  
  # initialize data frame
  data_out <- data.frame()
  
  # loop through sites to download 
  for (site in sites){
    
    site_data <- download_nwis_site_data(site,start_date,end_date,parameterCd)
    
    # read the downloaded data and append it to the existing data.frame
    data_out <- bind_rows(data_out, site_data)
  }
  return(data_out)
}
  

download_nwis_site_data <- function(site_num, start_date, end_date, parameterCd){
  
  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdv(
    siteNumbers=site_num,
    parameterCd=parameterCd,
    startDate=start_date,
    endDate=end_date
  )
  
  return(data_out)
}