# To remove get_param() objects from global environment when testing

remove_param <- function() {

  param_objects <- c("currel_month_lab", "currel_month_num", "currel_year",
                     "date_currel", "date_prevrel", "date_real",
                     "real_month_lab", "real_month_num", "real_year")

  if (all(sapply(param_objects, exists))) rm(list = param_objects, envir = .GlobalEnv)

}
