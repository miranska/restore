# the function to load all datasets and corresponding input parameters
load_datasets <- function(legacy_file,
                          legacy_df,
                          target_file,
                          target_df,
                          hier,
                          hier_df,
                          hier_pair, 
                          hier_pair_df,
                          thresholds,
                          thresholds_df,
                          key_col, 
                          hier_col) {
  # read datasets
  # legacy data
  if (is.null(legacy_file) && !is.null(legacy_df)) {
    dat_old <- legacy_df # read from dataframe
  } else if (!is.null(legacy_file) && is.null(legacy_df)) {
    dat_old <- read_csv(legacy_file) # read from file
  } else {
    stop("Please provide only legacy_file or legacy_df.")
  }
  # target data
  if (is.null(target_file) && !is.null(target_df)) {
    dat_new <- target_df
  } else if (!is.null(target_file) && is.null(target_df)) {
    dat_new <- read_csv(target_file)
  } else {
    stop("Please provide only target_file or target_df.")
  }
  
  #TODO: add pairs for comparisons, which will deal with exceptions and different hierarchy levels
  #hierarchy levels (starting from the highest)
  # read hierarchy levels from the file or from a dataframe
  if (is.null(hier) && !is.null(hier_df)) {
    hierarchy_levels <- hier_df
  } else if (!is.null(hier) && is.null(hier_df)) {
    hierarchy_levels <- read.csv(hier)
  } else {
    stop("Please provide only hier or hier_df.")
  }
  hierarchy_levels <- as.vector(hierarchy_levels$Hierarchy)
  
  # read hierarchy from the file instead of hard coding, and get the length
  if (is.null(hier_pair) && !is.null(hier_pair_df)) {
    hier_pairs.df <- hier_pair_df
  } else if (!is.null(hier_pair) && is.null(hier_pair_df)) {
    hier_pairs.df <- read.csv(hier_pair)
  } else {
    stop("Please provide only hier_pair or hier_pair_df.")
  }
  hier_pairs.len <- length(hier_pairs.df$Parent)
  
  # read thresholds
  thresholds
  if (is.null(thresholds) && !is.null(thresholds_df)) {
    thlds <- thresholds_df
  } else if (!is.null(thresholds) && is.null(thresholds_df)) {
    thlds <- read.csv(thresholds)
  } else {
    stop("Please provide only thresholds or thresholds_df.")
  }
  
  THLD_significance <- thlds$significance # 0.05
  THLD_mre <- thlds$mre # 0.5
  THLD_correlation <- thlds$correlation # 0.8
  THLD_spearman_diff <- thlds$spearman.diff # 0.1
  
  #create joined factors for hierarchy and key columns
  key_column_name <- key_col
  hierarchy_column_name <- hier_col
  
  # TODO: change the following to NA values to real values?
  #specify the expected number of joined rows. If set to NA — skip the test.
  expected_number_of_joined_rows <- NA
  
  #specify the expected column names in the new daset. If set to NA — skip the test.
  expected_column_names_in_new_dataset <- NA
  #if the variable below is set to true -- check for the order of columns
  check_for_order_of_column_names_in_the_new_dataset <- T
  
  # return output
  ld_result <- list(
    dat_old = dat_old,
    dat_new = dat_new,
    hierarchy_levels = hierarchy_levels,
    hier_pairs.df = hier_pairs.df,
    hier_pairs.len = hier_pairs.len,
    THLD_significance = THLD_significance,
    THLD_mre = THLD_mre,
    THLD_correlation = THLD_correlation,
    THLD_spearman_diff = THLD_spearman_diff,
    hierarchy_column_name = hierarchy_column_name,
    key_column_name = key_column_name,
    expected_number_of_joined_rows = expected_number_of_joined_rows,
    expected_column_names_in_new_dataset = expected_column_names_in_new_dataset,
    check_for_order_of_column_names_in_the_new_dataset = check_for_order_of_column_names_in_the_new_dataset
  )
  return(ld_result)
}