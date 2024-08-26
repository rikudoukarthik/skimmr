filter_eligible <- function(data,
                            standard = "bci",
                            complete = NULL, duration = NULL, counts = NULL) {

  # if `standard` not provided, `complete` and `duration` need to be provided
  if (is.null(standard) & is.null(complete) & is.null(duration) & is.null(counts)) {
    stop("Please input at least one filtering criterion.")
  } else if (!is.null(standard) & is.null(complete) & is.null(duration) & is.null(counts)) {

    complete <- TRUE
    counts <- TRUE

    if (standard == "bci") {
      duration <- 14
    }

  } else if (!is.null(standard) & (!is.null(complete) | !is.null(duration) | !is.null(counts))) {
    standard <- NULL
    if (is.null(complete)) complete <- FALSE
    if (is.null(duration)) duration <- FALSE
    if (is.null(counts)) counts <- FALSE

    warning("Using fully custom filter (standard = NULL).")
  }


  # if certain required columns don't exist, error and ask to produce
  req_cols <- c(if (complete == TRUE) "ALL.SPECIES.REPORTED",
                if (!is.null(duration)) "DURATION.MINUTES",
                if (counts == TRUE) "SAMPLING.EVENT.IDENTIFIER",
                if (counts == TRUE) "OBSERVATION.COUNT")
  cols_pres <- req_cols %in% names(data)
  if (!all(cols_pres)) {
    stop(glue::glue("Input data doesn't have required columns! Please provide missing {req_cols[!cols_pres]} column."))
  }


  data_filt <- data %>%
    {if (complete == TRUE) {
      dplyr::filter(., .data$ALL.SPECIES.REPORTED == 1)
    } else {
      .
    }} %>%
    {if (!is.null(duration)) {
      dplyr::filter(., .data$DURATION.MINUTES >= duration)
    } else {
      .
    }} %>%
    {if (counts == TRUE) {
      dplyr::group_by(., .data$SAMPLING.EVENT.IDENTIFIER) %>%
        dplyr::filter(!any(.data$OBSERVATION.COUNT == "X")) %>%
        dplyr::ungroup()
    } else {
      .
    }}

  return(data_filt)

}

