download_nwis_stage_data <- function(sites,start_date,end_date,parameterCd="00065"){
  
  # initialize data frame
  data_out <- data.frame()
  
  # loop through sites to download 
  for (site in sites){
    
    file_out <- file.path("01_fetch/out", paste0('nwis_', site, '_data.csv'))
    
    these_data <- download_nwis_site_data(file_out,start_date,end_date,parameterCd)
    write_csv(these_data, file = file_out)
    # read the downloaded data and append it to the existing data.frame
    # these_data <- read_csv(download_file, col_types = 'ccTdcc')
    data_out <- bind_rows(data_out, these_data)
  }
  return(data_out)
}
  

download_nwis_site_data <- function(filepath, start_date, end_date, parameterCd){
  
  # filepaths look something like directory/nwis_01432160_data.csv,
  # remove the directory with basename() and extract the 01432160 with the regular expression match
  site_num <- basename(filepath) %>% 
    stringr::str_extract(pattern = "(?:[0-9]+)")
  
  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdv(
    siteNumbers=site_num,
    parameterCd=parameterCd,
    startDate=start_date,
    endDate=end_date
  )
  
  return(data_out)
}