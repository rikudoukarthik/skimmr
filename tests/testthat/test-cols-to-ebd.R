test_that("vector vs dataframe behaviour works", {

  expect_true(is.data.frame(cols_to_ebd(dummy_mydata(), "mydata")))
  expect_true(is.character(cols_to_ebd(c("Common Name", "Submission ID"), "mydata")))

})

test_that("catch for invalid column name works", {
  expect_warning(cols_to_ebd(c("Common Name", "India Name"), "mydata"),
                 "unrecognised column")
  # case, spelling
  expect_warning(cols_to_ebd(c("common Name", "sci NAME"), "mydata"),
                 "unrecognised column")
})
