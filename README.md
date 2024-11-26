
<!-- README.md is generated from README.Rmd. Please edit that file -->

# skimmr

<!-- badges: start -->
<!-- badges: end -->

The goal of skimmr is to simplify the various data sorting, processing
and analysis tasks of Bird Count India (and others) using eBird data,
and to make these tasks more efficient and robust.

## Installation

You can install the development version of skimmr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rikudoukarthik/skimmr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(skimmr)

# get parameters useful when manipulating eBird data (e.g., EBD), like dates
ebird_rel_param() 
# saves real-time date, EBD current release date, EBD previous release date, and other associated values as objects in environment
```
