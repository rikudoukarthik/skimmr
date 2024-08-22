#' Unzip eBird Basic Dataset (EBD) file
#'
#' @description
#'
#' Unzips an EBD data download file, and saves any of three selected data files: main dataset
#' of vetted observation records, sampling event data (SED), and unvetted records.
#'
#' `dataset_str` varies with options selected when downloading the data; it may contain
#' district-level admin. codes, or species codes, or tags indicating whether or not SED
#' and unvetted data are included.
#'
#' @param dataset_str character; the string in the file name of the data download, ending with `_rel`
#' @param unzip_which character; vector listing which of "ebd", "sed" and "unv" to unzip
#' @param dir_name character; specify subfolder name of zip file (if exists), without
#' the trailing slash
#'
#' @return Does not return output. Specified files are unzipped and saved in the local directory.
#' @export
#'
unzip_ebd <- function(dataset_str = "ebd_IN_unv_smp_rel", unzip_which = c("ebd", "sed"),
                      dir_name = NULL) {

  # unzip_which can only be one of these three
  if (any(!unzip_which %in% c("ebd", "sed", "unv"))) {
    stop('Invalid input for unzip_which argument! Please select any of c("ebd", "sed", "unv").')
  }


  # load EBD parameters of interest
  if (!exists("currel_month_lab", envir = .GlobalEnv) &
      !exists("currel_year", envir = .GlobalEnv)) {
    stop("No information about EBD of interest. Load release info by running get_param().")
  }


  # getting file paths

  path_zip <- if (!is.null(dir_name))
    glue::glue("{dir_name}/{dataset_str}{currel_month_lab}-{currel_year}.zip") else
      glue::glue("{dataset_str}{currel_month_lab}-{currel_year}.zip")

  if ("ebd" %in% unzip_which) {
    file_ebd_main <- glue::glue("{dataset_str}{currel_month_lab}-{currel_year}.txt")
    path_ebd_main <- if (!is.null(dir_name)) glue::glue("{dir_name}/{file_ebd_main}") else file_ebd_main
  }

  if ("sed" %in% unzip_which) {
    file_sed <- glue::glue("{dataset_str}{currel_month_lab}-{currel_year}_sampling.txt")
    path_sed <- if (!is.null(dir_name)) glue::glue("{dir_name}/{file_sed}") else file_sed
  }

  if ("unv" %in% unzip_which) {
    file_ebd_unv <- glue::glue("{dataset_str}{currel_month_lab}-{currel_year}_unvetted.txt")
    path_ebd_unv <- if (!is.null(dir_name)) glue::glue("{dir_name}/{file_ebd_unv}") else file_ebd_unv
  }


  # file exist checks & list of output files
  if ("ebd" %in% unzip_which & "sed" %in% unzip_which & "unv" %in% unzip_which) {

    file_exist_check <- file.exists(path_ebd_main) & file.exists(path_sed) & file.exists(path_ebd_unv)
    list_files <- c(file_ebd_main, file_sed, file_ebd_unv)

  } else if ("ebd" %in% unzip_which & "sed" %in% unzip_which) {

    file_exist_check <- file.exists(path_ebd_main) & file.exists(path_sed)
    list_files <- c(file_ebd_main, file_sed)

  } else if ("sed" %in% unzip_which & "unv" %in% unzip_which) {

    file_exist_check <- file.exists(path_sed) & file.exists(path_ebd_unv)
    list_files <- c(file_sed, file_ebd_unv)

  } else if ("ebd" %in% unzip_which & "unv" %in% unzip_which) {

    file_exist_check <- file.exists(path_ebd_main) & file.exists(path_ebd_unv)
    list_files <- c(file_ebd_main, file_ebd_unv)

  } else if ("ebd" %in% unzip_which) {

    file_exist_check <- file.exists(path_ebd_main)
    list_files <- c(file_ebd_main)

  } else if ("sed" %in% unzip_which) {

    file_exist_check <- file.exists(path_sed)
    list_files <- c(file_sed)

  } else if ("unv" %in% unzip_which) {

    file_exist_check <- file.exists(path_ebd_unv)
    list_files <- c(file_ebd_unv)

  }


  if (file_exist_check == TRUE) {

    message("Specified data already unzipped.")

  } else {

    if (!file.exists(path_zip)) {
      stop(glue::glue("Specified zip file of data does not exist! ({path_zip})"))
    } else {
      utils::unzip(zipfile = path_zip, files = list_files,
                   exdir = if (!is.null(dir_name)) dir_name else ".")
      message("Data unzipped!")
    }

  }


}
