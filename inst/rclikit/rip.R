#!/usr/bin/env Rscript

if (is.na(Sys.getenv("R_REPO", unset = NA))){
  repo <- options()$repo
} else {
  repo <- Sys.getenv("R_REPO")
}

if (!require("argparser", quietly = TRUE)) {
  install.packages("argparser", repos = repo)
}


# argparser config
p <- arg_parser("rip - installs R packages")
p <- add_argument(p, "--pkgs",
                  help = "install packages",
                  nargs = Inf)
p <- add_argument(p, "--desc",
                  help = "install packages from a DESCRIPTION file",
                  flag = TRUE)
p <- add_argument(p, "--reqs",
                  help = "install packages from an Rrequirements.txt file",
                  flag = TRUE)
p <- add_argument(p, "--force",
                  help = "install packages, even if already installed",
                  flag = TRUE)
p <- add_argument(p, "--file",
                  help = "used to specify a file with -d or -r")
p <- add_argument(p, "--quiet",
                  help = "makes package installs quiter",
                  flag = TRUE)
argv <- parse_args(p)

# main installer function
check_and_install <- function(pkg_name){
  if (pkg_name %in% rownames(installed.packages()) == FALSE){
    install.packages(pkg_name, quiet = argv$quiet, repos = repo)
  } else {
    warning(pkg_name, " already installed - skipping", call. = FALSE)
  }
}


# used for -r -reqs
if (isTRUE(argv$reqs)){
  if ( is.na(argv$file) ){
    file <- "./Rrequirements.txt"
  } else {
    file <- argv$file
  }

  if (!file.exists(file)){
    stop("Specified file does not exist: ", file,
         "\nCheck the file and try again")
  }

  pkg_list <- readLines(file)
}


# used for-d -desc
if (isTRUE(argv$desc)){
  if ( is.na(argv$file) ){
    file <- "./DESCRIPTION"
  } else {
    file <- argv$file
  }

  if (!file.exists(file)){
    stop("Specified file does not exist: ", file,
         "\nCheck the file and try again")
  }

  pkg_list <- strsplit(read.dcf(file)[1, ]["Imports"], ", ")$Imports
}


# used for -p --pkgs
if (!is.na(argv$pkgs[1])){
  pkg_list <- argv$pkgs
}

# at least one pkg, then get installing...
if (exists("pkg_list")){
  if (isTRUE(argv$force)){
    install.packages(pkg_list, repos = repo)
  } else {
    lapply(pkg_list, check_and_install)
  }
  q()
}

print(p)
