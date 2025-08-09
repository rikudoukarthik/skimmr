#' Load eBird data files
#'
#' @description
#'
#' Reads a .txt eBird data file and creates a data frame from it, with cases corresponding to
#' lines (rows) and variables to fields (columns) in the file.
#'
#' The most commonly used types of eBird data files are the eBird Basic Dataset (EBD;
#' which may contain three subtypes of files) and the My Data download
#' (which contains all data associated with a specific eBird account). The two differ in
#' their download file type, column naming format, available columns, etc.
#'
#' `read.ebd` and `read.mydata` import the EBD and My Data files respectively. Since EBD contains several columns, which may not all be required for a given usecase,
#' `cols_sel` can be used to import only a subset of the columns. To see the list of all
#' columns names to choose from, run `read.ebd(ebd_path, cols_print_only = TRUE)`.
#'
#' This function is a wrapper around `utils::read.delim()`, which is considerably faster
#' than the `readr::read_delim()` used in `auk::read_ebd()`. Moreover, unlike the latter
#' which uses snake case for column names, this function uses uppercase with period separators.
#'
#' @param path character; the path to the downloaded EBD .txt file
#' @param cols_sel character; vector of column names to be imported from the dataset
#' @param cols_print_only logical; whether or not to only print the full set of column
#'   names
#'
#' @return A data frame (`cols_print_only == FALSE`), or a character vector of column names
#'  (`cols_print_only == TRUE`)
#'
#' @importFrom utils read.delim
#' @export
#'
#' @examples
#' # to see list of column names before choosing
#' test1 <- data.frame(SAMPLING.EVENT.IDENTIFIER = "S0000001", COMMON.NAME = "Indian Peafowl")
#' tf <- tempfile()
#' write.table(test1, file = tf, col.names = TRUE, row.names = FALSE, sep = "\t",
#'             quote = FALSE) # quote = TRUE surrounds column names by quotes
#' read.ebd(tf, cols_print_only = TRUE)
#'
#' # select columns and import data
#' read.ebd(tf, cols_sel = c("SAMPLING.EVENT.IDENTIFIER", "COMMON.NAME"))

read.ebd <- function(path, cols_sel = "all", cols_print_only = FALSE) {

  cols_all <- names(utils::read.delim(path, nrows = 1,
                                      sep = "\t", header = TRUE, quote = "",
                                      stringsAsFactors = FALSE, na.strings = c("", " ", NA)))

  if (!identical(cols_sel, "all")) {
    if (!all(cols_sel %in% cols_all)) {
      stop("Specified column name is invalid. Run read.ebd(., cols_print_only = TRUE) to see valid names.")
    }
  }

  # if needed, first see entire list of available columns from which selection can be
  # made later

  if (cols_print_only == TRUE) {

    print(cols_all)

  } else {

    if (identical(cols_sel, "all")) {

      data <- utils::read.delim(path,
                                sep = "\t", header = TRUE, quote = "",
                                stringsAsFactors = FALSE, na.strings = c("", " ", NA))

    } else {

      cols_all[!(cols_all %in% cols_sel)] <- "NULL"
      cols_all[cols_all %in% cols_sel] <- NA

      data <- utils::read.delim(path, colClasses = cols_all,
                                sep = "\t", header = TRUE, quote = "",
                                stringsAsFactors = FALSE, na.strings = c("", " ", NA))

    }

    return(data)

  }

}


#' @rdname read.ebd
#' @format NULL
#' @param cols_style_ebd logical; if `TRUE` (default), change column names in My Data to uppercase
#'    and separated by period (COLUMN.STYLE), as in `read.ebd()`
#' @export

read.mydata <- function(path = "MyEBirdData.csv",
                        cols_sel = "all", cols_print_only = FALSE, cols_style_ebd = FALSE) {

  mini_data <- readr::read_csv(path, n_max = 1,
                               col_names = TRUE, quote = "",
                               na = c("", " ", NA),
                               show_col_types = FALSE) %>%
    suppressWarnings() # suppress parsing warnings

  # change column name style if needed
  if (cols_style_ebd == TRUE) {
    mini_data <- cols_to_ebd(mini_data)
  }

  cols_all <- names(mini_data)


  # check that input column names are valid
  if (!identical(cols_sel, "all")) {
    if (!all(cols_sel %in% cols_all)) {
      stop(paste("Specified column name is invalid. Run read.ebd(., cols_print_only = TRUE) to see valid names.",
                 "Also check input name is same style as output style (cols_style_ebd)."))
    }
  }


  # if needed, first see entire list of available columns from which selection can be
  # made later

  if (cols_print_only == TRUE) {

    print(cols_all)

  } else {

    data <- readr::read_csv(path,
                            col_names = TRUE, quote = "",
                            na = c("", " ", NA),
                            show_col_types = FALSE) %>%
      # change column name style if needed
      {if (cols_style_ebd == TRUE) {
        cols_to_ebd(.)
      } else {
        .
      }} %>%
      suppressWarnings() # suppress parsing warnings

    # return only subset of columns
    if (!identical(cols_sel, "all")) {
      data <- data %>%
        dplyr::select(dplyr::all_of(cols_sel))
    }

    return(data)

  }

}
