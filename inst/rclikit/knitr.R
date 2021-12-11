#!/usr/bin/env Rscript

if (!require("argparser", quietly = TRUE)) {
  install.packages("argparser", repos = repo)
}

p <- arg_parser("knit a file")
p <- add_argument(p, "file", help = "Path to a file to knit")

argv <- parse_args(p)

if(!file.exists(argv$file)){
  error_msg <- paste0("File not found: ", argv$file)
  stop(error_msg)
}

if (!require("rmarkdown", quietly = TRUE)) {
  install.packages("rmarkdown", repos = repo)
}

rmarkdown::render(argv$file)
