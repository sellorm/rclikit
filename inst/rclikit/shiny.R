#!/usr/bin/env Rscript
# shiny-solo

if (is.na(Sys.getenv("R_REPO", unset = NA))){
  repo <- options()$repo
} else {
  repo <- Sys.getenv("R_REPO")
}

if (!require("argparser", quietly = TRUE)) {
  install.packages("argparser", repos = repo)
}


p <- arg_parser("shinysolo.R - Starts a single shiny app")
p <- add_argument(p, "--dir",
                  help = "path containing the shiny app",
                  default = "./")
p <- add_argument(p, "--port",
                  help = "specify a port - default is random from 1024-9999",
                  default = sample(1024:9999, 1))
p <- add_argument(p, "--host",
                  help = "specify a custom host",
                  default = "127.0.0.1")
p <- add_argument(p, "--test",
                  help = "activates 'test.mode'",
                  flag = TRUE)

argv <- parse_args(p)

shiny::runApp(appDir = argv$dir,
              port = argv$port,
              host = argv$host,
              test.mode = argv$test,
              launch.browser = FALSE)
