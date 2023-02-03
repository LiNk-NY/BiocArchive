# setup
repo_short_names <- BiocArchive:::repo_short_names
.match_get_short_name <- BiocArchive:::.match_get_short_name

bioc_url <- "https://bioconductor.org"
bioc_mirror <- c(`0-Bioconductor (World-wide) [https]` = bioc_url)
result <- TRUE
version <- "3.14"

pkgtype <- .match_get_short_name("software", "url.name")
repotype <- .match_get_short_name("software", "repo.name")
pkgsFile <- "src/contrib/PACKAGES"

names(result) <-
    paste(bioc_url, "packages", version, pkgtype, pkgsFile, sep = "/")

# test BioCmirror on actual
expect_identical(
    checkBioCmirror(
        mirror = bioc_mirror, version = version, repoType = repotype
    ),
    result
)

pkgtype <- .match_get_short_name("data-experiment", "url.name")
repotype <- .match_get_short_name("data-experiment", "repo.name")
names(result) <-
    paste(bioc_url, "packages", version, pkgtype, pkgsFile, sep = "/")

# test BioCmirror on actual
expect_identical(
    checkBioCmirror(
        mirror = bioc_mirror, version = version, repoType = repotype
    ),
    result
)
