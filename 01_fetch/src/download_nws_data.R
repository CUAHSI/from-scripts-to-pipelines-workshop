download_nws_data <- function(nws_conversion, sites){

  sites <- tibble("site_no"=sites)
  sites <- left_join(sites, 
                     select(nws_conversion, NWS, USGS), 
                     by = c("site_no"="USGS"))
  
  # Setup an empty table to build
  flood_stage_xwalk <- tibble()
  # For each site, capture the flood stage and units
  for(i in sites$NWS){
    
    url <- paste0("https://api.water.noaa.gov/nwps/v1/gauges/",i)
    
    response_data <- request(url) %>%
      req_perform() %>%
      resp_body_json()
    
    flood_stage_xwalk <- flood_stage_xwalk %>% 
      bind_rows(tibble(NWS = i,
                       flood_stage = response_data$flood$categories$minor$stage,
                       stage_units = response_data$flood$stageUnits))
  }
  # Join the flood information with the site data
  sites <- sites %>% 
    left_join(flood_stage_xwalk, by = 'NWS')
  
  return(sites)
}