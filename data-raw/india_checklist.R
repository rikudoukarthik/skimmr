require(rvest)
require(dplyr)
require(stringr)
require(httr)
require(readxl)

# scrape Indian Birds website using rvest to obtain URL of latest version of checklist
latest_url <- rvest::read_html("https://indianbirds.in/india/") %>%
  rvest::html_nodes("a") %>%
  rvest::html_attr("href") %>%
  data.frame(URL = .) %>%
  dplyr::filter(stringr::str_detect(URL, "India-Checklist")) %>%
  dplyr::slice(1) %>%
  dplyr::pull(URL)

# store it for convenience & documentation
utils::download.file(latest_url, destfile = "data-raw/india_checklist.xlsx", mode = "wb")

# outputs for the package:
# main checklist to be available for users
# other internal (citation info for documentation) --- in internal_data.R
india_checklist <- readxl::read_xlsx("data-raw/india_checklist.xlsx", sheet = 2) %>%
  dplyr::select(-SN)

usethis::use_data(india_checklist, overwrite = TRUE)
