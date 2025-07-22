source('03_visualize/src/visualize_harvey_map.R')
source('03_visualize/src/visualize_hydrographs.R')

p3 <- list(
  tar_target(
    p3_leaflet_map_html,
    create_map(p2_harvey_pts, p1_site_info,out_file = "03_visualize/out/leaflet_map.html"),
    format = "file"
  ),
  
  tar_target(
    p3_hydrograph_plot,
    plot_hydrographs(p2_stage_flooding_data, out_file = "03_visualize/out/hydrograph_plot.svg"),
    format = "file"
  )
  
)
