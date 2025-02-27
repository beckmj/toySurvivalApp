
test_that("make_eda_plot() returns expected output", {

  # -- generate plot --
  # Code is taken from the function example

  # generate data
  set.seed(101)

  df <- data.frame(
  a = runif(100),
  b = runif(100, min = 1, max = 10),
  c = round(runif(100, min = 1, max = 100), 0)
  ) %>%
  tidyr::pivot_longer(everything())

  # visualize
  eda_plot <- make_eda_plot(df, "Histogram")

  # -- Expected behavior --
  # Verify that the plot generated and is identical to the one previously
  # produced
  expect_snapshot_output(eda_plot)

  # -- Teardown --
  unlink("Rplots.pdf")

})
