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