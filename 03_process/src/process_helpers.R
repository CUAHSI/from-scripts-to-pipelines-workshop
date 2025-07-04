load_sf_data <- function(storm_id,start_date,end_date,in_folder,out_file) {
  
  sf_fp = paste0(in_folder,"/",storm_id,"_pts.shp")
  
  sf_data <- st_read(sf_fp) %>% 
    st_transform(crs=3857) %>%
    mutate(Date = DTG %>%
             as.character() %>%
             as.POSIXlt(format='%Y%m%d%H')
           ) %>%
    filter(Date>=start_date,
           Date<=end_date)
  
  write_csv(sf_data,out_file)
  
  return(sf_data)
  
}