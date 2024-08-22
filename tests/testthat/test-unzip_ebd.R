# test_file(test_path("test-unzip_ebd.R"))

test_that("Errors when params not loaded before", {

  remove_param()
  expect_error(unzip_ebd(dataset_str = "ebd_bkclau2_unv_smp_rel",
                         dir_name = test_path()),
               "get_param()")

})

test_that("Errors when input dataset_str is incorrect", {

  get_param(date_currel = "2024-07-01")
  expect_error(unzip_ebd(dataset_str = "incorrect-str",
                         dir_name = test_path()),
               "Specified zip file of data does not exist")

})

test_that("Errors when unzip_which is invalid", {

  get_param(date_currel = "2024-07-01")
  expect_error(unzip_ebd(dataset_str = "ebd_bkclau2_unv_smp_relJul-2024.zip",
                         unzip_which = "abc",
                         dir_name = test_path()),
               "Invalid input for unzip_which argument")

})

test_that("Does not error when all inputs correct and params loaded before", {

  get_param(date_currel = "2024-07-01")
  expect_no_error(unzip_ebd(dataset_str = "ebd_bkclau2_unv_smp_rel",
                            unzip_which = "ebd",
                            dir_name = test_path()))

})

test_that("File exist check works", {

  get_param(date_currel = "2024-07-01")
  expect_message(unzip_ebd(dataset_str = "ebd_bkclau2_unv_smp_rel",
                           unzip_which = "ebd",
                           dir_name = test_path()),
                 "Specified data already unzipped.")

  if (file.exists(test_path("ebd_bkclau2_unv_smp_relJul-2024_unvetted.txt"))) {
    file.remove(test_path("ebd_bkclau2_unv_smp_relJul-2024_unvetted.txt"))
  }
  expect_no_message(unzip_ebd(dataset_str = "ebd_bkclau2_unv_smp_rel",
                              unzip_which = "unv",
                              dir_name = test_path()),
                    message = "Specified data already unzipped.")

  if (file.exists("ebd_bkclau2_unv_smp_relJul-2024.txt")) {
    file.remove(test_path("ebd_bkclau2_unv_smp_relJul-2024.txt"))
  }
  expect_no_message(unzip_ebd(dataset_str = "ebd_bkclau2_unv_smp_rel",
                              unzip_which = "ebd",
                              dir_name = test_path()),
                    message = "Specified data already unzipped.")

})
