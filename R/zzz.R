# zzz.R
.onLoad <- function(libname, pkgname) {
    .resolve_archive <<- memoise::memoise(.resolve_archive)
}
