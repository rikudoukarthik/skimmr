test_that("cols_print_only works (prints and returns column names)", {

  expect_contains(

    read.ebd(test_path("test-ebd.txt"), cols_print_only = TRUE),
    c("LAST.EDITED.DATE","CATEGORY","COMMON.NAME","EXOTIC.CODE","OBSERVATION.COUNT",
      "BREEDING.CODE","STATE","STATE.CODE","COUNTY","COUNTY.CODE","LOCALITY","LOCALITY.ID",
      "LOCALITY.TYPE","LATITUDE","LONGITUDE","OBSERVATION.DATE","TIME.OBSERVATIONS.STARTED",
      "OBSERVER.ID","SAMPLING.EVENT.IDENTIFIER","PROTOCOL.TYPE","DURATION.MINUTES",
      "EFFORT.DISTANCE.KM","NUMBER.OBSERVERS","ALL.SPECIES.REPORTED","GROUP.IDENTIFIER",
      "HAS.MEDIA","APPROVED","REVIEWED","TRIP.COMMENTS","SPECIES.COMMENTS")

  )

  expect_output(read.ebd(test_path("test-ebd.txt"), cols_print_only = TRUE))

})

test_that("cols_style_ebd works", {

  expect_contains(
    read.mydata(test_path("MyEBirdData.csv"), cols_print_only = TRUE, cols_style_ebd = TRUE),
    c("SAMPLING.EVENT.IDENTIFIER", "COMMON.NAME")
  )
  expect_contains(
    read.mydata(test_path("MyEBirdData.csv"), cols_print_only = TRUE, cols_style_ebd = FALSE),
    c("Submission ID", "Common Name")
  )

  expect_failure(
    expect_contains(
      read.mydata(test_path("MyEBirdData.csv"), cols_print_only = TRUE, cols_style_ebd = TRUE),
      c("Submission ID", "Common Name")
    )
  )

  expect_failure(
    expect_contains(
      read.mydata(test_path("MyEBirdData.csv"), cols_print_only = TRUE, cols_style_ebd = FALSE),
      c("SAMPLING.EVENT.IDENTIFIER", "COMMON.NAME")
    )
  )

})

test_that("cols_sel works", {

  col_to_sel <- "COMMON.NAME"
  expect_equal(
    names(read.ebd(test_path("test-ebd.txt"), cols_print_only = FALSE,
                   cols_sel = col_to_sel)),
    col_to_sel
  )

  col_to_sel <- "COMMON.NAME"
  expect_equal(
    names(read.mydata(test_path("MyEBirdData.csv"), cols_print_only = FALSE, cols_style_ebd = TRUE,
                      cols_sel = col_to_sel)),
    col_to_sel
  )

  col_to_sel <- "Common Name"
  expect_equal(
    names(read.mydata(test_path("MyEBirdData.csv"), cols_print_only = FALSE, cols_style_ebd = FALSE,
                      cols_sel = col_to_sel)),
    col_to_sel
  )

  # input > 1 column names to select
  col_to_sel <- c("Common Name", "Submission ID")
  expect_equal(
    names(read.mydata(test_path("MyEBirdData.csv"), cols_print_only = FALSE, cols_style_ebd = FALSE,
                      cols_sel = col_to_sel)),
    col_to_sel
  )
  col_to_sel <- c("COMMON.NAME", "SAMPLING.EVENT.IDENTIFIER")
  expect_equal(
    names(read.ebd(test_path("test-ebd.txt"), cols_print_only = FALSE,
                   cols_sel = col_to_sel)),
    col_to_sel
  )

})

test_that("error catch for invalid column name input works", {

  expect_error(read.ebd(test_path("test-ebd.txt"), cols_sel = "Common Name"),
               "invalid")
  expect_error(read.ebd(test_path("test-ebd.txt"), cols_sel = "INVALID.COLUMN"),
               "invalid")

  expect_error(read.mydata(test_path("MyEBirdData.csv"), cols_sel = "COMMON.NAME",
                           cols_style_ebd = FALSE),
               "invalid")
  expect_error(read.mydata(test_path("MyEBirdData.csv"), cols_sel = "Common Name",
                           cols_style_ebd = TRUE),
               "invalid")
  expect_error(read.mydata(test_path("MyEBirdData.csv"), cols_sel = "Invalid Column",
                           cols_style_ebd = FALSE),
               "invalid")

})

# c("LAST.EDITED.DATE","CATEGORY","COMMON.NAME","EXOTIC.CODE","OBSERVATION.COUNT",
#   "BREEDING.CODE","STATE","STATE.CODE","COUNTY","COUNTY.CODE","LOCALITY","LOCALITY.ID",
#   "LOCALITY.TYPE","LATITUDE","LONGITUDE","OBSERVATION.DATE","TIME.OBSERVATIONS.STARTED",
#   "OBSERVER.ID","SAMPLING.EVENT.IDENTIFIER","PROTOCOL.TYPE","DURATION.MINUTES",
#   "EFFORT.DISTANCE.KM","NUMBER.OBSERVERS","ALL.SPECIES.REPORTED","GROUP.IDENTIFIER",
#   "HAS.MEDIA","APPROVED","REVIEWED","TRIP.COMMENTS","SPECIES.COMMENTS","GROUP.ID",
#   "YEAR","MONTH","DAY.M","M.YEAR","M.MONTH")
