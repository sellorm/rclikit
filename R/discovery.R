#' discover available cli scripts
#' @param package The name of a specific package to check
#' @export
discover_cli_scripts <- function(package = NULL) {
  if (is.null(package)) {
    installed_packages <- names(utils::installed.packages()[, "Package"])
    for (package in installed_packages) {
      if (package_has_rclikit_dir(package)) {
        discovered_scripts <- discover_package_scripts(package)
      }
    }
  } else {
    dicovered_scripts <- discover_package_scripts(package)
  }
  discovered_scripts
}
