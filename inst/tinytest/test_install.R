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
