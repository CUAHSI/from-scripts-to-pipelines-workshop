# Load all `src` files for this phase
source("03_process/src/process_helpers.R")


p3 <- list(
  tar_target(
    p3_harvey_pts,
    load_sf_data(p1_harvey_best_track_id,
                 start_date,
                 end_date,
                 in_folder="02_read/out",
                 out_file="03_process/out/harvey_tracking.csv")
  ),
  
  tar_target(
    p3_stage_flooding_data,
    p1_site_data %>% 
      left_join(p1_nws_flooding_info,by='site_no') %>%
      left_join(p2_site_info %>% select(c('site_no','station_nm')),by='site_no')
  )
)