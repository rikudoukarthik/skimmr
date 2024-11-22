# internal data objects are generated from different contexts
# but sysdata.rda needs to be written at once because it gets overwritten


# india checklist citation
india_checklist_citation <- readxl::read_xlsx("data-raw/india_checklist.xlsx", sheet = 1) %>%
  dplyr::filter(FOR == "Recommended citation for online list") %>%
  dplyr::pull(README) %>%
  # change square brackets
  stringr::str_replace_all(stringr::fixed("["), "(") %>%
  stringr::str_replace_all(stringr::fixed("]"), ")")


# soib citation
temp_web_env <- chromote::ChromoteSession$new()
temp_web_env$Page$navigate(url = "https://zenodo.org/records/11124589?")
temp_web_env$Page$loadEventFired()  # Wait for the page to load
# extract citation text
soib_citation <- temp_web_env$Runtime$evaluate(
  expression = "
    document.evaluate(
      '/html/body/main/div/div/div[1]/div/aside/div[7]/div/div/div/div[1]/div',
      document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null
    ).singleNodeValue.innerText
  "
)$result$value

# full soib datasheet (all masks merged)
soib_full <- readxl::excel_sheets("data-raw/soib.xlsx")[-1] %>% # exclude README sheet
  rlang::set_names() %>% # use sheet names as list names for reference
  purrr::map_dfr(~ readxl::read_excel("data-raw/soib.xlsx", sheet = .x) %>%
                   dplyr::mutate(sheet_name = .x))


usethis::use_data(india_checklist_citation, soib_citation, soib_full,
                  overwrite = TRUE, internal = TRUE)
