source("02_read/src/read_nwis_site_info.R")
source("02_read/src/read_helpers.R")

p2 <- list(
  
  tar_target(
    p2_site_info,
    read_nwis_site_info(p1_site_data, out_file = "02_read/out/nwis_site_info.csv")
  ),
  
  # add target to read the line files 
  tar_target(
    p2_harvey_line_files,
    extract_files_from_zip(p1_harvey_best_track_zip,
                          out_dir="02_read/out",
                          file_name_regex=".pts")
  ),
  
  tar_target(
    p2_harvey_line_shp,
    p2_harvey_line_files %>%
      file_ext() %>%
      {. == 'shp'} %>%
      p2_harvey_line_files[.],
    format='file'
  )
)