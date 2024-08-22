#' Convert columns in eBird data to EBD style
#'
#' The column names in some datasets such as My Data are not ideal: they contain
#' white spaces and follow complex capitalisation. In such cases, `cols_to_ebd()`
#' can be used to standardise the column names to match the default style as in
#' `read.ebd()`, i.e., fully uppercase and with periods replacing spaces.
#'
#' @param data eBird data object
#' @param type character; "mydata" if personal My Data download
#'
#' @return An updated data frame with new column names, and some columns changed:
#'  `PROTOCOL.TYPE` and `HAS.MEDIA` (from `ML Catalog Numbers`) values converted to EBD style
#' @export

cols_to_ebd <- function(data, type = "mydata") {

  cols_df <- dplyr::tibble(CURRENT = names(data))

  if (type == "mydata") {

    cols_df <- cols_df %>%
      dplyr::mutate(NEW = dplyr::case_when(

        CURRENT == "Submission ID" ~ "SAMPLING.EVENT.IDENTIFIER",
        CURRENT == "Common Name" ~ "COMMON.NAME",
        CURRENT == "Scientific Name" ~ "SCIENTIFIC.NAME",
        CURRENT == "Taxonomic Order" ~ "TAXONOMIC.ORDER",
        CURRENT == "Count" ~ "OBSERVATION.COUNT",
        CURRENT == "State/Province" ~ "STATE.CODE",
        CURRENT == "County" ~ "COUNTY",
        CURRENT == "Location ID" ~ "LOCALITY.ID",
        CURRENT == "Location" ~ "LOCALITY",
        CURRENT == "Latitude" ~ "LATITUDE",
        CURRENT == "Longitude" ~ "LONGITUDE",
        CURRENT == "Date" ~ "OBSERVATION.DATE",
        CURRENT == "Time" ~ "TIME.OBSERVATION.STARTED",
        CURRENT == "Protocol" ~ "PROTOCOL.TYPE",
        CURRENT == "Duration (Min)" ~ "DURATION.MINUTES",
        CURRENT == "All Obs Reported" ~ "ALL.OBS.REPORTED",
        CURRENT == "Distance Traveled (km)" ~ "EFFORT.DISTANCE.KM",
        CURRENT == "Area Covered (ha)" ~ "EFFORT.AREA.HA",
        CURRENT == "Number of Observers" ~ "NUMBER.OBSERVERS",
        CURRENT == "Breeding Code" ~ "BREEDING.CODE",
        CURRENT == "Observation Details" ~ "SPECIES.COMMENTS",
        CURRENT == "Checklist Comments" ~ "TRIP.COMMENTS",
        CURRENT == "ML Catalog Numbers" ~ "HAS.MEDIA",

      ))

  }


  # update column names
  names(data) <- cols_df$NEW


  # update columns having discrepancies between EBD and My Data
  if (type == "mydata") {
    data <- data %>%
      dplyr::mutate(
        PROTOCOL.TYPE = dplyr::case_when(
          stringr::str_detect(PROTOCOL.TYPE, "Traveling") ~ "Traveling",
          stringr::str_detect(PROTOCOL.TYPE, "Stationary ") ~ "Stationary ",
          stringr::str_detect(PROTOCOL.TYPE, "Casual") ~ "Incidental",
          stringr::str_detect(PROTOCOL.TYPE, "Historical") ~ "Historical"
        ),
        HAS.MEDIA = dplyr::case_when(is.na(HAS.MEDIA) ~ 0,
                                     TRUE ~ 1)
      )
  }

  return(data)

}
