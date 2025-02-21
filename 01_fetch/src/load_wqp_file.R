
#' @title Small wrapper function to read in CSV data from WQP
#' @description This is a tiny function that wraps the `readr::read_csv()` function
#' in order to change some of the default arguments to settings that are
#' useful when reading in WQP data, e.g. `col_types` and `guess_max`.
#' 
#' @param in_file character string of the filepath to load
#' 
#' @returns a tibble of WQP data
#' 
load_wqp_file <- function(in_file) {
  read_csv(in_file, 
           # Suppress console messages about what it 
           # chose for default column types
           col_types = cols(),
           # Increase number of rows it looks at to
           # choose column types by default. This
           # makes it more likely to find an actual 
           # value and not treat a column as logical.
           guess_max = 5000)
}
