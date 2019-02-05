context("Magnitude test")
library(RESTORE)

test_that("The same magnitude", {
  expect_true(magnitude_ratio(1, 1))
  expect_true(magnitude_ratio(1, 5))
  expect_true(magnitude_ratio(5, 1))
  expect_true(magnitude_ratio(505, 550))
  expect_true(magnitude_ratio(0, 0))
  expect_true(magnitude_ratio(1, 9.999))
  expect_true(magnitude_ratio(9.999, 1))
  expect_true(magnitude_ratio(-9.999, -1))
  expect_true(magnitude_ratio(-100, -110.1))
  expect_true(magnitude_ratio(0.1, 0.11))
})

test_that("Different magnitudes", {
  expect_false(magnitude_ratio(1, 11))
  expect_false(magnitude_ratio(11, 1))
  expect_false(magnitude_ratio(11, -11))
  expect_false(magnitude_ratio(-11, 11))
  expect_false(magnitude_ratio(1.1, 1000))
  expect_false(magnitude_ratio(1000, 1.1))
})


test_that("Can't compute magnitude", {
  expect_warning(magnitude_ratio(0, 1))
  expect_true(is.na(magnitude_ratio(1, 0)))
  expect_true(is.na(magnitude_ratio(0, 1)))
  expect_true(is.na(magnitude_ratio(0.1, 0)))
  expect_true(is.na(magnitude_ratio(0, 0.1)))
})
