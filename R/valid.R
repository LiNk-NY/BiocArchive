#' Validate installed packages versions against archive constraints
#'
#' Check that installed packages are consistent (neither out-of-date nor too
#' new) with the verison of R and _Bioconductor_ in use.
#'
#' @details The function mainly works with the CRAN repositories location given
#'   by the `repositories()` function. There is no reliable way to verify
#'   `CRANinstall` installations other than by running the function with the
#'   `dry.run = TRUE` parameter and manually comparing versions.
#'
#' @inheritParams BiocManager::valid
#' @inheritParams install
#'
#' @return `biocValid` list object with elements `too_new` and `out_of_date`
#'   containing `data.frame`s with packages and their installed locations that
#'   are too new or out-of-date for the archived version of _Bioconductor_. When
#'   internet access is unavailable, an empty 'biocValid' list is returned. If
#'   all packages ('pkgs') are up to date, then `TRUE` is returned.
#'
#' @examples
#'
#' valid()
#'
#' @export
valid <- function(
    pkgs = utils::installed.packages(lib.loc, priority = priority),
    lib.loc = NULL, priority = "NA", type = getOption("pkgType"),
    filters = NULL,
    ...,
    checkBuilt = FALSE, site_repository = character(),
    version = BiocManager::version(), last_built = lastBuilt(version = version),
    snapshot = getOption("BiocArchive.snapshot", "RSPM")
) {
    repos <- getOption("repos")

    old_opt <- .replace_repo(
        version = version, last_date = last_built, snapshot = snapshot
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
    BiocManager::valid(
        pkgs = pkgs, lib.loc = lib.loc, priority = priority, type = type,
        filters = filters, ...,
        checkBuilt = checkBuilt, site_repository = site_repository
    )
}
