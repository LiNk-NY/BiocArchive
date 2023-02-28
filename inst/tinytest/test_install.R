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
    c(CRAN = paste0(BiocArchive:::.RSPM_URL, buildDate(last_built_date)))
)

expect_identical(
    install(version = version, dry.run = TRUE, snapshot = "MRAN"),
    c(CRAN =
        paste0(BiocArchive:::.MRAN_URL, buildDate(last_built_date)))
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

# CRANinstall

version <- "0.99"
expect_error(
    CRANinstall("ggplot2", version = version, dry.run = TRUE)
)
expect_error(
    CRANinstall("ggplot2", version = NA, dry.run = TRUE)
)

expect_message(
    CRANinstall("ggplot2", version = "3.14", dry.run = TRUE),
    "https://cran.r-project.org/.*"
)

expect_message(
    CRANinstall(
        c("ggplot2", "dplyr", "tidyr"), version = "3.14", dry.run = TRUE,
        "..."
    )
)

orig <- BiocArchive:::.sys_install_pkg

.sys_install_pkg <- function(...) {
    "ERROR: dependency 'scales' is not available."
}

.install_file_msg <- BiocArchive:::.install_file_msg

assignInNamespace(".sys_install_pkg", .sys_install_pkg, "BiocArchive")

# TODO: tinytest::expect_match not working
# see issue https://github.com/markvanderloo/tinytest/issues/117
# match pattern: ".*BiocArchive::CRANinstall.*'scales'.*"
expect_equivalent(
    paste(
        capture.output(
            .install_file_msg("./testpkg_x.y.z.tar.gz")
        ),
        collapse = ""
    ),
    "Install package dependencies with  BiocArchive::CRANinstall(c(    'scales'  ))"
)

assignInNamespace(".sys_install_pkg", orig, "BiocArchive")
