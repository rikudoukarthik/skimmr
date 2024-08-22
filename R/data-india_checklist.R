#' Checklist of birds of India
#'
#' @description
#' This is the comprehensive checklist of birds of India, with its own taxonomy. The
#' current version of the checklist contains `r dplyr::n_distinct(india_checklist$Species)`
#' species.
#'
#' Please cite this online checklist as:
#'
#' `r india_checklist_citation`
#'
#' @examples
#'   india_checklist
#'
#' @format A tibble with `r format(nrow(india_checklist), big.mark = ",")` observations
#'   and `r dim(india_checklist)[2]` variables. Please see original `.xlsx` file
#'   (Source below) for descriptions of each variable.
#'
#' @source <https://indianbirds.in/india/>
#'
#' @seealso
#' The script to update the latest version of the checklist in `skimmr`:
#'   <https://github.com/rikudoukarthik/skimmr/blob/main/data-raw/india_checklist.R>
#'
"india_checklist"
