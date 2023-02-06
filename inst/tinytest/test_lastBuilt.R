# At least 30 Bioconductor releases found on website
expect_true(
    length(lastBuilt()) >= 30L
)
# Expect sequence of releases from 2.0 to 3.14
expect_true(
    all(
        c(paste0("3", ".", 14:0), paste0("2", ".", 14:0)) %in%
            names(lastBuilt())
    )
)
# lastBuilt returns a character string with a name
expect_identical(
    lastBuilt("3.14"),
    BiocBuild(version = "3.14", lastBuilt = "2022-04-13")
)
