require(rebird)
require(dplyr)
require(stringr)
require(purrr)

# load token for rebird (API)
source("data-raw/rebird_token.R")


ind_subcont <- c("IN", "NP", "BT", "LK", "BD", "PK", "MV", "IO") # British Indian Ocean Territory

list_countries <- rebird::ebirdsubregionlist("country", key = myebirdtoken) %>%
  dplyr::filter(code %in% ind_subcont) %>%
  dplyr::rename(COUNTRY = name, COUNTRY.CODE = code)

list_states <- purrr::map_df(ind_subcont,
                             ~ rebird::ebirdsubregionlist("subnational1", ., key = myebirdtoken)) %>%
  dplyr::rename(STATE = name, STATE.CODE = code) %>%
  dplyr::mutate(COUNTRY.CODE = stringr::str_sub(STATE.CODE, 1, 2))

list_districts <- purrr::map_df(ind_subcont,
                                ~ rebird::ebirdsubregionlist("subnational2", ., key = myebirdtoken)) %>%
  dplyr::rename(COUNTY = name, COUNTY.CODE = code) %>%
  dplyr::mutate(STATE.CODE = stringr::str_sub(COUNTY.CODE, 1, 5))


ebird_admin_units <- list_districts %>%
  dplyr::left_join(list_states, by = "STATE.CODE") %>%
  dplyr::left_join(list_countries, by = "COUNTRY.CODE") %>%
  dplyr::relocate(dplyr::starts_with("COUNTRY"),
                  dplyr::starts_with("STATE"),
                  dplyr::starts_with("COUNTY")) %>%
  arrange(COUNTY.CODE)


usethis::use_data(ebird_admin_units, overwrite = TRUE)
