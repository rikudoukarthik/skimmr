#' Filter eBird data for eligible checklists
#'
#' @description
#' For various usecases, it is required to filter the eBird dataset and use only "eligible"
#' checklists. An example is the monthly eBird challenges run by various collectives across
#' the world. As such, definitions of "eligibility" tend to vary, but there are two popularly
#' used definitions which can be accessed via the `standard` argument. On the other hand,
#' it is also possible to create a custom eligibility filter, by setting `standard = NULL`
#' and providing input to the other arguments.
#'
#' @param data eBird data object
#' @param standard character; a standard eligibility criterion (default "bci", or "ebird")
#' @param complete logical; whether or not to filter for complete checklists (default NULL)
#' @param duration numerical; whether or not to filter for a specified checklist duration (>=; default NULL)
#' @param counts logical; whether or not to filter for true counts (i.e., remove lists reporting Xs; default NULL)
#'
#' @seealso Eligibility criteria for
#' [eBird monthly challenges](https://support.ebird.org/en/support/solutions/articles/48000948757-ebird-faqs#anchorEoMchallenge)
#' (standard = "ebird") and for [BCI monthly challenges](https://birdcount.in/aug24-challenge/)
#' (standard = "bci)
#' @return An updated eBird data object filtered as specified
#' @export

filter_eligible <- function(data,
                            standard = "bci",
                            complete = NULL, duration = NULL, counts = NULL) {

  # if `standard` not provided, `complete` and `duration` need to be provided
  if (is.null(standard) & is.null(complete) & is.null(duration) & is.null(counts)) {
    stop("Please input at least one filtering criterion.")
  } else if (!is.null(standard)) {

    if (!standard %in% c("bci", "ebird")) {
      stop("Input is not a standard eligibility criterion. Please specify 'bci' or 'ebird'.")
    }

    if (is.null(complete) & is.null(duration) & is.null(counts)) {

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

