setOldClass("package_version")

#' BiocBuild class for indicating Bioconductor build dates
#'
#' @slot version A `package_version` class indicating the Bioconductor
#'   version
#'
#' @slot buildDate The date of the Bioconductor release as a `Date` class
#'
#' @importFrom methods new
#'
#' @exportClass BiocBuild
.BiocBuild <- setClass(
   "BiocBuild", slots = c(version = "package_version", buildDate = "Date")
)

#' @rdname BiocBuild-class
#'
#' @inheritParams install
#'
#' @param buildDate `Date(1)` or `character(1)` A scalar vector indicating the
#'   date of the last Bioconductor build.
#'
#' @examples
#'
#' BB <- BiocBuild(version = "3.14", buildDate = "2022-04-13")
#' buildDate(BB)
#' version(BB)
#'
#' version(BB) <- "3.13"
#' BB
#'
#' @export
BiocBuild <-
    function(version = BiocManager::version(), buildDate = Sys.Date())
{
    if (!identical(length(version), 1L) || !identical(length(buildDate), 1L))
        stop("'version' and 'buildDate' must be of length 1")
    if (is.na(buildDate) || is.na(version))
        stop("'version' or 'buildDate' cannot be 'NA'")
    version <- as.package_version(version)
    built <- as.Date(buildDate)
    .BiocBuild(version = version, buildDate = built)
}

#' @describeIn BiocBuild-class The standard `show` method for `BiocBuild`
#'
#' @importFrom methods show
#'
#' @param object A `BiocBuild` instance
#'
#' @export
setMethod("show", "BiocBuild", function(object) {
    buildDate <- format(object@buildDate, "%B %d, %Y")
    version <- as.character(object@version)
    cat(
        "Bioconductor version '", version, "' built on '", buildDate, "'.",
        sep = ""
    )
})

#' @rdname BiocBuild-class
#' @export
setGeneric("buildDate", function(object) {
    standardGeneric("buildDate")
})

#' @describeIn BiocBuild-class Extract the `buildDate` date from `BiocBuild`
#'   objects
#'
#' @export
setMethod("buildDate", "BiocBuild", function(object) {
    object@buildDate
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
#' @param value `character(1)` The Bioconductor `version` desired. It is passed
#'   as input to `buildDate()`.
#'
#' @export
setReplaceMethod("version", "BiocBuild", function(object, value) {
    lab <- lastBuilt(value)
    BiocBaseUtils::setSlots(
        object,
        version = lab@version,
        buildDate = lab@buildDate
    )
})
