download_nhc_best_track <- function(storm_id){
  
  nhc_url <- "http://www.nhc.noaa.gov/gis/best_track/%s_best_track.zip"
  download_url <- sprintf(nhc_url,storm_id)
  
  # Define path to download the zip file
  zip_path <- file.path("01_fetch/tmp", basename(download_url))
  
  # Download the file
  download.file(download_url, destfile = zip_path, mode = "wb")
  
  return(zip_path)
  
}
