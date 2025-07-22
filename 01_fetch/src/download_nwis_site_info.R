download_nwis_site_info <- function(site_data){
  
  # readNWISsite is from the dataRetrieval package
  site_no <- unique(site_data$site_no)
  site_info <- readNWISsite(site_no)

  return(site_info)
}