test_that("select_dataset() is providing expected output", {

  # -- Error handling tests --

  # single dataset is provided
  expect_error(select_dataset(c("abc", "def")), "Too many")

  # appropriate dataset is provided
  expect_error(select_dataset(c("abc")), "Invalid")

  # -- Expected behavior --
  # looking for the proper number of observations ensures that
  # not only did a data.frame load, but that it was the proper one
  expect_equal(35, nrow(select_dataset("BMT")))
})
