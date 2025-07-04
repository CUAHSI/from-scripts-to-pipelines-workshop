download_nws_data <- function(nws_conversion, sites){

  sites <- tibble("site_no"=sites)
  sites <- left_join(sites, 
                     select(nws_conversion, NWS, USGS), 
                     by = c("site_no"="USGS"))
  
  for(i in sites$NWS){
    
    url <- paste0("https://api.water.noaa.gov/nwps/v1/gauges/",i)

    response_data <- request(url) %>%
      req_perform() %>%
      resp_body_json()

    sites$flood_stage[which(sites$NWS %in% i)] <- response_data$flood$categories$minor$stage
    sites$stage_units[which(sites$NWS %in% i)] <- response_data$flood$stageUnits

  }
  return(sites)
}