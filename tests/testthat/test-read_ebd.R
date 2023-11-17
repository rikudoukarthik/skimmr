test_that("cols_print_only works (prints and returns column names)", {

  expect_equal(

    read.ebd(test_path("test-ebd.txt"), cols_print_only = TRUE),
    c("LAST.EDITED.DATE","CATEGORY","COMMON.NAME","EXOTIC.CODE","OBSERVATION.COUNT",
      "BREEDING.CODE","STATE","STATE.CODE","COUNTY","COUNTY.CODE","LOCALITY","LOCALITY.ID",
      "LOCALITY.TYPE","LATITUDE","LONGITUDE","OBSERVATION.DATE","TIME.OBSERVATIONS.STARTED",
      "OBSERVER.ID","SAMPLING.EVENT.IDENTIFIER","PROTOCOL.TYPE","DURATION.MINUTES",
      "EFFORT.DISTANCE.KM","NUMBER.OBSERVERS","ALL.SPECIES.REPORTED","GROUP.IDENTIFIER",
      "HAS.MEDIA","APPROVED","REVIEWED","TRIP.COMMENTS","SPECIES.COMMENTS","GROUP.ID",
      "YEAR","MONTH","DAY.M","M.YEAR","M.MONTH")

  )

  expect_output(read.ebd(test_path("test-ebd.txt"), cols_print_only = TRUE))

})
