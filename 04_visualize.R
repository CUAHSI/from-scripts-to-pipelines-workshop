source('04_visualize/src/visualize_harvey_map.R')
source('04_visualize/src/visualize_hydrographs.R')

p4 <- list(
  tar_target(
    p4_leaflet_map,
    create_map(p3_harvey_pts, p2_site_info,out_file = "04_visualize/out/leaflet_map.html"),
    format = "file"
  ),
  
  tar_target(
    p4_hydrograph_plot,
    plot_hydrographs(p3_stage_flooding_data, out_file = "04_visualize/out/hydrograph_plot.svg"),
    format = "file"
  )
  
)
