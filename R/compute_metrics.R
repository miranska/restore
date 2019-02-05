# compute metrics based on joined dataset
# compute the ratio of magnitudes
# TODO: this will not work when x or y is equal to 0
# TODO: also, what to do if we have positive and negative numbers? E.g. 100 and -100, as abs(-100/100) = 1
magnitude_ratio <- function(x, y) {
  # if x and y are numbers
  if (is.na(x)  | is.na(y)) {
    return(NA)
  }
  # if zero is observed
  if (x == 0 & y ==0) {
    r <- 1
  } else if (x == 0 | y == 0) {
    warning("Cannot compare magnitudes when one of the numbers is zero.")
    return(NA)
  } else {
    r <- x / y
  }
  # check the ratio
  if (r > 0.1 & r < 10) {
    same_magnitude <- TRUE
  } else {
    same_magnitude <- FALSE
  }
  return(same_magnitude)
}
#are two numbers of the same magnitude?
# TODO: the following function is not called
#is_the_same_magnitude <- function(x, y) {
#  ifelse(abs(magnitude_ratio(x, y)) < 1, T, F)
#}
# compute the metrics
compute_metrics <- function(dat_joined, 
                            hierarchy_column_name, 
                            hierarchy_levels, 
                            hier_pairs.len,
                            hier_pairs.df) {
  #compute metrics for each column (a.k.a. variable or feature) and hierarchy level
  #TODO: add the remaining metrics to the summarise function
  #TODO: use hierarchy_column_name instead of hard-coded GEO (solution - group_by_)
  # Note: summarise() takes up most of the time in the pipe
  
  dat_joined_metrics <- dat_joined %>%
    #group_by(var_name, GEO) %>% # do computations for each variable and hierarchy level
    group_by_("var_name", GEO = hierarchy_column_name) %>% # do computations for each variable and hierarchy level
    summarise(
      row_cnt = n(),
      is_na_present_old = any(is.na(var_value.old)),
      is_na_present_new = any(is.na(var_value.new)),
      sum_old = sum(var_value.old, na.rm=TRUE),
      sum_new = sum(var_value.new, na.rm=TRUE),
      sum_ratio = sum_new / sum_old,
      min_old = min(var_value.old, na.rm=TRUE),
      min_new = min(var_value.new, na.rm=TRUE),
      max_old = max(var_value.old, na.rm=TRUE),
      max_new = max(var_value.new, na.rm=TRUE),
      mean_old = mean(var_value.old, na.rm=TRUE),
      mean_new = mean(var_value.new, na.rm=TRUE),
      median_old = mean(var_value.old, na.rm=TRUE),
      median_new = mean(var_value.new, na.rm=TRUE),
      min_order_of_magnitude_ratio = magnitude_ratio(min_old, min_new),
      max_order_of_magnitude_ratio = magnitude_ratio(max_old, max_new),
      mean_order_of_magnitude_ratio = magnitude_ratio(mean_old, mean_new),
      median_order_of_magnitude_ratio = magnitude_ratio(median_old, median_new),
      pearson = cor(var_value.old, var_value.new, method = "pearson", use = "complete.obs"),
      spearman = cor(var_value.old, var_value.new, method = "spearman", use = "complete.obs"),
      mean_abs_err = mean(abs(var_value.old - var_value.new), na.rm=TRUE),
      # TODO: better solution to select finite numbers only?
      mean_rel_err = mean(abs((var_value.old - var_value.new) / var_value.old
      )[is.finite((var_value.old - var_value.new) / var_value.old)]),
      ks_test_p_value  = ks.test(var_value.old, var_value.new)$p.value
    ) %>%
    mutate(GEO = factor(GEO, levels = hierarchy_levels)) %>% #specify hierarchy order by converting to factor
    arrange(var_name, GEO) # order the metrics by var_name and hierarchy level
  
  ########################################################################################################
  # compute pair-wise comparison for each variable and each pair of GEO levels (for tree structure)
  ########################################################################################################
  # unique variable list
  var_list <- unique(dat_joined_metrics$var_name)
  # number of alerts and variables
  var_list.len <- length(var_list)
  # truncated version
  dat_joined_pair <-
    data.frame(
      "var_name" = dat_joined_metrics$var_name,
      "GEO" = dat_joined_metrics$GEO,
      "mean_rel_err" = dat_joined_metrics$mean_rel_err,
      "spearman" = dat_joined_metrics$spearman,
      "sum_new" = dat_joined_metrics$sum_new
    )
  # final results
  res_pair <- data.frame(
    "var_name" = c(),
    "GEO" = c(),
    "mean_rel_err" = c(),
    "spearman" = c(),
    "sum_new" = c(),
    "mean_rel_err_pair" = c(),
    "spearman_pair" = c(),
    "sum_new_pair" = c()
  )
  # for each
  for (m in 1:var_list.len) {
    var <- var_list[m]
    for (n in 1:hier_pairs.len) {
      # if debugging, use the next two lines
      #data_to_process_from <- subset(dat_joined_pair, var_name == var & GEO == geo_pairs[[n]][1])
      #data_to_process_to <- subset(dat_joined_pair, var_name == var & GEO == geo_pairs[[n]][2])
      data_to_process_from <-
        subset(dat_joined_pair,
               var_name == var &
                 GEO == as.character(hier_pairs.df$Parent[n]))
      data_to_process_to <-
        subset(dat_joined_pair,
               var_name == var &
                 GEO == as.character(hier_pairs.df$Child[n]))
      data_to_process_to$mean_rel_err_pair <-
        data_to_process_to$mean_rel_err - data_to_process_from$mean_rel_err
      data_to_process_to$spearman_pair <-
        data_to_process_to$spearman - data_to_process_from$spearman
      data_to_process_to$sum_new_pair <-
        data_to_process_to$sum_new - data_to_process_from$sum_new
      # TODO - change this hard-coding part
      if (data_to_process_from$GEO == hierarchy_levels[1]) {
        res_pair <-
          rbindlist(list(res_pair, data_to_process_from, data_to_process_to),
                    fill = TRUE)
      } else {
        res_pair <- rbind(res_pair, data_to_process_to)
      }
    }
  }
  res_pair <-
    res_pair[, c("var_name",
                 "GEO",
                 "mean_rel_err_pair",
                 "spearman_pair",
                 "sum_new_pair")]
  dat_joined_metrics <-
    left_join(dat_joined_metrics, res_pair, by = c("var_name", "GEO"))
  
  # return a list
  jm_result <- list(dat_joined_metrics = dat_joined_metrics, 
                    var_list.len = var_list.len,
                    var_list = var_list)
  return(jm_result)
}

compute_high_level_metrics <- function(dat_old, dat_new, count_of_joined_rows) {
  #compare row count in non-joined datasets
  dat_old.row_count <- nrow(dat_old)
  dat_new.row_count <- nrow(dat_new)
  is_row_count_same <-
    ifelse(dat_old.row_count == dat_new.row_count, T, F)
  
  #count the number of rows that did not make it into the inner join
  dat_old.row_count_not_in_join <- dat_old.row_count - count_of_joined_rows
  dat_new.row_count_not_in_join <- dat_new.row_count - count_of_joined_rows
  no_rows_not_in_join <- ifelse(dat_old.row_count_not_in_join == 0 &
                                          dat_new.row_count_not_in_join == 0, T, F)
  
  #compare column count in non-joined datasets
  dat_old.col_count <- ncol(dat_old)
  dat_new.col_count <- ncol(dat_new)
  is_col_count_same <-
    ifelse(dat_old.col_count == dat_new.col_count, T, F)
  
  #find missing column names in old and in new
  dat_old.col_names <- colnames(dat_old)
  dat_new.col_names <- colnames(dat_new)
  columns_absent_in_dat_new <-
    setdiff(dat_old.col_names, dat_new.col_names)
  columns_absent_in_dat_old <-
    setdiff(dat_new.col_names, dat_old.col_names)
  
  no_columns_missing <-ifelse(length(columns_absent_in_dat_old) == 0 &
                                length(columns_absent_in_dat_new) == 0, T, F)
  
  list(
    dat_old.row_count = dat_old.row_count,
    dat_new.row_count = dat_new.row_count,
    is_row_count_same = is_row_count_same,
    
    dat_old.row_count_not_in_join = dat_old.row_count_not_in_join,
    dat_new.row_count_not_in_join = dat_new.row_count_not_in_join,
    no_rows_not_in_join = no_rows_not_in_join,
    
    dat_old.col_count = dat_old.col_count,
    dat_new.col_count = dat_new.col_count,
    is_col_count_same = is_col_count_same,
    
    columns_absent_in_dat_new = columns_absent_in_dat_new,
    columns_absent_in_dat_old = columns_absent_in_dat_old,
    no_columns_missing = no_columns_missing
  )
  
}
