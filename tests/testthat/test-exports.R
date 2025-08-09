# test that all functions are being exported, and all exports are actually existing functions

test_that("All functions are exported", {
  # All functions defined in R/ (excluding internal helpers like .foo)
  pkg_funs <- Filter(
    function(x) is.function(get(x, asNamespace("skimmr"))),
    ls(asNamespace("skimmr"), all.names = TRUE)
  )

  # Functions actually exported
  exported_funs <- getNamespaceExports("skimmr")

  # Functions in code but not exported
  unexported <- setdiff(pkg_funs, exported_funs)

  # # You might want to ignore some (internal helpers)
  # ignored <- c("internal_helper", "another_ignored_fun")
  # unexported <- setdiff(unexported, ignored)

  expect_equal(length(unexported), 0,
               info = paste("Unexported functions found:", paste(unexported, collapse = ", ")))
})


test_that("No stale exports in NAMESPACE", {

  exported_funs <- getNamespaceExports("skimmr")
  missing <- exported_funs[!exported_funs %in% ls(asNamespace("skimmr"))]

  # ignore external function exports
  missing <- setdiff(missing, "%>%")

  expect_equal(length(missing), 0,
               info = paste("Exports in NAMESPACE not found in code:", paste(missing, collapse = ", "))
  )

})
