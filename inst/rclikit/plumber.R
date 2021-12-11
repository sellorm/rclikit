#!/usr/bin/env Rscript

if (is.na(Sys.getenv("R_REPO", unset = NA))){
  repo <- options()$repo
} else {
  repo <- Sys.getenv("R_REPO")
}

if (!require("argparser", quietly = TRUE)) {
  install.packages("argparser", repos = repo)
}

p <- arg_parser("Plumb a file")
p <- add_argument(p, "--file", help = "Path to a file to plumb",
                  default = "./plumber.R")
p <- add_argument(p, "--port", help = "override default random port",
                  default = sample(1024:9999, 1))
argv <- parse_args(p)

if(!file.exists(argv$file)){
  error_msg <- paste0("File not found: ", argv$file)
  stop(error_msg)
}

library(plumber)
r <- plumb(argv$file)
r$run(port=argv$port)
