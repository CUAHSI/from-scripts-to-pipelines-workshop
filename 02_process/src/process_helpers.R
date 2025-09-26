#' @title Extract Specific Files from a ZIP Archive
#' @description This function unzips an archive, filters for files matching a regular expression, and copies those files from a temporary directory to a specified output directory.
#'
#' @param zip_file A character string representing the file path to the input ZIP archive.
#' @param out_dir A character string representing the path to the desired output directory for the extracted files.
#' @param file_name_regex A character string containing a regular expression to match the names of the files to be extracted (e.g., ".pts" to get shapefile points).
#'
#' @return A character vector of the file paths for the newly copied, extracted files in the `out_dir`.
#'
extract_files_from_zip <- function(zip_file, out_dir, file_name_regex) {
  
  zipdir <- tempdir()
  
  # List all files within the zip archive
  all_files_in_zip <- unzip(zipfile = zip_file, list = TRUE)$Name
  
  # Filter files based on the provided regular expression
  # This is where the generalization happens
  files_to_extract <- grep(file_name_regex, all_files_in_zip, ignore.case = TRUE, value = TRUE)
  
  # Unzip and extract the identified files
  zip::unzip(zipfile = zip_file,
             files = files_to_extract,
             exdir = zipdir)
  
  # Copy extracted files from the temporary directory to the desired output directory
  extracted_paths <- file.path(zipdir, files_to_extract)
  copied_paths <- file.path(out_dir, basename(files_to_extract))
  
  file.copy(from = extracted_paths,
            to = copied_paths,
            overwrite = TRUE) # Set to TRUE if you want to overwrite existing files
  
  return(copied_paths)
}

#' @title Load and Process Spatial Data File
#' @description This function reads a spatial data file (like a shapefile), transforms its coordinate reference system (CRS) to Web Mercator (EPSG:3857), converts a date/time field, and filters the data to a specified date range.
#'
#' @param sf_fp A character string representing the file path to the spatial data file.
#' @param start_date A character string for the start date for filtering, in 'YYYY-MM-DD' format.
#' @param end_date A character string for the end date for filtering, in 'YYYY-MM-DD' format.
#'
#' @return An `sf` object (simple features data frame) containing the processed and filtered spatial data.
#'
load_sf_data <- function(sf_fp,start_date,end_date) {
  
  sf_data <- st_read(sf_fp) %>% 
    st_transform(crs=3857) %>%
    mutate(Date = DTG %>%
             as.character() %>%
             as.POSIXlt(format='%Y%m%d%H')
           ) %>%
    filter(Date>=start_date,
           Date<=end_date)
  
  return(sf_data)
  
}