# Replace the full path by your own path
##detach(package:readr, unload=TRUE)

# tictoc is for timing
#library(tictoc)
#tic("starting")

# input file
input_dir <- './data/'
legacy_file <- 'old.csv'
target_file <- 'new.csv'

#output file
output_dir <- './inst/extdata/'

# NOTE: the column names of the following two files cannot be changed.
geo_hier <- 'geo_hierarchies.csv'
geo_pair <- 'geo_pairs.csv'

# thresholds
thresholds <- 'thresholds.csv'

# output file
final_report <- 'analysis_results.xlsx'
#final_data <- 'analysis_results.RData'

# key value and column name of geo_hierarchies
key <- 'CODE'
hierarchy <-'GEO'

legacy_file <- paste(input_dir, legacy_file, sep = '')
target_file <- paste(input_dir, target_file, sep = '')
geo_hier <- paste(input_dir, geo_hier, sep = '')
geo_pair <- paste(input_dir, geo_pair, sep = '')
thresholds <- paste(input_dir, thresholds, sep = '')
final_report <- paste(output_dir, final_report, sep = '')
#final_data <- paste(output_dir, final_data, sep = '')

test_two_datasets(legacy_file = legacy_file,
                  target_file = target_file,
                  hier = geo_hier,
                  hier_pair = geo_pair,
                  thresholds = thresholds,
                  final_report = final_report,
                  #final_data = final_data,
                  key_col = key,
                  hier_col = hierarchy)

# to read the report from RData file, use the following command
#load("./output/analysis_results.RData", ex <- new.env())
#ls.str(ex) 
#View(ex)

#toc()
