context("Test joining of datasets")
library(RESTORE)

d_old <- tibble(key = c("a", "b", "c", "1"),
                h = c(1, 2, 2, 3),
                v1 = c(1, 5, 12, 4),
                v2 = c(6, 5.2, 8, 1)
                )

d_new <- tibble(key = c("a", "b", "NA", "1", "a", "a"),
                h = c(1, 2, 2, 3, NA, 5),
                v1 = c(1, 5, 12, 4, 2, 3),
                v2 = c(6, 5.2, 8, 1, 7, 8)
)

d_new_three <- tibble(key = c("a", "b", "NA", "1", "a", "a"),
                h = c(1, 2, 2, 3, NA, 5),
                v1 = c(1, 5, 12, 4, 2, 3),
                v2 = c(6, 5.2, 8, 1, 7, 8), 
                v3 = c(6, 5.2, 8, 1, 7, 8)
)

d_new_four <- tibble(key = c("a", "b", "NA", "1", "a", "a"),
                      h = c(1, 2, 2, 3, NA, 5),
                      v4 = c(1, 5, 12, 4, 2, 3),
                      v2 = c(6, 5.2, 8, 1, 7, 8), 
                      v1 = c(6, 5.2, 8, 1, 7, 8),
                      v5 = c(6, 5.2, 8, 1, 7, 8)
)

test_that("Identical datasets", {
  d_j <- join_datasets(d_old, d_old, 'h', 'key')
  expect_equal(nrow(d_j), 8)
  expect_equal(ncol(d_j), 5)
  expect_equal(length(unique(d_j$var_name)), 2)
})

test_that("Identical datasets with na in key columns - na are treated as values", {
  d_j <- join_datasets(d_new, d_new, 'h', 'key')
  expect_equal(nrow(d_j), 12)
  expect_equal(ncol(d_j), 5)
  expect_equal(length(unique(d_j$var_name)), 2)
})

test_that("Different datasets, different column count", {
  d_j <- join_datasets(d_new_three, d_new_four, 'h', 'key')
  expect_equal(nrow(d_j), 12)
  expect_equal(ncol(d_j), 5)
  expect_equal(length(unique(d_j$var_name)), 2)
})

