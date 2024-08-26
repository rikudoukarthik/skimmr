# To remove get_param() objects from global environment when testing---------------------

remove_param <- function() {

  param_objects <- c("currel_month_lab", "currel_month_num", "currel_year",
                     "date_currel", "date_prevrel", "date_real",
                     "real_month_lab", "real_month_num", "real_year")

  if (all(sapply(param_objects, exists))) rm(list = param_objects, envir = .GlobalEnv)

}

# create dummy My Data  -------------------------------------------------------------

dummy_mydata <- function(nrows = 5) {

  dummy <- dplyr::tibble(
    `Submission ID` = paste0("S", sample(10000000:99999999, nrows)),
    `Common Name` = sample(india_checklist$`English Name`, replace = TRUE, size = nrows),
    # won't match
    `Scientific Name` = sample(india_checklist$`Scientific Name`, replace = TRUE, size = nrows),
    `Taxonomic Order` = sample(1:11000, replace = TRUE, size = nrows),
    Count = sample(c(1:1000, "X"), replace = TRUE, size = nrows),
    `State/Province` = sample(c("IN-KA", "IN-KL", "IN-TN", "IN-AP"), # use admin units data when ready
                              replace = TRUE, size = nrows),
    County = sample(c("Bengaluru Rural", "Palakkad", "Coimbatore", "Kurnool"),
                    replace = TRUE, size = nrows),
    `Location ID` = paste0("L", sample(100000:999999, 1)) %>% rep(nrows),
    Location = sample(c("GKVK Campus", "Random location"),
                      replace = TRUE, size = nrows),
    Latitude = runif(nrows, min = 5, max = 15),
    Longitude = runif(nrows, min = 70, max = 85),
    Date = seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day") %>%
      sample(replace = TRUE, size = nrows),
    Time = "06:00:00",
    Protocol = sample(c("eBird - Traveling Count", "Historical", "eBird - Stationary Count",
                        "eBird - Casual Observation"),
                      replace = TRUE, size = nrows),
    `Duration (Min)` = sample(c(NA, 1:1000),
                      replace = TRUE, size = nrows),
    `All Obs Reported` = sample(0:1, replace = TRUE, size = nrows),
    `Distance Traveled (km)` = sample(c(NA, 1:10),
                                      replace = TRUE, size = nrows),
    `Area Covered (ha)` = NA,
    `Number of Observers` = sample(1:50, replace = TRUE, size = nrows),
    `Breeding Code` = sample(c("A", "C", "CF", "F", "H"), replace = TRUE, size = nrows),
    `Observation Details` = sample(c(NA, "Seen", "Heard"),
                                   replace = TRUE, size = nrows),
    `Checklist Comments` = sample(c(NA, "Lovely", "No birds"),
                                  replace = TRUE, size = nrows),
    `ML Catalog Numbers` = sample(c(NA, paste0("ML", sample(10000000:99999999, 1))),
                                  replace = TRUE, size = nrows),

  )

  return(dummy)

}

# create dummy EBD ------------------------------------------------------------------

dummy_ebd <- function(nrows = 5) {

  dummy <- dummy_mydata(nrows) %>%
    cols_to_ebd()

  return(dummy)

}
