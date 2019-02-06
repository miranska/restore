# produce final report
produce_reports <-
  function(hm,
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
           report_var_attr) {
    if (!is.null(final_report) && is.null(final_data)) {
      # write to xlsx file
      ########################################
      # write all results to an xlsx file
      ########################################
      # create a workbook
      wb <- createWorkbook("Results")
      
      # 1.create tab for joined metrics
      if (report_join == TRUE) {
        addWorksheet(wb, "Joined Metrics")
        writeData(wb, "Joined Metrics", jm$dat_joined_metrics)
      }
      # 2.create tab for hybrid alerts
      if (report_hybrid == TRUE) {
        addWorksheet(wb, "Hybrid Alerts")
        writeData(wb, "Hybrid Alerts", em$alert_hybrid)
      }
      # 3. create tab for magnitude metrics
      if (report_magnitude == TRUE) {
        addWorksheet(wb, "Magnitude Alerts")
        writeData(wb, "Magnitude Alerts", em$alert_magnitude)
      }
      # 3.create tab for mre alerts
      if (report_mre == TRUE) {
        addWorksheet(wb, "MRE Alerts")
        writeData(wb, "MRE Alerts", em$alert_mre)
      }
      # 4.create tab for spearman alerts
      if (report_spearman == TRUE) {
        addWorksheet(wb, "Spearman Alerts")
        writeData(wb, "Spearman Alerts", em$alert_spearman)
      }
      # 5.create tab for pearson alerts
      if (report_pearson == TRUE) {
        addWorksheet(wb, "Pearson Alerts")
        writeData(wb, "Pearson Alerts", em$alert_pearson)
      }
      # 6.create tab for distribution alerts
      if (report_distribution == TRUE) {
        addWorksheet(wb, "Distribution Alerts")
        writeData(wb, "Distribution Alerts", em$alert_distribution)
      }
      # 7.create tab for spearman differences
      if (report_spearman_diff == TRUE) {
        addWorksheet(wb, "Spearman Difference")
        writeData(wb, "Spearman Difference", em$spearman_hierarchy)
      }
      # 8.create tab for appearances
      if (report_rank == TRUE) {
        addWorksheet(wb, "Ranking")
        writeData(wb, "Ranking", em$total_appear)
      }
      # 9.create tab for features with na values
      if (report_na == TRUE) {
        addWorksheet(wb, "NA Features")
        writeData(wb, "NA Features", em$na_offenders_report)
      }
      #10.report variable attributes
      if (report_var_attr  == TRUE) {
        addWorksheet(wb, "Variable Attributes")
        
        count_of_columns_missing_in_old_dataset <-
          length(hm$columns_absent_in_dat_old)
        count_of_columns_missing_in_new_dataset <-
          length(hm$columns_absent_in_dat_new)
        
        attr_report <- data.frame(
          "Description"  = c(
            "Count of rows in non-joined datasets",
            "Count of rows that could not be joined",
            "Count of columns in non-joined datasets",
            "Number of columns missing"
          ),
          "Test passed" = c(
            hm$is_row_count_same,
            hm$no_rows_not_in_join,
            hm$is_col_count_same,
            hm$no_columns_missing
          ),
          "Old Vintage" = c(
            hm$dat_old.row_count,
            hm$dat_old.row_count_not_in_join,
            hm$dat_old.col_count,
            count_of_columns_missing_in_old_dataset
          ),
          "New Vintage" = c(
            hm$dat_new.row_count,
            hm$dat_new.row_count_not_in_join,
            hm$dat_new.col_count,
            count_of_columns_missing_in_new_dataset
          )
        )
        
        writeData(wb, "Variable Attributes", attr_report)
        
        addWorksheet(wb, "Missing Column Names")
        
        missing_columns <-
          data.frame("Absent in" = c(), "Column Name" = c())
        
        if (count_of_columns_missing_in_old_dataset > 0) {
          missing_columns <- rbind(
            missing_columns,
            data.frame(
              "Absent in" = "Old",
              "Column Name" = hm$columns_absent_in_dat_old
            )
          )
        }
        if (count_of_columns_missing_in_new_dataset > 0) {
          missing_columns <- rbind(
            missing_columns,
            data.frame(
              "Absent in" = "New",
              "Column Name" = hm$columns_absent_in_dat_new
            )
          )
        }
        if (nrow(missing_columns) == 0) {
          missing_columns <-
            data.frame(
              "Absent in" = c('None'),
              "Column Name" = c('No missing columns')
            )
        }
        
        writeData(wb, "Missing Column Names", missing_columns)
        
      }
      
      # write the final results
      saveWorkbook(wb, final_report, overwrite = TRUE)
      
      # return null
      return(NULL)
      
    } else if (is.null(final_report) && !is.null(final_data)) {
      # return object
      list_of_datasets <- list(
        "Joined Metrics" = jm$dat_joined_metrics,
        "Hybrid Alerts" = em$alert_hybrid,
        "Magnitude Alerts" = em$alert_magnitude,
        "MRE Alerts" = em$alert_mre,
        "Spearman Alerts" = em$alert_spearman,
        "Pearson Alerts" = em$alert_pearson,
        "Distribution Alerts" = em$alert_distribution,
        "Spearman Difference" = em$spearman_hierarchy,
        "Ranking" = em$total_appear,
        "NA Features" = em$na_offenders_report,
        "Variable Attributes" = hm
      )
      return(list_of_datasets)
      
    } else {
      stop("Please provide only final_report or final_data.")
    }
  }