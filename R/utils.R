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
