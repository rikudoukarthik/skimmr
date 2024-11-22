require(rvest)
require(dplyr)
require(stringr)
require(httr)
require(readxl)
require(chromote) # for text on website rendered through javascript


# scrape SoIB Zenodo record using rvest to obtain URL of latest version of checklist
latest_url <- rvest::read_html("https://zenodo.org/records/11124589?") %>%
  rvest::html_nodes("a") %>%
  rvest::html_attr("href") %>%
  data.frame(URL = .) %>%
  dplyr::filter(stringr::str_detect(URL, "main.xlsx")) %>%
  dplyr::slice(1) %>%
  dplyr::pull(URL)

# store it for convenience & documentation
soib_download_path <- "data-raw/soib.xlsx"
utils::download.file(paste0("https://zenodo.org", latest_url),
                     destfile = soib_download_path, mode = "wb")

# outputs for the package:
# main checklist to be available for users
# other internal (full soib data to load using fn, citation info for documentation) --- in internal_data.R

soib <- readxl::read_xlsx(soib_download_path, sheet = 2)

usethis::use_data(soib, overwrite = TRUE)
