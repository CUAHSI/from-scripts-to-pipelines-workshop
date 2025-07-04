
plot_hydrographs <- function(nwis_nws_data,out_file){
  
  # Create the base plot with 'Date' on the x-axis
  m <- ggplot(nwis_nws_data, aes(x = Date)) + # Assign the plot to a variable 'plot'
    # Plot 'X_00065_00003' (gage height) as a blue line
    geom_line(aes(y = X_00065_00003, color = "Gage height")) +
    # Plot 'flood_stage' as a red line on the same plot
    geom_line(aes(y = flood_stage, color = "National Weather Service Floodstage")) +
    facet_wrap(~ paste0('USGS ', site_no, " - ", station_nm), ncol = 1, scales = "free") +
    # Manually define colors and names for the legend
    scale_color_manual(
      name = "Legend",
      values = c(
        "Gage height" = "blue",
        "National Weather Service Floodstage" = "red"
      )
    ) +
    # Set the y-axis label
    labs(
      y = "Gage height, feet"
    ) +
    scale_x_date(date_labels = "%d-%b-%Y") +
    # Use a minimal theme for a clean look
    theme_minimal() +
    # Customize theme elements
    theme(
      strip.text = element_text(face = "bold", size = 10),
      legend.position = "bottom",
      legend.title = element_blank()
    )
  
  ggsave(out_file, plot = m, width = 10, height = 8, units = "in")
  
  return(out_file)
  
}