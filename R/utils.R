.RSPM_URL <- "https://packagemanager.rstudio.com/cran/"
.MRAN_URL <- "https://mran.microsoft.com/snapshot/"
.CRAN_URL <- "https://cloud.r-project.org/"

.repositories_rspm <- function(cran, rspm_version) {
    if (is.na(rspm_version)) {
        cran
    } else {
        rspm_version <- as.Date(rspm_version, "%Y-%m-%d")
        if (is.na(rspm_version))
            stop("'RSPM' date format does not match '%Y-%m-%d'")
        paste0(.RSPM_URL, rspm_version)
    }
}

.repositories_mran <- function(cran, mran_version) {
    if (is.na(mran_version)) {
        cran
    } else {
        mran_version <- as.Date(mran_version, "%Y-%m-%d")
        if (is.na(mran_version))
            stop("'MRAN' date format does not match '%Y-%m-%d'")
        paste0(.MRAN_URL, mran_version)
    }
}

.repositories_cran <- function(cran) {
    if (identical(cran, c(CRAN = "@CRAN@")) || is.na(cran))
        .CRAN_URL
    else
        cran
}

#' @importFrom methods is
.resolve_archive <- function(pkg, last_built_date) {
    if (is(last_built_date, "BiocBuild"))
        last_built_date <- Date(last_built_date)
    repo_standin <- "https://cran.r-project.org/src/contrib/Archive"
    page <- rvest::read_html(paste(repo_standin, pkg, sep = "/"))
    table <- rvest::html_table(
        page, na.strings = c("NA", "", "-"), header = TRUE
    )[[1]][, c("Name", "Last modified")]
    latest <- lubridate::ymd(last_built_date) >=
        lubridate::ymd_hm(table$`Last modified`)
    indx <- max(which(latest))
    archive <- unlist(table[indx, "Name"])
    paste(repo_standin, pkg, archive, sep = "/")
}

.replace_repo <-
    function(repos = getOption("repos"), version, last_date, snapshot)
{
    if (is(last_date, "BiocBuild"))
        last_date <- Date(last_date)
    if (is.na(last_date))
        stop("The 'version' ", version, " archive is not supported")
    valid <- c("CRAN", "MRAN", "RSPM")
    if (length(snapshot) != 1L || !snapshot %in% valid)
        .stop(
            "'getOption(\"BiocArchive.snapshot\")' must be one of %s",
            paste0("'", valid, "'", collapse = " ")
        )

    cran <- repos["CRAN"]
    rename <- repos == "@CRAN@" | names(repos) == "CRAN"
    repos[rename] <- switch(
        snapshot,
        RSPM = .repositories_rspm(cran, last_date),
        MRAN = .repositories_mran(cran, last_date),
        CRAN = .repositories_cran(cran)
    )
    options(repos = repos["CRAN"])
}

repo_short_names <- data.frame(
    repository = c("software", "data-experiment", "workflows",
        "data-annotation", "books"),
    stat.url = c("bioc", "data-experiment", "workflows",
        "data-annotation", NA_character_),
    stat.file = c("bioc", "experiment", "workflows",
        "annotation", NA_character_),
    url.name = c("bioc", "data/experiment", "workflows",
        "data/annotation", NA_character_),
    repo.name = c("BioCsoft", "BioCexp", "BioCworkflows",
        "BioCann", "BioCbooks")
)

.match_get_short_name <- function(pkgType, colName) {
    repo_short_names[match(pkgType, repo_short_names[["repository"]]), colName]
}

.msg <- function(
        fmt, ..., width = getOption("width"), indent = 0, exdent = 2, wrap. = TRUE
) {
    txt <- sprintf(fmt, ...)
    if (wrap.) {
        txt <- strwrap(sprintf(fmt, ...), width = width, indent = indent,
                       exdent = exdent)
        paste(txt, collapse = "\n")
    }
    else {
        txt
    }
}

.stop <- function(..., call. = FALSE) {
    stop(.msg(...), call. = call.)
}
