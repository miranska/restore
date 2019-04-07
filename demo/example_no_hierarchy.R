# Replace the full path by your own path
##detach(package:readr, unload=TRUE)
library(rio)

# set relative paths to input and output dirs
input_dir <- './data/'
output_dir <- './inst/extdata/'

# input files
old_dataset <- import(paste(input_dir, 'restore_old.RData', sep = ''))
new_dataset <- import(paste(input_dir, 'restore_new.RData', sep = ''))

# thresholds
metric_thresholds <- import(paste(input_dir, 'restore_thresholds.RData', sep = ''))

# output file
final_report <- paste(output_dir, 'analysis_results_flat_hierarchy.xlsx', sep = '')

# save the output in RData format
# you can choose one of final_report and final_data, or both of them
final_data <- paste(output_dir, 'analysis_results_flat_hierarchy.RData', sep = '')

# let us remove the "GEO" column to mimic flat hierarchy
old_dataset$GEO <- NULL
new_dataset$GEO <- NULL

test_two_datasets(legacy_df = old_dataset,
                  target_df = new_dataset,
                  thresholds_df = metric_thresholds,
                  final_report = final_report,
                  final_data = final_data,
                  key_col = key)
