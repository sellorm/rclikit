#!/usr/bin/env Rscript

## testscript - This is only a test

## Load argparser
if (!require("argparser", quietly = TRUE)) {
  install.packages("argparser", repos = repo)
  library(argparser)
}


## Set up argperser - change this around to suit your needs
p <- arg_parser("testscript - This is only a test
")
p <- add_argument(p, "--file",
                  help = "Path to a file",
                  default = "./default.R")
p <- add_argument(p, "--port",
                  help = "override default random port",
                  default = sample(1025:7999, 1))
argv <- parse_args(p)

## The main part of your script goes here
##   Use the arguments like this `argv$file` or `argv$port`