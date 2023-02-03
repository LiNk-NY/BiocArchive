# 'install' errors when version not supported
version <- "0.99"
expect_error(
    install(version = version)
)

# 'install' errors when snapshot is wrong
version <- "3.14"
expect_error(
    install(version = version, snapshot = "NULL")
)
expect_error(
    install(version = version, snapshot = c("RSPM", "MRAN"))
)

# check URLs with dry.run for version 3.14
last_built_date <- lastBuilt(version = version)

expect_identical(
    install(version = version, dry.run = TRUE, snapshot = "RSPM"),
    c(CRAN = paste0(BiocArchive:::.RSPM_URL, last_built_date))
)

expect_identical(
    install(version = version, dry.run = TRUE, snapshot = "MRAN"),
    c(CRAN =
        paste0(BiocArchive:::.MRAN_URL, last_built_date))
)

expect_identical(
    install(version = version, dry.run = TRUE, snapshot = "CRAN"),
    c(CRAN = BiocArchive:::.CRAN_URL)
)

expect_identical(
    BiocArchive:::.resolve_archive("dplyr", last_built_date),
    "https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.0.8.tar.gz"
)
expect_identical(
    BiocArchive:::.resolve_archive("rvest", last_built_date),
    "https://cran.r-project.org/src/contrib/Archive/rvest/rvest_1.0.2.tar.gz"
)
