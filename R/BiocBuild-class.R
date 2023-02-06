setOldClass("package_version")

#' BiocBuild class for indicating Bioconductor build dates
#'
#' @slot version A `package_version` class indicating the Bioconductor
#'   version
#'
#' @slot lastBuilt The date of the Bioconductor release as a `Date` class
#'
#' @importFrom methods new
#'
#' @exportClass BiocBuild
.BiocBuild <- setClass(
   "BiocBuild", slots = c(version = "package_version", lastBuilt = "Date")
)

#' @rdname BiocBuild-class
#'
#' @inheritParams install
#'
#' @param lastBuilt `Date(1)` or `character(1)` A scalar vector indicating the
#'   date of the last Bioconductor build.
#'
#' @examples
#'
#' BB <- BiocBuild(version = "3.14", lastBuilt = "2022-04-13")
#' Date(BB)
#' version(BB)
#'
#' version(BB) <- "3.13"
#' BB
#'
#' @export
BiocBuild <-
    function(version = BiocManager::version(), lastBuilt = Sys.Date())
{
    if (!identical(length(version), 1L) || !identical(length(lastBuilt), 1L))
        stop("'version' and 'lastBuilt' must be of length 1")
    if (is.na(lastBuilt) || is.na(version))
        stop("'version' or 'lastBuilt' cannot be 'NA'")
    version <- as.package_version(version)
    built <- as.Date(lastBuilt)
    .BiocBuild(version = version, lastBuilt = built)
}

#' @describeIn BiocBuild-class The standard `show` method for `BiocBuild`
#'
#' @importFrom methods show
#'
#' @export
setMethod("show", "BiocBuild", function(object) {
    lastBuilt <- format(object@lastBuilt, "%B %d, %Y")
    version <- as.character(object@version)
    cat(
        "Bioconductor version '", version, "' built on '", lastBuilt, "'.",
        sep = ""
    )
})

#' @rdname BiocBuild-class
#' @export
setGeneric("Date", function(object) {
    standardGeneric("Date")
})

#' @describeIn BiocBuild-class Extract the `Date` from `BiocBuild` objects
#'
#' @export
setMethod("Date", "BiocBuild", function(object) {
    object@lastBuilt
})

#' @rdname BiocBuild-class
#' @export
setGeneric("version", function(object) {
    standardGeneric("version")
})

#' @describeIn BiocBuild-class Obtain the Bioconductor version from a
#'   `BiocBuild` object
#' @export
setMethod("version", "BiocBuild", function(object) {
    object@version
})

#' @rdname BiocBuild-class
#' @export
setGeneric("version<-", function(object, value) {
    standardGeneric("version<-")
})

#' @describeIn BiocBuild-class Change the Bioconductor archive version
#'
#' @export
setReplaceMethod("version", "BiocBuild", function(object, value) {
    lab <- lastBuilt(value)
    BiocBaseUtils::setSlots(
        object,
        version = lab@version,
        lastBuilt = lab@lastBuilt
    )
})
