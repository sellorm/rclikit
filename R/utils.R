get_config_dir <- function() {
  os_conf_dir <- rappdirs::user_config_dir()
  paste0(os_conf_dir, "/rclikit/")
}

get_bin_dir <- function() {
  paste0(get_config_dir(), "bin/")
}

config_dir_exists <- function() {
  dir.exists(get_config_dir())
}

create_config_dir <- function() {
  if (!config_dir_exists()) {
    bin_dir <- paste0(get_config_dir(), "/bin")
    dir.create(bin_dir, recursive = TRUE)
  } else {
    warning("Config directory already exists!")
  }
}

stopifnot_bin_dir <- function() {
  if (!dir.exists(get_bin_dir())) {
    stop("rclikit bin directory does not exist")
  }
}

package_has_rclikit_dir <- function(package) {
  package_path <- find.package(package = package)
  rclikit_dir <- paste0(package_path, "/rclikit")
  dir.exists(rclikit_dir)
}

discover_package_scripts <- function(package) {
  package_path <- find.package(package = package)
  package_rclikit_path <- paste0(package_path, "/rclikit")
  dir(path = package_rclikit_path, full.names = TRUE)
}

discover_packages_with_scripts <- function() {
  packages <- c()
  installed_packages <- names(utils::installed.packages()[, "Package"])
  for (package in installed_packages) {
    if (package_has_rclikit_dir(package)) {
      packages <- c(package, packages)
    }
  }
  packages
}


add_rclikit_to_path <- function(shell) {
  shell_profile <- switch(shell,
    "bash" = "~/.bashrc",
    "zsh" = "~/.zshrc",
    shell
  )

  if (file.exists(shell_profile)) {
    cat(paste0("\n\n# Added for rclikit\nexport PATH=\"", get_bin_dir(), "\":${PATH}\n"),
      file = shell_profile,
      append = TRUE
    )
  }
}

identify_user_shell <- function(){
  tail(strsplit(system("echo $SHELL", intern = TRUE), "/")[[1]], 1)
}

sitrep <- function(){
  cat("Function to help diagnose system problems with rclikit")
}
