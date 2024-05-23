.P3M_URL <- "https://packagemanager.posit.co/cran/"
.CRAN_URL <- "https://cloud.r-project.org"

.repositories_p3m <- function(cran, p3m_version) {
    if (is.na(p3m_version)) {
        cran
    } else {
        p3m_version <- as.Date(p3m_version, "%Y-%m-%d")
        if (is.na(p3m_version))
            stop("'P3M' date format does not match '%Y-%m-%d'")
        paste0(.P3M_URL, p3m_version)
    }
}

.repositories_cran <- function(cran) {
    if (identical(cran, c(CRAN = "@CRAN@")) || is.na(cran))
        .CRAN_URL
    else
        cran
}

.get_cran_table <- function(link, header = TRUE) {
    page <- rvest::read_html(link)
    rvest::html_table(
        page, na.strings = c("NA", "", "-"), header = header
    )[[1]]
}

.CRAN_ARCHIVE_REPOSITORY <- "https://cran.r-project.org/src/contrib/Archive"

.get_best_link <- function(pkg, last_built_date, arch_candidate, latest) {
    archive_link <-
        paste(.CRAN_ARCHIVE_REPOSITORY, pkg, arch_candidate, sep = "/")
    if (!all(latest))
        return(archive_link)
    can_link <- "https://cran.r-project.org/package="
    pkg_link <- paste0(can_link, pkg)
    table <- .get_cran_table(pkg_link, header = FALSE)
    date_pub <- table[table[[1L]] == "Published:", 2L, drop = TRUE]
    pkg_version <- table[table[[1L]] == "Version:", 2L, drop = TRUE]
    pub_latest <- lubridate::ymd(last_built_date) >=
        lubridate::ymd(date_pub)
    if (pub_latest)
        paste0(
            "https://cran.r-project.org/src/contrib/",
            pkg, "_", pkg_version, ".tar.gz"
        )
    else
        archive_link
}

#' @importFrom methods is
.resolve_archive <- function(pkg, last_built_date) {
    repo_link <- paste(.CRAN_ARCHIVE_REPOSITORY, pkg, sep = "/")
    table <-
        .get_cran_table(repo_link, header = TRUE)[, c("Name", "Last modified")]
    table <- table[stats::complete.cases(table), ]
    table <- table[order(table[['Last modified']]), ]
    latest <- lubridate::ymd(last_built_date) >=
        lubridate::ymd_hm(table$`Last modified`)
    indx <- max(which(latest))
    arch_candidate <- unlist(table[indx, "Name"])
    .get_best_link(pkg, last_built_date, arch_candidate, latest)
}

.replace_repo <-
    function(repos = getOption("repos"), version, last_date, snapshot)
{
    if (is.na(last_date))
        stop("The 'version' ", version, " archive is not supported")
    valid <- c("CRAN", "P3M")
    if (length(snapshot) != 1L || !snapshot %in% valid)
        .stop(
            "'getOption(\"BiocArchive.snapshot\")' must be one of %s",
            paste0("'", valid, "'", collapse = " ")
        )

    cran <- repos["CRAN"]
    rename <- repos == "@CRAN@" | names(repos) == "CRAN"
    repos[rename] <- switch(
        snapshot,
        P3M = .repositories_p3m(cran, last_date),
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

.replaceSlots <- function(object, ..., check = TRUE) {
    stopifnot(
        "'check' must be TRUE or FALSE" =
            is.logical(check) && length(check) == 1L && !is.na(check)
    )
    object <- .unsafe_replaceSlots(object, ...)
    if (check)
        methods::validObject(object)
    object
}

.unsafe_replaceSlots <- function(object, ...) {
    slots <- list(...)
    slot_names <- names(slots)
    for (i in seq_along(slots)) {
        slot_name <- slot_names[[i]]
        methods::slot(object, slot_name, check = FALSE) <- slots[[i]]
    }
    object
}
