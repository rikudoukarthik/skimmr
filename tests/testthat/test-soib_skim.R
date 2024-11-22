test_that("error catch works", {
  expect_error(soib_skim("subcontinent"), "valid mask")
  expect_error(soib_skim("Palakkad"), "valid mask") # valid spatial units
  expect_error(soib_skim("ones"), "valid mask") # case-sensitivity
})
