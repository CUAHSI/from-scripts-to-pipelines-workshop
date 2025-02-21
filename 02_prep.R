
# This file includes the target recipes for targets that clean and prepare data

# Load all `src` files for this phase
source('02_prep/src/process_wqp_data.R')

p2 <- list(
  
  # Filter to characteristic and fraction of interest and clean up some of the
  # columns using a custom fxn defined in `02_prep/src/process_wqp_data.R`
  tar_target(
    p2_refined_dataset,
    # Could also use "Total" as the fraction, but note that Nitrate doesn't 
    # have any values for that fraction in this dataset
    refine_wqp_data(p1_dataset, characteristic, "Dissolved")
  ),
  
  # Get list of site IDs that appear in the refined data
  tar_target(
    p2_sites,
    unique(p2_refined_dataset$MonitoringLocationIdentifier)
  ),
  
  # Wrangle result data for plotting and mapping
  tar_target(
    p2_summarize_dataset_by_site,
    summarize_wqp_data_by_site(p2_refined_dataset)
  ),
  
  # Filter the site metadata from the refined dataset
  tar_target(
    p2_site_metadata,
    filter_wqp_site_info(p1_metadata, p2_sites)
  )
)
