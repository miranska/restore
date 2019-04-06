# Replace the full path by your own path
##detach(package:readr, unload=TRUE)
library(rio)

# tictoc is for timing
#library(tictoc)
#tic("starting")

# input file
input_dir <- './data/'
legacy_df <- 'restore_old.RData'
target_df <- 'restore_new.RData'

#output file
output_dir <- './inst/extdata/'

# thresholds
geo_thresholds <- 'restore_thresholds.RData'

# output file
final_report <- 'analysis_results_flat_hierarchy.xlsx'
# final_data <- 'analysis_results_flat_hierarchy.RData'

# key value and column name of geo_hierarchies
key <- 'CODE'

legacy_df <- paste(input_dir, legacy_df, sep = '')
target_df <- paste(input_dir, target_df, sep = '')
geo_thresholds <- paste(input_dir, geo_thresholds, sep = '')
final_report <- paste(output_dir, final_report, sep = '')
final_data <- paste(output_dir, final_data, sep = '')

legacy_df <- import(legacy_df)
target_df <- import(target_df)
geo_thresholds <- import(geo_thresholds)

#let us remove the "GEO" column to mimic flat hierarchy
legacy_df$GEO <- NULL
target_df$GEO <- NULL

test_two_datasets(legacy_df = legacy_df,
                  target_df = target_df,
                  thresholds_df = geo_thresholds,
                  final_report = final_report,
                  #final_data = final_data,
                  key_col = key)

# to read the report from RData file, use the following command
#load("./output/analysis_results.RData", ex <- new.env())
#ls.str(ex) 
#View(ex)

#toc()
