read_nwis_site_info <- function(site_data, out_file){
  
  # readNWISsite is from the dataRetrieval package
  site_no <- unique(site_data$site_no)
  site_info <- readNWISsite(site_no)
  write_csv(site_info, out_file)
  return(site_info)
}