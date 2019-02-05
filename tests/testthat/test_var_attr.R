context("Test variable's attributes and row count not in the join")
library(RESTORE)

dat_two_col_three_rows <- tibble(a = c("a", "b", "c"),
                bc = c(1, 2, 3))

dat_three_col_three_rows <- tibble(a = c("a", "b", "c"),
                bc = c(1, 2, 3), 
                cd = c(5, 2, 3))

dat_three_col_five_rows <- tibble(a = c("a", "b", "c", "d", "e"),
                bc = c(1, 2, 3, 4, 21), 
                cd = c(5, 2, 3, 5, 15))

dat_four_col_three_rows <- tibble(a = c("a", "b", "c"),
                                  aa = c("e", "f", "gg"),
                                  bc = c(1, 2, 3), 
                                  cd = c(5, 2, 3))

test_that("Identical dataset", {
  m <- compute_high_level_metrics(dat_two_col_three_rows, dat_two_col_three_rows, 0)
  expect_equal(m$dat_old.row_count, 3)
  expect_equal(m$dat_new.row_count, 3)
  expect_equal(m$dat_old.row_count_not_in_join, 3)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_true(m$is_row_count_same)
  expect_equal(m$dat_old.col_count, 2)
  expect_equal(m$dat_new.col_count, 2)
  expect_true(m$is_col_count_same)
  expect_equal(length(m$columns_absent_in_dat_old), 0)
  expect_equal(length(m$columns_absent_in_dat_new), 0)
  expect_true(m$no_columns_missing)
})

test_that("Different datasets - extra column in new", {
  m <- compute_high_level_metrics(dat_two_col_three_rows, dat_three_col_three_rows, 0)
  expect_equal(m$dat_old.row_count, 3)
  expect_equal(m$dat_new.row_count, 3)
  expect_equal(m$dat_old.row_count_not_in_join, 3)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_true(m$is_row_count_same)
  expect_equal(m$dat_old.col_count, 2)
  expect_equal(m$dat_new.col_count, 3)
  expect_false(m$is_col_count_same)
  expect_equal(length(m$columns_absent_in_dat_old), 1)
  expect_equal(m$columns_absent_in_dat_old, c("cd"))
  expect_equal(length(m$columns_absent_in_dat_new), 0)
  expect_false(m$no_columns_missing)
})

test_that("Different datasets - extra column in old", {
  m <- compute_high_level_metrics(dat_three_col_three_rows, dat_two_col_three_rows, 0)
  expect_equal(m$dat_old.row_count, 3)
  expect_equal(m$dat_new.row_count, 3)
  expect_equal(m$dat_old.row_count_not_in_join, 3)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_true(m$is_row_count_same)
  expect_equal(m$dat_old.col_count, 3)
  expect_equal(m$dat_new.col_count, 2)
  expect_false(m$is_col_count_same)
  expect_equal(length(m$columns_absent_in_dat_old), 0)
  expect_equal(length(m$columns_absent_in_dat_new), 1)
  expect_equal(m$columns_absent_in_dat_new, c("cd"))
  expect_false(m$no_columns_missing)
})

test_that("Different datasets - extra two columns in new", {
  m <- compute_high_level_metrics(dat_two_col_three_rows, dat_four_col_three_rows, 0)
  expect_equal(m$dat_old.row_count, 3)
  expect_equal(m$dat_new.row_count, 3)
  expect_equal(m$dat_old.row_count_not_in_join, 3)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_true(m$is_row_count_same)
  expect_equal(m$dat_old.col_count, 2)
  expect_equal(m$dat_new.col_count, 4)
  expect_false(m$is_col_count_same)
  expect_equal(length(m$columns_absent_in_dat_old), 2)
  expect_equal(length(m$columns_absent_in_dat_new), 0)
  expect_equal(m$columns_absent_in_dat_old, c("aa", "cd"))
  expect_false(m$no_columns_missing)
})


test_that("Different datasets - extra two columns in old", {
  m <- compute_high_level_metrics(dat_four_col_three_rows, dat_two_col_three_rows, 0)
  expect_equal(m$dat_old.row_count, 3)
  expect_equal(m$dat_new.row_count, 3)
  expect_equal(m$dat_old.row_count_not_in_join, 3)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_true(m$is_row_count_same)
  expect_equal(m$dat_old.col_count, 4)
  expect_equal(m$dat_new.col_count, 2)
  expect_false(m$is_col_count_same)
  expect_equal(length(m$columns_absent_in_dat_old), 0)
  expect_equal(length(m$columns_absent_in_dat_new), 2)
  expect_equal(m$columns_absent_in_dat_new, c("aa", "cd"))
  expect_false(m$no_columns_missing)
})


test_that("Different datasets - different number of columns and rows", {
  m <- compute_high_level_metrics(dat_four_col_three_rows, dat_three_col_five_rows, 0)
  expect_equal(m$dat_old.row_count, 3)
  expect_equal(m$dat_new.row_count, 5)
  expect_equal(m$dat_old.row_count_not_in_join, 3)
  expect_equal(m$dat_new.row_count_not_in_join, 5)
  expect_false(m$is_row_count_same)
  expect_equal(m$dat_old.col_count, 4)
  expect_equal(m$dat_new.col_count, 3)
  expect_false(m$is_col_count_same)
  expect_equal(length(m$columns_absent_in_dat_old), 0)
  expect_equal(length(m$columns_absent_in_dat_new), 1)
  expect_equal(m$columns_absent_in_dat_new, c("aa"))
  expect_false(m$no_columns_missing)
})

test_that("Different datasets - different number of columns and rows", {
  m <- compute_high_level_metrics(dat_three_col_five_rows, dat_four_col_three_rows, 0)
  expect_equal(m$dat_old.row_count, 5)
  expect_equal(m$dat_new.row_count, 3)
  expect_equal(m$dat_old.row_count_not_in_join, 5)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_false(m$is_row_count_same)
  expect_equal(m$dat_old.col_count, 3)
  expect_equal(m$dat_new.col_count, 4)
  expect_false(m$is_col_count_same)
  expect_equal(length(m$columns_absent_in_dat_old), 1)
  expect_equal(length(m$columns_absent_in_dat_new), 0)
  expect_equal(m$columns_absent_in_dat_old, c("aa"))
  expect_false(m$no_columns_missing)
})


test_that("Different datasets - different number of columns and rows - focus on non-joined rows count", {
  m <- compute_high_level_metrics(dat_three_col_five_rows, dat_four_col_three_rows, 0)
  expect_equal(m$dat_old.row_count_not_in_join, 5)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_false(m$no_rows_not_in_join)

  m <- compute_high_level_metrics(dat_three_col_five_rows, dat_four_col_three_rows, 1)
  expect_equal(m$dat_old.row_count_not_in_join, 4)
  expect_equal(m$dat_new.row_count_not_in_join, 2)
  expect_false(m$no_rows_not_in_join)

  m <- compute_high_level_metrics(dat_three_col_five_rows, dat_four_col_three_rows, 2)
  expect_equal(m$dat_old.row_count_not_in_join, 3)
  expect_equal(m$dat_new.row_count_not_in_join, 1)
  expect_false(m$no_rows_not_in_join)
  
  m <- compute_high_level_metrics(dat_four_col_three_rows, dat_three_col_five_rows, 1)
  expect_equal(m$dat_old.row_count_not_in_join, 2)
  expect_equal(m$dat_new.row_count_not_in_join, 4)
  expect_false(m$no_rows_not_in_join)

  m <- compute_high_level_metrics(dat_four_col_three_rows, dat_three_col_five_rows, 2)
  expect_equal(m$dat_old.row_count_not_in_join, 1)
  expect_equal(m$dat_new.row_count_not_in_join, 3)
  expect_false(m$no_rows_not_in_join)

  m <- compute_high_level_metrics(dat_four_col_three_rows, dat_four_col_three_rows, 3)
  expect_equal(m$dat_old.row_count_not_in_join, 0)
  expect_equal(m$dat_new.row_count_not_in_join, 0)
  expect_true(m$no_rows_not_in_join)

  m <- compute_high_level_metrics(dat_three_col_five_rows, dat_three_col_five_rows, 5)
  expect_equal(m$dat_old.row_count_not_in_join, 0)
  expect_equal(m$dat_new.row_count_not_in_join, 0)
  expect_true(m$no_rows_not_in_join)
  
})
