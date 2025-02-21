
# This file includes the target recipes for targets that summarize and visualize data

# Load all `src` files for this phase
source('03_summarize/src/plot_functions.R')
source('03_summarize/src/map_function.R')

p3 <- list(
  
  # File targets *must* return the filepath at the end, so the functions called
  # by file targets should have `return(out_file)` as the final step.
  
  # next can add a timeseries plot for the data by year and then maybe an accompanying map?
  # would love to create a very simple shiny app for this.
  tar_target(
    p3_timeseries_plots_png,
    plot_timeseries(out_file = sprintf("03_summarize/out/timeseries_%s_%s.png", 
                                       characteristic, p2_sites),
                    site_id = p2_sites, 
                    wqp_data_refined = p2_refined_dataset),
    pattern = map(p2_sites),
    format = "file"
  ),
  
  tar_target(
    p3_leaflet_map_html,
    map_dataset(out_file = sprintf("03_summarize/out/leaflet_map_%s.html", characteristic),
                wqp_site_metadata = p2_site_metadata,
                wqp_data_summarized = p2_summarize_dataset_by_site),
    format = "file"
  )
  
)
