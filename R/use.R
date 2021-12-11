#' Create an rclikit compliant script for your package
#' @param scriptname The name of your script
#' @param description A one-line description of your script
#' @param short use the short template. The default long template provides a broader base upon which to build your own script
#' @export
use_rclikit_script <- function(scriptname, description, short = FALSE) {
  if (!file.exists("DESCRIPTION")) {
    stop("This function should be run from the root directory of a package.")
  }

  if (!dir.exists("inst/rclikit")) {
    dir.create("inst/rclikit", recursive = TRUE)
  }

  script_path <- paste0("inst/rclikit/", scriptname, ".R")
  if (file.exists(script_path)) {
    stop("A script with the requested name already exists")
  }

  file.create(script_path)

  if (short) {
    template_file <- "/templates/script-short.template"
  } else {
    template_file <- "/templates/script-full.template"
  }

  template <- readLines(paste0(find.package(package = "rclikit"), template_file))
  template_processed <- whisker::whisker.render(
    template = template,
    data = list(
      script_name = scriptname,
      description = description
    )
  )
  cat(template_processed, file = script_path)

  Sys.chmod(script_path, mode = "0755", use_umask = FALSE)
}
