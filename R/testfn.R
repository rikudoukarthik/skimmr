#' Test and answer to life
#'
#' @param x any input
#'
#' @return A character test string, and the integer 42
#' @export
#'
#' @examples
#' x <- "Nihilism"
#' testfn(x)
testfn <- function(x) {
  cat("This is a test function that also prints the answer to the life")
  print(42)
}
