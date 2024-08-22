require(rvest)
require(dplyr)
require(stringr)
require(httr)
require(writexl)

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
# other internal (citation info for documentation)
india_checklist <- readxl::read_xlsx("data-raw/india_checklist.xlsx", sheet = 2) %>%
  dplyr::select(-SN)

india_checklist_citation <- readxl::read_xlsx("data-raw/india_checklist.xlsx", sheet = 1) %>%
  dplyr::filter(FOR == "Recommended citation for online list") %>%
  dplyr::pull(README) %>%
  # change square brackets
  stringr::str_replace_all(stringr::fixed("["), "(") %>%
  stringr::str_replace_all(stringr::fixed("]"), ")")

usethis::use_data(india_checklist, overwrite = TRUE)
usethis::use_data(india_checklist_citation, overwrite = TRUE, internal = TRUE)
