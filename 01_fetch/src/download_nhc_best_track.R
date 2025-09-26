#' @title Download National Hurricane Center (NHC) Best Track Data
#' @description This function downloads the 'best track' data (containing storm location and intensity at regular intervals) for a specified tropical cyclone from the NHC's GIS best track archive.
#'
#' @param storm_id A character string representing the NHC storm identifier,
#' typically in the format "ocean+storm_num+year" (e.g., "al092017" for Harvey).
#'
#' @return A character string representing the file path to the downloaded
#' ZIP file in the temporary fetch directory (`01_fetch/tmp`).
#'
download_nhc_best_track <- function(storm_id){
  
  nhc_url <- "http://www.nhc.noaa.gov/gis/best_track/%s_best_track.zip"
  download_url <- sprintf(nhc_url,storm_id)
  
  # Define path to download the zip file
  zip_path <- file.path("01_fetch/tmp", basename(download_url))
  
  # Download the file
  download.file(download_url, destfile = zip_path, mode = "wb")
  
  return(zip_path)
  
}
