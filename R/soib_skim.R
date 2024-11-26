#' Get State of India's Birds (SoIB) datasheet for specific mask
#'
#' @description
#'
#' Whereas `soib` is the latest State of India's Birds (SoIB) datasheet at the national level,
#' `soib_skim()` lets you obtain the SoIB datasheet for a specific subnational
#' (or national, with `mask == "India"`) mask of your choice, such as habitat masks
#' or individual states.
#'
#'
#' @param mask character; a valid mask name
#'
#' @return A tibble. Please find info on descriptions of each variable in the
#' source listed in the documentation for [soib].
#'
#' @export
#'
#' @examples
#' soib_skim("ONEs") # get SoIB data for Open Natural Ecosystems (ONEs)
soib_skim <- function(mask) {

  # error catch
  valid_masks <- unique(soib_full$SOIB.MASK)
  if (!mask %in% valid_masks) {
    stop(paste("Please select a valid mask, one of:",
               paste(valid_masks, collapse = ", "),
               sep = "\n"))
  }

  # filter soib datasheet
  soib_skimmed <- soib_full %>%
    dplyr::filter(., .data$SOIB.MASK == mask) %>%
    dplyr::select(., -.data$SOIB.MASK)

  return(soib_skimmed)

}
