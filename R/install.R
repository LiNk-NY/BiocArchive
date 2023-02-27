#' Install packages from a previous release of Bioconductor for reproducibility
#'
#' This function allows users to install packages from a previously released
#' Bioconductor version.
#'
#' @aliases BiocArchive.snapshot BiocManager.snapshot
#'
#' @details
#'
#' CRAN packages for out-of-date _Bioconductor_ installations can be
#' installed from historical 'snapshots' consistent with the last date
#' the Bioconductor version was current. This behavior is largely dictated by
#' the actual R/Bioconductor installation, e.g., Bioconductor 3.11. For example,
#' _Bioconductor_ version 3.11 was current until October 28, 2020; CRAN packages
#' are therefore installed from a snapshot created on 2020-10-28. By default,
#' the snapshots are from 'RSPM', the [RStudio Package Manager][RSPM]. Use
#' `options(BiocArchive.snapshot = "MRAN")` to instead use the [Microsoft R
#' Archive Network][MRAN], or `options(BiocArchive.snapshot = "CRAN")` to use
#' the current CRAN repository (i.e., disabling the snapshot feature).
#'
#' [MRAN]: https://mran.microsoft.com/timemachine
#' [RSPM]: https://packagemanager.rstudio.com/client/#/repos/2/overview
#'
#' Note that the function will temporarily change the `getOption('repos')`
#' setting for `CRAN` to allow installation of CRAN packages from either the
#' [RSPM] or [MRAN] time machines. The function will also modify the
#' `BIOCONDUCTOR_USE_CONTAINER_REPOSITORY` environment variable to temporarily
#' disable binary package installations. This is due to the possibility of CRAN
#' packages in the Bioconductor binary repositories that are not fixed to a
#' certain release date. Note that `BiocArchive.snapshot` has replaced
#' `BiocManager.snapshot`.
#'
#' It may be desirable to specify different default repositories, especially
#' CRAN, for intentionally out-of-date _Bioconductor_ releases (e.g., to support
#' reproducible research). Our approach automatically provides an alteration to
#' the `repos` option , e.g., `options(repos = c(CRAN =
#' "https://mran.microsoft.com/snapshot/2020-02-08"))`.
#'
#' @inheritParams BiocManager::install
#'
#' @param version `character(1)` The desired version to reproduce. This is
#'   largely dictated by the current R / Bioconductor version installed and is
#'   indicated by `BiocManager::version` by default.
#'
#' @param snapshot `character(1)` The snapshot CRAN repository to use for
#'   reproducibility. This defaults to the value of
#'   `getOption("BiocArchive.snapshot", "RSPM")`.
#'
#' @param dry.run `logical(1)` Whether to show only the time machine repository
#'   and forgo the package installation.
#'
#' @param ... Additional parameters for the `BiocManager::install()` function
#'
#' @param last_built `named character(1)` A character scalar of the date of the
#'   Bioconductor versions last build. The name corresponds to the Bioconductor
#'   version, e.g., `c('3.14' = "2022-04-13")`. By default, the `lastBuilt()`
#'   function reports the date from the value of the `version` argument.
#'
#' @return Mostly called for the side-effects of copying and modifying the
#'   `config.yaml` and `.Renviron` files to reproduce an R / Bioconductor
#'   package environment from a previous Bioconductor release.
#'
#' @examples
#'
#' install("DESeq2", version = "3.14", snapshot = "RSPM", dry.run = TRUE)
#'
#' @export
install <- function(
        pkgs = character(),
        version = BiocManager::version(),
        snapshot = getOption("BiocArchive.snapshot", "RSPM"),
        dry.run = FALSE,
        ...,
        last_built = lastBuilt(version = version)
) {
    repos <- getOption("repos")

    old_opt <- .replace_repo(
        version = version, last_date = last_built, snapshot = snapshot
    )
    on.exit(options(old_opt))

    if (dry.run)
        return(getOption("repos"))

    use_binaries <- Sys.getenv(
        "BIOCONDUCTOR_USE_CONTAINER_REPOSITORY", names = TRUE, unset = FALSE
    )
    if (!identical(use_binaries, "FALSE")) {
        Sys.setenv(
            BIOCONDUCTOR_USE_CONTAINER_REPOSITORY = FALSE
        )
        on.exit(do.call(Sys.setenv, as.list(use_binaries)), add = TRUE)
    }
    BiocManager::install(pkgs = pkgs, version = version, ...)
}

#' Install packages from the CRAN archive
#'
#' The function looks through the CRAN archive for each package and finds the
#' package versions that are compatible with the archived Bioconductor version
#' using the release date of that Bioconductor version as reported by
#' `lastBuilt`.
#'
#' @inheritParams install
#'
#' @param pkgs `character()` A vector of package names whose versions are sought
#'   to be compatible with the archived version of Bioconductor.
#'
#' @return Mostly called for its side effect of installing the package from
#'   the CRAN archives that corresponds to the given Bioconductor version.
#'
#' @examples
#'
#' CRANinstall(c("dplyr", "ggplot2"), version = "3.14", dry.run = TRUE)
#'
#' @export
CRANinstall <- function(
    pkgs, version = BiocManager::version(), dry.run = FALSE, ...,
    last_built = lastBuilt(version = version)
) {
    dl_pkgs_dir <- file.path(tempdir(), "downloaded_packages")
    if (!dir.exists(dl_pkgs_dir))
        dir.create(dl_pkgs_dir)
    addArgs <- list(
        last_built = last_built, temp_path = dl_pkgs_dir, dry.run = dry.run,
        ...
    )
    if (dry.run)
        pkgs <- unique(c(utils::head(pkgs, 1), "...", utils::tail(pkgs, 1)))
    mapply(
        .install_one, pkg = pkgs, MoreArgs = addArgs, SIMPLIFY = FALSE
    )

    message(
        "\nThe downloaded source packages are in\n        ",
        sQuote(dl_pkgs_dir)
    )
}

## look into DESC file and get deps for installation
base_installed <- c(
    "base", "boot", "class", "cluster", "codetools", "compiler",
    "datasets", "foreign", "graphics", "grDevices", "grid", "KernSmooth",
    "lattice", "MASS", "Matrix", "methods", "mgcv", "nlme", "nnet",
    "parallel", "rpart", "spatial", "splines", "stats", "stats4",
    "survival", "tcltk", "tools", "translations", "utils"
)

.sys_install_pkg <- function(pkg_file) {
    cmd0 <- system2("which", "R", stdout = TRUE)
    suppressWarnings({
        system2(
            command = cmd0,
            args = c("CMD", "INSTALL", "-l", .libPaths()[1], shQuote(pkg_file)),
            stderr = TRUE
        )
    })
}

.install_file_msg <- function(pkg_file) {
    old_fq <- options(useFancyQuotes = FALSE)
    on.exit(options(old_fq))
    result <- .sys_install_pkg(pkg_file)
    if (any(grepl("^ERROR: dep", result))) {
        if (grepl("', '", result[1]))
            pkgs <- gsub("ERROR: dependencies (.*) are not.*", "\\1", result[1])
        else
            pkgs <- gsub("ERROR: dependency (.*) is not.*", "\\1", result[1])
        fmt <- '  BiocArchive::CRANinstall(%s)'
        fmt <- sprintf(fmt, 'c(\n    %s\n  )')
        cat(
            "\nInstall package dependencies with",
            "\n", sprintf(fmt, pkgs), "\n",
            sep = ""
        )
    }
}

.get_DESC_deps <- function(tarball, pkg, temp_path) {
    untar(tarball, files = file.path(pkg, "DESCRIPTION"), exdir = temp_path)
    deps <- read.dcf(
        file = file.path(temp_path, pkg, "DESCRIPTION"),
        fields = c("Depends", "Imports", "LinkingTo")
    )
    deps <- unlist(lapply(deps, strsplit, ",\\s+"))
    Filter(Negate(is.na), deps)
}

.install_one <- function(pkg, last_built, temp_path, dry.run, ...) {
    if (identical(pkg, "..."))
        return(message(pkg))
    arch_url <- .resolve_archive(pkg, last_built)
    if (dry.run)
        return(message(arch_url))
    pkg_arch <- basename(arch_url)
    pkg_file <- file.path(temp_path, pkg_arch)
    if (!file.exists(pkg_file))
        utils::download.file(arch_url, pkg_file)

    deps <- .get_DESC_deps(pkg_file, pkg, temp_path)
    if (length(deps)) {
        pkgs <- vapply(deps, function(s) {
            gsub("([[:alnum:]])\\s+\\(+.*$", "\\1", s)
        }, character(1L))
        to_inst <- Filter(function(x) {!x %in% c("R", base_installed)}, pkgs)
        inst_pkgs <- rownames(installed.packages())
        missing_pkg <- !to_inst %in% inst_pkgs
        if (any(missing_pkg))
            CRANinstall(to_inst[missing_pkg], dry.run = dry.run)
    }
    withCallingHandlers({
        tryCatch({
            install.packages(pkg_file, repos = NULL, type = "source")
        }, error = function(e) {
            conditionMessage(e)
        })
    }, warning = .install_file_msg(pkg_file))
}
