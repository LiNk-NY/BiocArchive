p3m <- "https://packagemanager.posit.co/cran"
expect_identical(
    BiocArchive:::.repositories_p3m(p3m, NA),
    p3m
)
expect_error(
    BiocArchive:::.repositories_p3m(p3m, "0000-00-00")
)
cran <- c(CRAN = "@CRAN@")
expect_identical(
    BiocArchive:::.repositories_cran(cran),
    BiocArchive:::.CRAN_URL
)
expect_identical(
    BiocArchive:::.repositories_cran(NA_character_),
    BiocArchive:::.CRAN_URL
)
expect_identical(
    BiocArchive:::.repositories_cran(BiocArchive:::.CRAN_URL),
    BiocArchive:::.CRAN_URL
)

last_date <- NA_character_
expect_error(
    BiocArchive:::.replace_repo(last_date = last_date, version = "0.00")
)

expect_error(
    .replaceSlots(check = NA_integer_)
)
