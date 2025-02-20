
# This file includes the target recipes for targets that load local data

p1 <- list(
  
  # Declare an input file as a target
  tar_target(
    p1_dataset_csv, 
    "01_fetch/in/wqp_brown_county_wi_data.csv", 
    # Adding this argument tracks the file *contents* not the name
    format = "file" 
  ),
  
  # Load the raw data from the csv file.
  # Note that target name is the same as the file *except* for the 
  # suffix `_csv`, denoting the file type.
  tar_target(
    p1_dataset,
    read_csv(p1_dataset_csv, col_types = cols())
  ),
  
  # Now do the same but for the site information CSV file
  tar_target(
    p1_metadata_csv, 
    "01_fetch/in/wqp_brown_county_wi_siteInfo.csv", 
    # Adding this argument tracks the file *contents* not the name
    format = "file" 
  ),
  
  # Load the site info data from the csv file.
  tar_target(
    p1_metadata,
    read_csv(p1_metadata_csv, col_types = cols())
  )
  
)
