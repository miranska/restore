# Replace the full path by your own path
##detach(package:readr, unload=TRUE)

# tictoc is for timing
#library(tictoc)
#tic("starting")

# input file
input_dir <- './data/'
legacy_df <- 'old.RData'
target_df <- 'new.RData'

#output file
output_dir <- './inst/extdata/'

# NOTE: the column names of the following two files cannot be changed.
geo_hier <- 'geo_hierarchies.RData'
geo_pair <- 'geo_pairs.RData'

# thresholds
geo_thresholds <- 'thresholds.RData'

# output file
final_report <- 'analysis_results.xlsx'
#final_data <- 'analysis_results.RData'

# key value and column name of geo_hierarchies
key <- 'CODE'
hierarchy <-'GEO'

legacy_df <- paste(input_dir, legacy_df, sep = '')
target_df <- paste(input_dir, target_df, sep = '')
geo_hier <- paste(input_dir, geo_hier, sep = '')
geo_pair <- paste(input_dir, geo_pair, sep = '')
geo_thresholds <- paste(input_dir, geo_thresholds, sep = '')
final_report <- paste(output_dir, final_report, sep = '')
#final_data <- paste(output_dir, final_data, sep = '')

legacy_df <- import(legacy_df)
target_df <- import(target_df)
geo_hier <- import(geo_hier)
geo_pair <- import(geo_pair)
geo_thresholds <- import(geo_thresholds)

test_two_datasets(legacy_df = legacy_df,
                  target_df = target_df,
                  hier_df = geo_hier,
                  hier_pair_df = geo_pair,
                  thresholds_df = geo_thresholds,
                  final_report = final_report,
                  #final_data = final_data,
                  key_col = key,
                  hier_col = hierarchy)

# to read the report from RData file, use the following command
#load("./output/analysis_results.RData", ex <- new.env())
#ls.str(ex) 
#View(ex)

#toc()
