test_that("test output and answer to life are given", {
  expect_equal(testfn("What is the answer to life?"), 42)
})
