#' EBD parameters
#'
#' Get date parameters based on current or specified date
#'
#' @param date_real a date string
#' @param date_currel a date string
#' @param date_prevrel a date string
#' @param extra whether extra parameters are needed
#'
#' @return multiple date objects
#' @export
#'
#' @examples
#' ebird_rel_param()
#' ebird_rel_param(extra = TRUE)
#' ebird_rel_param("2023-10-01")
ebird_rel_param <- function(date_real = NULL, date_currel = NULL, date_prevrel = NULL,
                      extra = FALSE) {

  # get starting points ---------------------------------------------------------------

  today <- lubridate::today() %>% lubridate::day()
  real_samemonth_currel <- today >= 16
  # this is FALSE when running analyses in one month for data that came out previous month
  # so, all dates need to be shifted back a month

  if (is.null(date_real) & is.null(date_currel) & is.null(date_prevrel)) {

    todate <- if (real_samemonth_currel == TRUE) {
      lubridate::today()
    } else {
      lubridate::today() - months(1)
    }

    date_real <- todate %>%
      lubridate::floor_date(unit = "month")

    date_currel <- (todate - months(1)) %>%
      lubridate::floor_date(unit = "month")

    # for BCI metrics
    date_prevrel <- (todate - months(2)) %>%
      lubridate::floor_date(unit = "month")

  } else if (!is.null(date_real) & is.null(date_currel) & is.null(date_prevrel)) {

    date_real <- date_real %>%
      lubridate::as_date() %>%
      lubridate::floor_date(unit = "month")

    date_currel <- date_real - months(1)

    date_prevrel <- date_real - months(2)

  } else if (is.null(date_real) & !is.null(date_currel) & is.null(date_prevrel)) {

    date_currel <- date_currel %>%
      lubridate::as_date() %>%
      lubridate::floor_date(unit = "month")

    date_real <- date_currel + months(1)

    date_prevrel <- date_real - months(2)

  } else if (!is.null(date_real) & !is.null(date_currel) & is.null(date_prevrel)) {

    date_real <- date_real %>%
      lubridate::as_date() %>%
      lubridate::floor_date(unit = "month")

    date_currel <- date_currel %>%
      lubridate::as_date() %>%
      lubridate::floor_date(unit = "month")

    if (!(date_real - date_currel) %in% c(28, 30, 31)) {
      print("Custom real-time and EBD release dates do not differ by one month.")
    }

    date_prevrel <- date_real - months(2)

  } else if (!is.null(date_prevrel)) {

    return("Setting parameters based on date_prevrel is not allowed.")

  }

  # get associated params -------------------------------------------------------------

  real_year <- date_real %>% lubridate::year()
  real_month_num <- date_real %>% lubridate::month()
  real_month_lab <- date_real %>% lubridate::month(label = T, abbr = T)

  currel_year <- date_currel %>% lubridate::year()
  currel_month_num <- date_currel %>% lubridate::month()
  currel_month_lab <- date_currel %>% lubridate::month(label = T, abbr = T)

  if (extra == TRUE) {

    # for BCI metrics
    PrevMonthNum <- date_prevrel %>% lubridate::month()
    PrevMonthLab <- date_prevrel %>% lubridate::month(label = T, abbr = T)
    CurMonthLab <- currel_month_lab
    CurMonth <- currel_month_num
    CurYear <- currel_year
    PrevYear <- currel_year - 1
    Months <- seq((lubridate::as_date(date_real) - months(6)),
                  (lubridate::as_date(date_real) - months(1)),
                  by = "month") %>%
      lubridate::month()

  }

  # assign to environment -------------------------------------------------------------

  list("date_real" = date_real,
       "date_currel" = date_currel,
       "date_prevrel" = date_prevrel,
       "real_year" = real_year,
       "real_month_num" = real_month_num,
       "real_month_lab" = real_month_lab,
       "currel_year" = currel_year,
       "currel_month_num" = currel_month_num,
       "currel_month_lab" = currel_month_lab) %>%
    list2env(envir = .GlobalEnv)

  if (extra == TRUE) {

    # for BCI metrics
    list("PrevMonthNum" = PrevMonthNum,
         "PrevMonthLab" = PrevMonthLab,
         "CurMonthLab" = CurMonthLab,
         "CurMonth" = CurMonth,
         "CurYear" = CurYear,
         "PrevYear" = PrevYear,
         "Months" = Months) %>%
      list2env(envir = .GlobalEnv)

  }

}
