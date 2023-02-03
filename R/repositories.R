#' @export
repositories <- function(
    site_repository = character(),
    version = BiocManager::version(),
    snapshot = getOption("BiocArchive.snapshot", "RSPM")
) {
    repos <- getOption("repos")
    last_date <- lastBuilt(version = version)

    old_opt <- .replace_repo(
        version = version, last_date = last_date, snapshot = snapshot
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
