#' Obtain the last build date for a particular Bioconductor version
#'
#' The function facilitates the discovery of last build dates useful for
#' selecting a fixed date to be used in conjunction with
#' `options("BiocArchive.snapshot")`. Currently, it looks at
#' <https://bioconductor.org/checkResults/> and parses the dates listed.
#'
#' @param version character(1) Indicates the Bioconductor version for which the
#'   last build date is sought. By default, 'all' versions will be returned.
#'
#' @importFrom rvest html_nodes html_text
#' @importFrom xml2 read_html xml_find_all
#'
#' @return When version is specified, a `BiocBuild` class instance for that
#'   version
#'
#' @examples
#'
#' lastBuilt(version = "3.14")
#'
#' @export
lastBuilt <- function(version = "all") {
    version <- as.character(version)
    stopifnot(
        identical(length(version), 1L), !is.na(version), is.character(version)
    )
    if (!requireNamespace("lubridate", quietly = TRUE))
        stop("Install 'lubridate' to run 'lastBuilt'")

    config <- yaml::read_yaml("https://bioconductor.org/config.yaml")
    lastdates <- config[["release_last_built_dates"]]

    if (identical(version, "all"))
        version <- names(lastdates)

    if (!all(version %in% names(lastdates)))
        stop("Bioconductor version not found")

    lastdates <- structure(
        as.character(lastdates), .Names = names(lastdates)
    )
    last_bioc_dates <- format(lubridate::mdy(lastdates), "%Y-%m-%d")
    names(last_bioc_dates) <- names(lastdates)

    last_bioc_dates[version]
}
