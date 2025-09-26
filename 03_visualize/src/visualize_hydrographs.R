#' @title Plot Hydrographs with NWS Flood Stage
#' @description This function creates a set of hydrographs (time series plots) of USGS gage height data, faceted by site, and overlays the corresponding National Weather Service (NWS) minor flood stage as a horizontal line. It saves the resulting plot as an SVG file.
#'
#' @param nwis_nws_data A combined tibble (`data.frame`) containing the NWIS stage data, NWS flood stage, site ID, and site name. This is typically the output from the `p2_stage_flooding_data` target.
#' @param out_file A character string for the path and filename where the SVG plot will be saved.
#'
#' @return A character string representing the file path to the saved SVG hydrograph plot.
#'
plot_hydrographs <- function(nwis_nws_data,out_file){
  
  # Create the base plot with 'Date' on the x-axis
  m <- ggplot(nwis_nws_data, aes(x = time)) + # Assign the plot to a variable 'plot'
    # Plot gage height as a blue line
    geom_line(aes(y = value, color = "Gage height")) +
    # Plot 'flood_stage' as a red line on the same plot
    geom_line(aes(y = flood_stage, color = "National Weather Service Floodstage")) +
    facet_wrap(~ paste0(monitoring_location_id, ", ", monitoring_location_name), ncol = 1, scales = "free") +
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
    # Use bw theme (so the x and y axes still show up)
    theme_bw() +
    # Customize theme elements
    theme(
      strip.text = element_text(face = "bold", size = 10),
      legend.position = "bottom",
      legend.title = element_blank()
    )
  
  ggsave(out_file, plot = m, width = 10, height = 8, units = "in")
  
  return(out_file)
  
}