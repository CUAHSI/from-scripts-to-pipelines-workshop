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


load_sf_data <- function(sf_fp,start_date,end_date,out_file) {
  
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