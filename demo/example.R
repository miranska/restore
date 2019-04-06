# Replace the full path by your own path
##detach(package:readr, unload=TRUE)
library(rio)

#set relative paths to input and output dirs
input_dir <- './data/'
output_dir <- './inst/extdata/'

# input files
legacy_df <- import(paste(input_dir, 'restore_old.RData', sep = ''))
target_df <- import(paste(input_dir, 'restore_new.RData', sep = ''))

# NOTE: the column names of the following two files cannot be changed.
geo_hier <- import(paste(input_dir, 'restore_geo_hierarchies.RData', sep = ''))
geo_pair <- import(paste(input_dir, 'restore_geo_pairs.RData', sep = ''))

# thresholds
geo_thresholds <- import(paste(input_dir, 'restore_thresholds.RData', sep = ''))

# output file
final_report <- paste(output_dir, 'analysis_results_hierarchy.xlsx', sep = '')

# If you would like to save the output in RData format, then comment final_report 
# and uncomment final_data variable.
#final_data <- paste(output_dir, 'analysis_results_hierarchy.RData', sep = '')

# set column names of key and hierarchy columns in legacy_df and target_df
key <- 'CODE'
hierarchy <-'GEO'

# run the tests
test_two_datasets(legacy_df = legacy_df,
                  target_df = target_df,
                  hier_df = geo_hier,
                  hier_pair_df = geo_pair,
                  thresholds_df = geo_thresholds,
                  final_report = final_report,
                  #final_data = final_data,
                  key_col = key,
                  hier_col = hierarchy)

# If you would like to save the output in RData format, then comment final_report 
# parameter and uncomment final_data parameter in the test_two_datasets.
