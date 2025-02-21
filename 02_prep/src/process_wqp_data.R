
#' @title Filter and clean the downloaded WQP data
#' @description This function takes the downloaded WQP data and filters to just 
#' one desired characteristic/fraction combination. Then, it applies some data
#' cleaning to bring together the result values and units, which are stored in 
#' different columns depending on whether the measurement represents a value
#' below the detection limit.
#' 
#' @param wqp_data_raw a data.frame with downloaded data from WQP, such as from
#' the pipeline function `download_wqp_physchem_data()`. 
#' @param characteristic a single character string representing one possible
#' value that appears in the column `CharacteristicName`. You can access the full
#' list of possible values at https://www.waterqualitydata.us/Codes/Characteristicname?mimeType=xml.
#' @param fraction a single character string representing one possible value that
#' appears in the column `ResultSampleFractionTest`, e.g. 'Total', 'Dissolved',
#' 'Suspended', etc.
#' 
refine_wqp_data <- function(wqp_data_raw, characteristic, fraction) {
  wqp_data_raw |>
    
    # Filter the dataset to just the characteristic and sample fraction of interest
    filter(CharacteristicName == characteristic,
           ResultSampleFractionText == fraction) |>
    
    # Harmonize result units and values into a single column regardless of non-detect status
    mutate(result_unit = ifelse(ResultDetectionConditionText %in% "Not Detected", 
                                yes = tolower(DetectionQuantitationLimitMeasure.MeasureUnitCode), 
                                no = tolower(ResultMeasure.MeasureUnitCode)),
           
           result_value = as.numeric(ifelse(ResultDetectionConditionText %in% "Not Detected", 
                                            yes = DetectionQuantitationLimitMeasure.MeasureValue, 
                                            no = ResultMeasureValue)),
           
           non_detect = ifelse(ResultDetectionConditionText %in% "Not Detected", 1, 0))
}

#' @title Summarize the refined WQP data per site
#' @description Summarize the filtered and cleaned data to output site-based counts,
#' percentage of records that were non-detects, and mean values.
#' 
#' @param wqp_data_refined a data.frame of WQP data that has been filtered to 
#' represent *ONE* characteristic-fraction combo and must contain at least the
#' following columns: `MonitoringLocationIdentifier`, `CharacteristicName`, 
#' `result_unit`, `result_value`, and `non_detect`.
#' 
summarize_wqp_data_by_site <- function(wqp_data_refined) {
  wqp_data_refined |>
    group_by(MonitoringLocationIdentifier, result_unit, CharacteristicName) |>
    summarise(
      n_count = n(),
      mean_value = round(mean(result_value, na.rm = TRUE), 2),
      sd_value = round(sd(result_value, na.rm = TRUE), 2),
      percent_nondetect = round(sum(non_detect)/length(non_detect) * 100, 2),
      .groups = 'drop' # Avoid the message about grouped output
    )
}

#' @title Summarize the refined WQP data per site and year
#' @description Summarize the filtered and cleaned data to output annual site-based 
#' counts, percentage of records that were non-detects, and mean values.
#' 
#' @param wqp_data_refined a data.frame of WQP data that has been filtered to 
#' represent *ONE* characteristic-fraction combo and must contain at least the
#' following columns: `MonitoringLocationIdentifier`, `CharacteristicName`, 
#' `result_unit`, `result_value`, and `non_detect`.
#' 
summarize_wqp_data_by_year <- function(wqp_data_refined) {
  wqp_data_refined |>
    mutate(year = year(ActivityStartDate)) |>
    group_by(MonitoringLocationIdentifier, year, result_unit, CharacteristicName) |>
    summarise(
      n_count = n(),
      mean_value = round(mean(result_value, na.rm = TRUE), 2),
      sd_value = round(sd(result_value, na.rm = TRUE), 2),
      percent_nondetect = round(sum(non_detect)/length(non_detect) * 100, 2),
      .groups = 'drop' # Avoid the message about grouped output
    )
}

#' @title Filter metadata to just the sites that stay in the refined data
#' @description WQP downloaded data via `dataRetrieval` comes with a data.frame
#' attribute called `siteInfo`, containing metadata for the sites present in the 
#' downloaded dataset. It includes things like site type, site full name, and 
#' location. Any filtering done to the data after it was downloaded, such as 
#' in `refine_wqp_data()`, will *not* filter the siteInfo attribute unless 
#' specifically added as custom code.
#' 
#' @param wqp_metadata a data.frame with downloaded data from WQP with site info
#' @param sites a vector of the sites to retain
#' 
filter_wqp_site_info <- function(wqp_metadata, sites) {
  wqp_metadata %>% 
    filter(MonitoringLocationIdentifier %in% sites)
}
