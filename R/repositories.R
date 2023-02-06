#' Display Bioconductor and CRAN snapshot repositories
#'
#' `repositories()` reports the URLs from which to install _Bioconductor_ and
#' CRAN packages. There repositories are based on the data of the last build
#' of the archived Bioconductor release.
#'
#' @details
#' The CRAN repository reflects the `snapshot` arguments, which can be either
#' `RSPM`, `MRAN`, or `CRAN`. The `CRAN` option will default to the established
#' repository. For installation of archived packages on CRAN, see the
#' [CRANinstall] function.
#'
#' When binary installations are enabled via
#' `BIOCONDUCTOR_USE_CONTAINER_REPOSITORY`, the function will temporarily
#' disable binary installation of packages. Bioconductor binary repositories may
#' include CRAN packages that are not fixed to the release date.
#'
#' @seealso [CRANinstall]
#'
#' @inheritParams BiocManager::repositories
#' @inheritParams install
#'
#' @return A character vector of Bioconductor and CRAN repositories accounting
#'   for previous releases
#'
#' @examples
#' if (interactive()) {
#'     # run within the Bioconductor 3.14 Docker container
#'     repositories(version = "3.14", snapshot = "RSPM")
#' }
#'
#' @export
repositories <- function(
    site_repository = character(),
    version = BiocManager::version(),
    snapshot = getOption("BiocArchive.snapshot", "RSPM"),
    lastBuilt = lastBuilt(version = version)
) {
    repos <- getOption("repos")

    old_opt <- .replace_repo(
        version = version, last_date = lastBuilt, snapshot = snapshot
    )
    on.exit(options(old_opt))

    use_binaries <- Sys.getenv(
        "BIOCONDUCTOR_USE_CONTAINER_REPOSITORY", names = TRUE, unset = FALSE
    )
    if (!identical(use_binaries, "FALSE")) {
        Sys.setenv(
            BIOCONDUCTOR_USE_CONTAINER_REPOSITORY = FALSE
        )
        on.exit(do.call(Sys.setenv, as.list(use_binaries)), add = TRUE)
    }

    BiocManager::repositories(
        site_repository = site_repository, version = version
    )
}
