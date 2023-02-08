expect_error(
    BiocBuild(version = NA_character_, buildDate = Sys.Date())
)

expect_error(
    BiocBuild(version = "3.14", buildDate = NA_character_)
)

expect_error(
    BiocBuild(version = c("3.14", "3.15"), buildDate = Sys.Date())
)

expect_error(
    BiocBuild(version = "3.14", buildDate = c(Sys.Date(), "2022-04-13"))
)

expect_inherits(
    BiocBuild(version = "3.14", buildDate = Sys.Date()), "BiocBuild"
)

expect_inherits(
    BiocBuild(version = "3.16", buildDate = "2023-02-06"), "BiocBuild"
)
