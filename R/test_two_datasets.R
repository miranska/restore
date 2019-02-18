#' @title Regression testing for dataset migration
#'
#' @description This is a package of regression testing for dataset migration. Given a scenario where a legacy dataset will be replaced by a target dataset, we will analyze the difference between them based on following tests:
#' 1. Distribution test: Kolmogorov-Smirnov test;
#' 2. Correlation tests: Pearson correlation coefficient and Spearman's correlation;
#' 3. Different variables and records;
#' 4. Magnitude comparison;
#' 5. Mean relative errors;
#' 6. The difference between two hierarchical pairs in Spearman's test;
#' 7. Features that have NA values;
#' 8. Hybrid tests, which shows features that appear in Kolmogorov-Smirnov test, mean relative error test, and correlation tests;
#' 9. Ranking, which shows the ranking of variables that appear in Kolmogorov-Smirnov test, mean relative error test, and correlation tests.
#' The final report will be written into a user-specified xlsx file or an object (which is stored in an RData file). Users can choose the test results produced in the final report. 
#'
#' @importFrom data.table data.table setkeyv rbindlist
#' @import openxlsx
#' @import dplyr
#' @import tidyr
#' @import readr
#'
#' @param legacy_file Full path of the input legacy dataset (csv)
#' @param legacy_df Data frame contained the input legacy dataset
#' @param target_file Full path of the input target dataset (csv)
#' @param target_df Data frame contained the input target dataset
#' @param hier Full path of the hierarchy file (csv)
#' @param hier_df Data frame contained the hierarchy
#' @param hier_pair Full path of the hierarchical pair file (csv)
#' @param hier_pair_df Data frame contained the hierarchical pair
#' @param thresholds Full path of the file contained thresholds
#' @param thresholds_df Data frame contained thresholds
#' @param final_report Full path of the output file (xlsx) 
#' @param final_data Full path of the output file (RData) 
#' @param key_col Key column in the two datasets
#' @param hier_col Column name that contains hierarchies
#' @param report_join Boolean variable to control the report of joined metrics. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_hybrid Boolean variable to control the report of hybrid metrics. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_magnitude Boolean variable to control the report of magnitude metrics. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_mre Boolean variable to control the report based on mean relative errors. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_spearman Boolean variable to control the report based on Spearman's test. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_pearson Boolean variable to control the report based on Pearson test. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_distribution Boolean variable to control the report based on distribution test. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_rank Boolean variable to control the report of appearances. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_spearman_diff Boolean variable to control the report of Spearman's test difference on different hierarchies. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_na Boolean variable to control the report of features with NA values. TRUE - generate the report; FALSE - the report will not be generated.
#' @param report_var_attr Boolean variable to control the report of variables' attributes. TRUE - generate the report; FALSE - the report will not be generated.
#'
#' @return NULL
#' 
#' @examples 
#' old_file <- '../inst/extdata/old.csv'
#' new_file <- '../inst/extdata/new.csv'
#' geo_hier <- '../inst/extdata/geo_hierarchies.csv'
#' geo_pair <- '../inst/extdata/geo_pairs.csv'
#' thresholds <- '../inst/extdata/thresholds.csv'
#' final_report <- '../inst/extdata/analysis_results.xlsx'
#' key <- 'CODE'
#' hierarchy <-'GEO'
#' 
#' test_two_datasets(legacy_file = old_file,
#'                   target_file = new_file,
#'                   hier = geo_hier,
#'                   hier_pair = geo_pair,
#'                   thresholds = thresholds,
#'                   final_report = final_report,
#'                   key_col = key,
#'                   hier_col = hierarchy)
#'
#' @export test_two_datasets

#configure unit test
#suppressMessages(library(data.table))
#suppressMessages(library(glue))
#suppressMessages(library(openxlsx))
#suppressMessages(library(dplyr))
#suppressMessages(library(tidyr))
#suppressMessages(library(readr))
#suppressMessages(library(testthat))

#context("Test joined datasets")

#setwd("/Users/leizhang/Projects/EA/r-packaging/RESTORE/R/")
#source('test_that.R')

# Good documentation for tidy family of packages is given in http://r4ds.had.co.nz/index.html

#TODO: add comparions of stats for old a new feature w/o joining the datasets together
#TODO: Sean - how to deal with attributes that have NAs? Ignore them, fail, filter them out, etc.
#TODO: Sean - what to do with "national level" weight when we are dealing with % for a given area rather than absolute count?

test_two_datasets <- function(legacy_file = NULL,
                              legacy_df = NULL,
                              target_file = NULL,
                              target_df = NULL,
                              hier = NULL,
                              hier_df = NULL,
                              hier_pair = NULL, 
                              hier_pair_df = NULL,
                              thresholds = NULL,
                              thresholds_df = NULL,
                              final_report = NULL,
                              final_data = NULL,
                              key_col, 
                              hier_col,
                              report_join = TRUE,
                              report_hybrid = TRUE,
                              report_magnitude = TRUE,
                              report_mre = TRUE, 
                              report_spearman = TRUE, 
                              report_pearson = TRUE, 
                              report_distribution = TRUE, 
                              report_rank = TRUE, 
                              report_spearman_diff = TRUE, 
                              report_na = TRUE,
                              report_var_attr = TRUE) {
  # load datasets and corresponding input parameters
  ld <- load_datasets(legacy_file, 
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
                      hier_col)
  
  # join datasets
  dat_joined <- join_datasets(ld$dat_old, 
                              ld$dat_new, 
                              ld$hierarchy_column_name, 
                              ld$key_column_name)
  
  # compute the number of unique joined rows, 
  # i.e. the number of unique 2-tuples [hierarchy_column_name, key_column_name]
  number_of_joined_rows <- dat_joined %>% 
    select(ld$hierarchy_column_name, ld$key_column_name) %>% 
    n_distinct()
  
  #compute higer-order metrics
  hm <- compute_high_level_metrics(ld$dat_old, 
                                   ld$dat_new, 
                                   number_of_joined_rows)
  
  # compute paired metrics
  jm <- compute_metrics(dat_joined,
                        ld$hierarchy_column_name,
                        ld$hierarchy_levels,
                        ld$hier_pairs.len,
                        ld$hier_pairs.df)
  
  # evaluate metrics against thresholds
  em <- eval_metrics(jm$dat_joined_metrics,
                     jm$var_list.len,
                     jm$var_list,
                     ld$THLD_mre,
                     ld$THLD_correlation,
                     ld$THLD_significance,
                     ld$THLD_spearman_diff,
                     ld$hierarchy_levels)
  
  # produce reports in an xlsx file
  # TODO: shall we divide the arguments into different metrics?
  outputs <- produce_reports(
    hm,
    jm,
    em,
    final_report,
    final_data,
    report_join,
    report_hybrid,
    report_magnitude,
    report_mre,
    report_spearman,
    report_pearson,
    report_distribution,
    report_rank,
    report_spearman_diff,
    report_na,
    report_var_attr
  )
  if(!is.null(outputs)) {
    save(outputs, file = final_data)
  }
  
  #############################################
  # Testing with testthat
  #############################################
  #eval(parse("test_that.R"))
  #test_violation(ld$expected_number_of_joined_rows,
  #               ld$expected_column_names_in_new_dataset,
  #               ld$check_for_order_of_column_names_in_the_new_dataset,
  #               ld$hierarchy_levels,
  #               ld$dat_new,
  #               ld$hierarchy_column_name)
}
