download_nhc_best_track <- function(storm_id){
  
  # ocean <- "al"
  # storm_num <- "09"
  # year <- "2017"
  
  nhc_url <- "http://www.nhc.noaa.gov/gis/best_track/%s_best_track.zip"
  download_url <- sprintf(nhc_url,storm_id)
  
  # Define path to download the zip file
  zip_path <- file.path("01_fetch/tmp", basename(download_url))
  
  # Download the file
  download.file(download_url, destfile = zip_path, mode = "wb")
  
  # # Extract the zip file
  # extracted_files <- unzip(zip_path, exdir = '01_fetch/tmp')
  # 
  # request(download_url)
  
  return(zip_path)
  
}
