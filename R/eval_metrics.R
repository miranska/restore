# the function to evaluate metrics against thresholds
eval_metrics <- function(dat_joined_metrics, 
                         var_list.len, 
                         var_list, 
                         THLD_mre, 
                         THLD_correlation,
                         THLD_significance,
                         THLD_spearman_diff,
                         hierarchy_levels) {
  #################################################################################
  # generate different alerts - hybrid, mre, spearman, pearson, distribution
  #################################################################################
  #TODO: now that we have the metrics, we can code up the logic that highlights problematic columns
  # generate all alerts
  alert_hybrid <-
    subset(
      dat_joined_metrics,
      mean_rel_err > THLD_mre &
        spearman < THLD_correlation & pearson < THLD_correlation & ks_test_p_value < THLD_significance &
        is.finite(mean_rel_err) &
        is.finite(spearman) &
        is.finite(pearson) &
        is.finite(ks_test_p_value)
    )
  alert_magnitude <-
    subset(
      dat_joined_metrics,
      min_order_of_magnitude_ratio == FALSE |
        max_order_of_magnitude_ratio == FALSE |
        mean_order_of_magnitude_ratio == FALSE |
        median_order_of_magnitude_ratio == FALSE
    )
  alert_mre <-
    subset(dat_joined_metrics,
           is.finite(mean_rel_err) &
             mean_rel_err > THLD_mre)
  alert_spearman <-
    subset(dat_joined_metrics, is.finite(spearman) & spearman < THLD_correlation)
  alert_pearson <-
    subset(dat_joined_metrics, is.finite(pearson) & pearson < THLD_correlation)
  alert_distribution <-
    subset(dat_joined_metrics,
           is.finite(ks_test_p_value) & ks_test_p_value < THLD_significance)
  
  ######################################
  # prepare for compute total appearances
  ######################################
    sum_top_hierarchy <-
    subset(
      dat_joined_metrics,
      GEO == hierarchy_levels[1],
      select = c(var_name, sum_old, sum_new, sum_ratio)
    )
  
  #######################################################################
  # compare the results of spearman test on different hierarchies
  #######################################################################
  # "if the difference is beyond 0~0.1" and "either of them is smaller than 0.8", log the record
  # truncated version
  dat_joined_spearman <-
    data.frame(
      "var_name" = dat_joined_metrics$var_name,
      "GEO" = dat_joined_metrics$GEO,
      "spearman" = dat_joined_metrics$spearman
    )
  
  # final results
  spearman_hierarchy <- data.frame("var_name" = c(),
                                   "GEO" = c(),
                                   "spearman" = c())
  
  # for loop to attach matched results
  for (i in 1:var_list.len) {
    var_name <- var_list[i]
    # hierarchy_levels and corresponding spearman test results
    dat_var <-
      dat_joined_spearman[dat_joined_spearman$var_name == var_name,]
    dat_spearman <- dat_var$spearman
    # difference percentages on differnt hierarchies
    spearman_rate <- c()
    for (j in 1:length(dat_spearman) - 1) {
      spearman_rate[j] <-
        (dat_spearman[j] - dat_spearman[j + 1]) / dat_spearman[j]
    }
    # conditions
    for (k in 1:length(spearman_rate)) {
      # only if it is an infinite number
      if (is.finite(spearman_rate[k]) == TRUE) {
        # if rate < 0.8 and rate diff is larger than 0.1
        if ((spearman_rate[k] > THLD_spearman_diff ||
             spearman_rate[k] < 0) &&
            (dat_spearman[k] < THLD_correlation || dat_spearman[k + 1] < THLD_correlation)) {
          # append the result
          spearman_hierarchy <-
            rbindlist(list(spearman_hierarchy, dat_var[k,], dat_var[k + 1,]))
        }
      }
    }
  }
  # remove repetitions
  spearman_hierarchy <- unique(spearman_hierarchy)
  # add sum at top hierarchy, e.g., NAT
  # TODO - check for all merge(): merge if and only if the dataframe is not empty
  if (nrow(spearman_hierarchy) != 0) {
    spearman_hierarchy <-
      merge(spearman_hierarchy,
            sum_top_hierarchy,
            by = "var_name",
            all.x = TRUE)
  }
  
  ######################################
  # compute total appearances
  ######################################
  # count the appearances
  # todo - add spearman_hierarchy
  alert.list <-
    list(alert_magnitude,
         alert_mre,
         alert_spearman,
         alert_pearson,
         alert_distribution,
         spearman_hierarchy)
  # unique variable list
  #var_list <- unique(dat_joined_metrics$var_name)
  # number of alerts and variables
  alert.list.len <- length(alert.list)
  #var_list.len <- length(var_list)
  #subset(dat_joined_metrics$var_name, dat_joined_metrics$sum_old, dat_joined_metrics$sum_new)
  # final results
  total_appear <- data.frame("var_name" = c(),
                             "appearance" = c())
  
  for (n in 1:alert.list.len) {
    # res_count
    res_count <- data.frame("var_name" = c(),
                            "appearance" = c())
    dat_tmp <- data.frame(alert.list[n])
    # for each features, compute the appearances, the output is "var_name, appearance"
    for (m in 1:var_list.len) {
      var_name <- var_list[m]
      # compute the appearances
      feature_count <- length(which(dat_tmp$var_name == var_name))
      # todo - for spearman_hierarchy, count/2 is not correct.
      #if(n == alert.list.len) {
      #  feature_count <- ceiling(feature_count / 2)
      #}
      cur_res_count <- data.frame("var_name" = var_name,
                                  "appearance" = feature_count)
      res_count <- rbind(res_count, cur_res_count)
    } # end-for
    # sort by "appearance" in descending order
    #res_count <- res_count[order(-res_count$appearance),]
    # remove all zeros
    res_count <- res_count[res_count$appearance != 0, ]
    # combine all results
    if (n == 1) {
      total_appear <- res_count
    } else {
      total_appear <-
        merge(total_appear, res_count, by = "var_name", all = TRUE)
    }
  } # end-for
  # calculate sum from column 2 to column 7, 6 metrics in total
  total_appear <-
    transform(total_appear, sum = rowSums(total_appear[, 2:7], na.rm = TRUE))
  # add sum at top hierarchy, e.g., NAT
  total_appear <-
    merge(total_appear,
          sum_top_hierarchy,
          by = "var_name",
          all.x = TRUE)
  # sort by "sum" in descending order
  total_appear <- total_appear[order(-total_appear$sum),]
  # rename columns
  colnames(total_appear) <-
    c(
      "var_name",
      "magnitude_appear",
      "mre_appear",
      "spearman_appear",
      "pearson_appear",
      "distri_appear",
      "spearman_diff_appear",
      "sum_appear",
      "NAT_var_old",
      "NAT_var_new",
      "NAT_ratio"
    )
  
  
  #######################################################################
  # test for NA offenders
  #######################################################################
  na_offenders_report <- dat_joined_metrics %>%
    select(var_name, GEO, is_na_present_old, is_na_present_new) %>%
    filter(is_na_present_new | is_na_present_old)
  na_offenders_report_file_name <-
    tempfile(pattern = "test_log_", fileext = ".csv")
  #write_csv(na_offenders_report, na_offenders_report_file_name)
  #tryCatch({
  #  expect_true(
  #    nrow(na_offenders_report) ==  0,
  #    info = glue(
  #      "There are {nrow(na_offenders_report)} feature(s) that have NA observations. See {na_offenders_report_file_name} for details."
  #    )
  #  )
  #}, error = function(e) {
  #  # NA values were observed.
  #  cat(
  #    "Note - There are",
  #    nrow(na_offenders_report),
  #    "feature(s) that have NA observations.\n"
  #  )
  #}, finally = {
  #  # empty
  #})
  
  # return results
  em_result <- list(alert_hybrid = alert_hybrid,
                    alert_magnitude = alert_magnitude,
                    alert_mre = alert_mre,
                    alert_spearman = alert_spearman,
                    alert_pearson = alert_pearson,
                    alert_distribution = alert_distribution,
                    total_appear = total_appear,
                    spearman_hierarchy = spearman_hierarchy,
                    na_offenders_report = na_offenders_report)
  return(em_result)
}