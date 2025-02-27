test_that("download_file() generates expected output", {

  # -- Expected behavior --
  # This is testing the **messages** printed to console
  # during the generation of a .docx
  expect_snapshot(download_file("test.docx"))

  # -- Teardown --
  unlink("test.docx")
})
