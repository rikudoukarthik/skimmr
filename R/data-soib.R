#' State of India's Birds (SoIB) datasheet
#'
#' @description
#' This is the latest State of India's Birds (SoIB) datasheet at the national level. The
#' current version of the datasheet contains `r dplyr::n_distinct(soib[,1])`
#' species.
#'
#' Please cite this datasheet as:
#'
#' `r soib_citation`
#'
#' @examples
#'   soib
#'
#' @format A tibble with `r nrow(soib)` observations
#'   and `r dim(soib)[2]` variables. Please see original `.xlsx` file
#'   (Source below) for descriptions of each variable.
#'
#' @source <https://zenodo.org/records/11124589?>
#'
#' @seealso
#' The script to update the latest version of the datasheet in `skimmr`:
#'   <https://github.com/rikudoukarthik/skimmr/blob/main/data-raw/soib.R>
#'
"soib"
