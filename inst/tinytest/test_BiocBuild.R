expect_error(
    BiocBuild(version = NA_character_, lastBuilt = Sys.Date())
)

expect_error(
    BiocBuild(version = "3.14", lastBuilt = NA_character_)
)

expect_error(
    BiocBuild(version = c("3.14", "3.15"), lastBuilt = Sys.Date())
)

expect_error(
    BiocBuild(version = "3.14", lastBuilt = c(Sys.Date(), "2022-04-13"))
)

expect_inherits(
    BiocBuild(version = "3.14", lastBuilt = Sys.Date()), "BiocBuild"
)

expect_inherits(
    BiocBuild(version = "3.16", lastBuilt = "2023-02-06"), "BiocBuild"
)
