# quiets concerns of R CMD check re:
# - the .'s that appear in pipelines (https://stackoverflow.com/q/9439256/13000254)
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
