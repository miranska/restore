#############################################
# Testing
#############################################
#test expected values
test_violation <-
  function(expected_number_of_joined_rows,
           expected_column_names_in_new_dataset,
           check_for_order_of_column_names_in_the_new_dataset,
           hierarchy_levels,
           dat_new,
           hierarchy_column_name) {
    test_that("check the expected number of joined rows", {
      skip_if(is.na(expected_number_of_joined_rows), message = "Skipping the check for the joined number of rows, as the expected value is not set.")
      if (!is.na(expected_number_of_joined_rows)) {
        # adding if block to speed up computations
        actual_number_of_joined_rows <- nrow(inner_join(
          dat_old,
          dat_new,
          by = c(hierarchy_column_name, key_column_name)
        ))
      }
      tryCatch({
        expect_equal(
          actual_number_of_joined_rows,
          expected_number_of_joined_rows,
          info = glue(
            "We expected to see {expected_number_of_joined_rows} joined rows but got {actual_number_of_joined_rows}."
          )
        )
      }, error = function(e) {
        cat(
          "Note - We expected to see",
          expected_number_of_joined_rows,
          "joined rows but got",
          actual_number_of_joined_rows,
          ".\n"
        )
      }, finally = {
        # empty
      })
    })
    
    test_that("expected column names in the new dataset (unordered)", {
      skip_if(is.na(expected_column_names_in_new_dataset), message = "Skipping the check for the expected column names in the new dataset, as the expected values are not set.")
      tryCatch({
        expect_equal(
          sort(colnames(dat_new)),
          sort(expected_column_names_in_new_dataset),
          info = paste0(
            "Columns names, present in the new dataset, which are absent in the expected list: ",
            paste(
              setdiff(
                colnames(dat_new),
                expected_column_names_in_new_dataset
              ),
              collapse = ", "
            ),
            ".\n",
            "Columns names, absent in the new dataset, which are present in the expected list: ",
            paste(
              setdiff(
                expected_column_names_in_new_dataset,
                colnames(dat_new)
              ),
              collapse = ", "
            ),
            "."
          )
        )
      }, error = function(e) {
        cat(
          "Note - columns names, present in the new dataset, which are absent in the expected list:",
          setdiff(
            colnames(dat_new),
            expected_column_names_in_new_dataset
          ),
          "\n"
        )
        cat(
          "Note - columns names, absent in the new dataset, which are present in the expected list:",
          setdiff(
            expected_column_names_in_new_dataset,
            colnames(dat_new)
          ),
          "\n"
        )
      }, finally = {
        # empty
      })
    })
    
    test_that("expected column names in the new dataset (ordered)", {
      skip_if_not(check_for_order_of_column_names_in_the_new_dataset,
                  message = "Skipping the check of the order of column names.")
      skip_if(is.na(expected_column_names_in_new_dataset), message = "Skipping the check for the expected column names in the new dataset, as the expected values are not set.")
      tryCatch({
        expect_equal(colnames(dat_new),
                     expected_column_names_in_new_dataset)
      }, error = function(e) {
        cat(
          "Note - colnames(dat_new) not equal to expected_column_names_in_new_dataset.\n"
        )
      }, finally = {
        # empty
      })
    })
    
    test_that("hierarchy_levels", {
      actual_hierarchy_levels_in_new_dataset <-
        unique(dat_new[[hierarchy_column_name]])
      tryCatch({
        expect_equal(
          sort(actual_hierarchy_levels_in_new_dataset),
          sort(hierarchy_levels),
          info = paste0(
            "Hierarchy levels, present in the new dataset, which are absent in the expected list: ",
            paste(
              setdiff(
                actual_hierarchy_levels_in_new_dataset,
                hierarchy_levels
              ),
              collapse = ", "
            ),
            ".\n",
            "Hierarchy levels, absent in the new dataset, which are present in the expected list: ",
            paste(
              setdiff(
                hierarchy_levels,
                actual_hierarchy_levels_in_new_dataset
              ),
              collapse = ", "
            ),
            "."
          )
        )
      }, error = function(e) {
        cat(
          "Note - hierarchy levels, present in the new dataset, which are absent in the expected list:",
          setdiff(
            actual_hierarchy_levels_in_new_dataset,
            hierarchy_levels
          ),
          "\n"
        )
        cat(
          "Note - hierarchy levels, absent in the new dataset, which are present in the expected list:",
          setdiff(
            hierarchy_levels,
            actual_hierarchy_levels_in_new_dataset
          ),
          "\n"
        )
      }, finally = {
        # empty
      })
    })
  }
