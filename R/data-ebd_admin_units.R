#' Administrative units of the Indian subcontinent
#'
#' @description
#' Names and codes of administrative units (three levels) used by eBird in their datasets
#' for the eight countries of the Indian subcontinent.
#'
#' There is often a mismatch in information on administrative units in different sources,
#' so this data can be useful for any work involving eBird data, particularly in cases
#' with low data where the downloaded dataset might not have observations from all
#' relevant units or subunits.
#'
#' This data is obtained from the API and should therefore stay up to date with each package
#' release. However, it may be outdated if changes occur before the package is updated. In
#' such cases, one can use `rebird::ebirdsubregionlist()` manually (section See Also).
#'
#' @examples
#'   ebd_admin_units
#'   # get data for only India
#'   dplyr::filter(ebd_admin_units, COUNTRY.CODE == "IN")
#'
#' @format A tibble with `r format(nrow(ebd_admin_units), big.mark = ",")` observations
#'   and `r dim(ebd_admin_units)[2]` variables (names and 2-letter ISO codes).
#'
#' @seealso
#' The script to update the data in `skimmr`:
#'   <https://github.com/rikudoukarthik/skimmr/blob/main/data-raw/ebd_admin_units.R>
#' The `rebird` package for interacting with eBird webservices: <https://docs.ropensci.org/rebird/>
#'
"ebd_admin_units"
