test_that("Runs without errors", {

  expect_no_error(dummy_ebd(500) %>% filter_eligible(standard = "bci"))
  expect_no_error(dummy_ebd(500) %>% filter_eligible(standard = "ebird"))

})

test_that("Error catches work", {

  # errors
  expect_error(dummy_ebd(100) %>% filter_eligible(standard = NULL),
               "one filtering criterion")
  expect_error(dummy_ebd(100) %>%
                 dplyr::select(-ALL.SPECIES.REPORTED) %>%
                 filter_eligible(),
               "required columns")

  # warnings
  expect_warning(dummy_ebd(100) %>% filter_eligible("bci", complete = FALSE))
  expect_warning(dummy_ebd(100) %>% filter_eligible("bci", complete = FALSE, duration = 10, counts = TRUE))
  expect_warning(dummy_ebd(100) %>% filter_eligible("ebird", complete = TRUE))
  expect_warning(dummy_ebd(100) %>% filter_eligible("ebird", complete = TRUE, duration = 20, counts = FALSE))

})

test_that("BCI criterion is more stringent than eBird", {

  test_data <- dummy_ebd(500) # testing with same data for both since randomisation
  bci <- dplyr::n_distinct((test_data %>% filter_eligible(standard = "bci"))$SAMPLING.EVENT.IDENTIFIER)
  ebird <- dplyr::n_distinct((test_data %>% filter_eligible(standard = "ebird"))$SAMPLING.EVENT.IDENTIFIER)
  expect_gte(ebird, bci)

})
