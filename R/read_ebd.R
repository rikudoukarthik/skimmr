#' EBD Input
#'
#' Reads a .txt EBD file and creates a data frame from it, with cases corresponding to
#' lines and variables to fields in the file. This function is a wrapper around
#' `utils::read.delim()`, which is considerably faster than the `readr::read_delim()` used in
#' `auk::read_ebd()`. Moreover, unlike the latter which uses snake case for column names,
#' this function uses uppercase with period separators.
#'
#' Since EBD contains several columns, which may not all be required for a given usecase,
#' `cols_sel` can be used to import only a subset of the columns. To see the list of all
#' columns names to choose from, run `read.ebd(ebd_path, cols_print_only = TRUE`.
#'
#' @param ebd_path character; the path to the downloaded EBD .txt file
#' @param cols_sel character; vector of column names to be imported from the dataset
#' @param cols_print_only logical; whether or not to only print the full set of column
#'   names
#'
#' @return A data frame
#'
#' @importFrom utils read.delim
#' @export
#'
#' @examples
#' # to see list of column names before choosing
#' test1 <- c(SAMPLING.EVENT.IDENTIFIER = "S0000001", COMMON.NAME = "Indian Peafowl")
#' tf <- tempfile()
#' writeLines(test1, tf)
#' read.ebd(tf, cols_print_only = TRUE)
#'
#' # select columns and import data
#' read.ebd(tf, cols_sel = c("SAMPLING.EVENT.IDENTIFIER", "COMMON.NAME"))
read.ebd <- function(ebd_path, cols_sel = "all", cols_print_only = FALSE) {

  cols_all <- names(utils::read.delim(ebd_path, nrows = 1,
                                      sep = "\t", header = TRUE, quote = "",
                                      stringsAsFactors = FALSE, na.strings = c("", " ", NA)))

  # if needed, first see entire list of available columns from which selection can be
  # made later

  if (cols_print_only == TRUE) {

    print(cols_all)
    return(cols_all)

  } else {

    if (identical(cols_sel, "all")) {

      data <- read.delim(ebd_path,
                         sep = "\t", header = TRUE, quote = "",
                         stringsAsFactors = FALSE, na.strings = c("", " ", NA))

    } else {

      cols_all[!(cols_all %in% cols_sel)] <- "NULL"
      cols_all[cols_all %in% cols_sel] <- NA

      data <- read.delim(ebd_path, colClasses = cols_all,
                         sep = "\t", header = TRUE, quote = "",
                         stringsAsFactors = FALSE, na.strings = c("", " ", NA))

    }

    return(data)

  }

}

# include argument where output will be list of column names from which selection can be
# made later
