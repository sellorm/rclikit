#' Setup the local user account to work with rclikit
#' @export
setup <- function() {
  if (interactive()) {
    message(paste0("Creating rclikit directory: ", get_config_dir(), "?"))
    install_permission <- utils::askYesNo("Ok to proceed?")
  } else {
    stop("Setup can only take place in an interactive session.\nPlease start R and try again.")
  }

  if (!isTRUE(install_permission)) {
    stop("User permission not obtained. Aborting.")
  }

  create_config_dir()

  if (dir.exists(get_config_dir())) {
    message("rclikit config directory is ready.")
  }
}

#' installed all discovered cli scripts
#' @param package The name of a specific package to check
#' @export
install_cli_scripts <- function(package = NULL) {
  stopifnot_bin_dir()
  if (is.null(package)) {
    installed_packages <- names(utils::installed.packages()[, "Package"])
    for (package in installed_packages) {
      if (package_has_rclikit_dir(package)) {
        discovered_scripts <- discover_package_scripts(package)
        for (script in discovered_scripts) {
          file.symlink(script, get_bin_dir())
        }
      }
    }
  } else {
    dicovered_scripts <- discover_package_scripts(package)
    for (script in discovered_scripts) {
      file.symlink(script, get_bin_dir())
    }
  }
}


#' Uninstall the rclikit script directory
#' @export
uninstall_scripts <- function() {
  unlink(get_config_dir(), recursive = TRUE)
}
