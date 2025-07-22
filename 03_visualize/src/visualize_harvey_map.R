create_map <- function(harvey_data, site_info, out_file) {
  
  # color palette for hurricane track based on date
  time_colors <- colorRampPalette(brewer.pal(9, "YlGnBu"))(nrow(harvey_data)) # Adjust number of colors as needed
  harvey_data$Color <- time_colors[rank(harvey_data$Date)]
  # color for usgs gages
  usgs_gage_color <- "orange"
  
  # create an sf object for hurricane track and gage locations
  harvey_sf <- st_as_sf(harvey_data, coords = c("LONG", "LAT"), crs = 4326)
  gage_sf <- site_info %>% mutate(
    popup=paste0("<b>USGS Site Number: </b>", site_no,"<br>",
                 "<b>Station Name: </b> ", station_nm
    )) %>% 
    st_as_sf(coords = c("dec_long_va", "dec_lat_va"), crs = 4326)
  
  # load state boundaries with tigris package
  # tried to suppress messages and progress bar
  old_tigris_progress_option <- getOption("tigris_progress") # Save current option
  options(tigris_progress = FALSE)
  states_boundaries <- suppressMessages(states(cb = TRUE, class = "sf"))
  options(tigris_progress = old_tigris_progress_option)
  
  # attempt to fix the initial ROI and zoom for map based on hurricane track
  center_lon <- mean(harvey_data$LON)
  center_lat <- mean(harvey_data$LAT)
  initial_zoom_level <- 7
  
  # create leaflet map, set initial view and disable zoom and panning
  m <- leaflet(options = leafletOptions(
    zoomControl = FALSE, 
    dragging = FALSE,    
    touchZoom = FALSE,   
    scrollWheelZoom = FALSE, 
    doubleClickZoom = FALSE, 
    boxZoom = FALSE,     
    keyboard = FALSE,    
    minZoom = initial_zoom_level,
    maxZoom = initial_zoom_level
  )) %>%
    addProviderTiles(providers$CartoDB.Positron) %>% 
    setView(lng = center_lon, lat = center_lat, zoom = initial_zoom_level)
  
  # add state boundaries layer
  m <- m %>%
    addPolygons(
      data = states_boundaries,
      color = "#444444",       
      weight = 1,              
      smoothFactor = 0.5,
      opacity = 1.0,
      fillOpacity = 0.2,       
      fillColor = "#CCCCCC"  
    )
  
  # add hurricane track changing color with time
  for (i in 1:(nrow(harvey_data) - 1)) {
    m <- m %>%
      addPolylines(
        lng = c(harvey_data$LON[i], harvey_data$LON[i+1]), # Longitude for start and end of segment
        lat = c(harvey_data$LAT[i], harvey_data$LAT[i+1]),  # Latitude for start and end of segment
        color = harvey_data$Color[i], # Color based on the starting point of the segment
        weight = 10, # Increased weight for better visibility (from 6 to 10)
        opacity = 1 # Slightly increased opacity for better visibility
      )
  }
  
  # add usgs gage site markers
  m <- m %>%
    addCircleMarkers(
      data = gage_sf,
      radius = 8,
      stroke=FALSE,
      color = usgs_gage_color,
      fillOpacity = 1,
      popup = ~popup,
      labelOptions = labelOptions(
        noHide = FALSE,
        direction = 'auto',
        textsize = "10px",
        style = list(
          "box-shadow" = "3px 3px rgba(0,0,0,0.2)",
          "border-color" = "rgba(0,0,0,0.5)"
        ),
        html = TRUE
      )
    )
  
  # create legend for hurricane track colors (time)
  legend_dates_indices <- round(seq(1, nrow(harvey_data), length.out = 5))
  legend_labels <- format(harvey_data$Date[legend_dates_indices], "%Y-%b-%d")
  legend_colors_for_display <- harvey_data$Color[legend_dates_indices]
  
  m <- m %>% addLegend(
    "bottomright",
    colors = legend_colors_for_display,
    labels = legend_labels,
    title = "Hurricane Track Time",
    opacity = 1
  )
  
  # add custom legend for usgs gage sites
  m <- add_gage_site_legend(m, color = usgs_gage_color, label = "USGS Gage Sites", position = "bottomright")
  
  saveWidget(m, file = out_file, selfcontained = TRUE)
  
  return(out_file)
}

add_gage_site_legend <- function(map, color, label, position = "bottomright") {
  # create an HTML snippet for the circle symbol
  circle_html <- paste0(
    "<div style='display: inline-block; width: 15px; height: 15px; ",
    "border-radius: 50%; background-color: ", color, "; margin-right: 5px; vertical-align: middle;'></div>",
    "<span style='vertical-align: middle;'>", label, "</span>"
  )
  
  legend_content <- htmltools::HTML(
    circle_html
  )
  
  map %>%
    addControl(
      html = legend_content,
      position = position
    )
}