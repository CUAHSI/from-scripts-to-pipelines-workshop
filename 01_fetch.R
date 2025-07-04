
# This file includes the target recipes for targets that download data

# Load all `src` files for this phase
# source('01_fetch/src/?????.R')
source('01_fetch/src/download_nwis_stage_data.R')
source('01_fetch/src/download_nhc_best_track.R')
source('01_fetch/src/download_nws_conversion.R')
source('01_fetch/src/download_nws_data.R')

p1 <- list(
  tar_target(
    p1_site_data,
    download_nwis_stage_data(sites=harvey_sites,
                                 start_date=start_date,
                                 end_date=end_date)
  ),
  
  tar_target(
    p1_nws_table,
    download_nws_conversion()
  ),

  tar_target(
    p1_nws_flooding_info,
    download_nws_data(p1_nws_table,sites=harvey_sites)
  ), 
  
  tar_target(
    p1_harvey_best_track_id,
    paste0(ocean,storm_num,year)
  ),
  
  tar_target(
    p1_harvey_best_track_zip,
    download_nhc_best_track(storm_id=p1_harvey_best_track_id),
    format = "file"
    
  )
)
