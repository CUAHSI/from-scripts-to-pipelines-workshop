source("02_process/src/process_helpers.R")

p2 <- list(
  
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
  ),
  
  tar_target(
    p2_harvey_pts,
    load_sf_data(p2_harvey_line_shp,
                 start_date,
                 end_date,
                 out_file="03_process/out/harvey_tracking.csv")
  ),
  
  tar_target(
    p2_stage_flooding_data,
    p1_site_data %>% 
      left_join(p1_nws_flooding_info,by='site_no') %>%
      left_join(p1_site_info %>% select(c('site_no','station_nm')),by='site_no')
  )
)