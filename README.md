
# BiocArchive

`BiocArchive` is a package dedicated to preserving reproducibility with
older Bioconductor versions. It works for older Bioconductor releases,
for example version `3.14`. Note that users must have the proper `3.14`
setup to be able to install packages from the archive. This means that
users should be running R version `4.1`.

It is highly recommended that users run docker containers with the
appropriate R version installation and install the package via GitHub or
via source.

# Installation

Currently, it is available via GitHub.

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("waldronlab/BiocArchive")
```

# Last release version

The `lastBuilt` helper function finds the last built date for the
supplied Bioconductor version. Other functions rely on this date to
install the appropriate packages.

``` r
lastBuilt(version = "3.14")
#> Bioconductor version '3.14' built on 'April 13, 2022'.
```

# Archived installations

To install Bioconductor packages from previous releases, we strongly
recommend using Bioconductor Docker containers, where possible. Such
containers will have `BiocManager` installed. `BiocArchive` allows
versioned installations of [CRAN](https://cran.r-project.org/) packages
from either the RStudio Package Manager (`RSPM`) or the Microsoft R
Archive Network (`MRAN`) or the CRAN
[archive](https://cran.r-project.org/src/contrib/Archive/).

## Docker installation

To download the Docker container, one can run the docker command:

    docker pull bioconductor/bioconductor_docker:RELEASE_3_14

For more information, see the Docker for Bioconductor page:
<https://www.bioconductor.org/help/docker/>

## Bioconductor installations

Installations of Bioconductor packages are handled by `BiocManager` and
will work as normal within a legacy container or local installation.

``` r
install("DESeq2", version = "3.14", dry.run = TRUE)
#>                                                 CRAN 
#> "https://packagemanager.rstudio.com/cran/2022-04-13"

install("MultiAssayExperiment", version = "3.14", dry.run = TRUE)
#>                                                 CRAN 
#> "https://packagemanager.rstudio.com/cran/2022-04-13"
```

**Note**. The `dry.run` argument returns the `CRAN` repository location.
The default is to install `CRAN` packages from the RSPM snapshot
repository.

# RSPM and MRAN installations

The [RStudio Package
Manager](https://packagemanager.rstudio.com/client/) (`RSPM`) and the
[Microsoft R Archive Network](https://mran.microsoft.com/) (MRAN) allows
installations of packages from their respective snapshot repositories.
To enable installation from these repositories, users must either set
their `getOption("BiocArchive.snapshot")` option or the `snapshot`
argument to either `RSPM` or `MRAN`. By default, the package uses `RSPM`
snapshots tied to the last build date of the Bioconductor version.

``` r
install("DESeq2", version = "3.14", dry.run = TRUE, snapshot = "MRAN")
#>                                             CRAN 
#> "https://mran.microsoft.com/snapshot/2022-04-13"

install(
    "MultiAssayExperiment", version = "3.14", dry.run = TRUE, snapshot = "MRAN"
)
#>                                             CRAN 
#> "https://mran.microsoft.com/snapshot/2022-04-13"
```

# CRAN installations from the source archive

Packages on CRAN have a history of versions at a particular URL
location:

<https://cran.r-project.org/src/contrib/Archive>

A CRAN package from the archive can be installed (from source) using
`CRANinstall`:

``` r
CRANinstall("dplyr", "3.14", dry.run = TRUE)
#> https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.0.8.tar.gz
#> 
#> The downloaded source packages are in
#>         '/tmp/Rtmp3ZYRol/downloaded_packages'
```

The function will attempt to satisfy all dependencies from the CRAN
archive.

# Repository URLs

To see the list of active repositories based on option configurations,
use the `repositories()` function:

``` r
repositories(version = "3.14")
```

**Note**. The R version must coincide with the Bioconductor version
sought.

# Package validity

To check whether all packages are within the valid time interval of the
Bioconductor release, the `valid()` function will compare package
versions with those in either the `RSPM` or `MRAN` repository.

``` r
valid(version = "3.14")
```

**Note**. The R version must coincide with the Bioconductor version
sought.

# Session Information

``` r
sessionInfo()
#> R Under development (unstable) (2023-02-22 r83892)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Ubuntu 22.04.1 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so;  LAPACK version 3.10.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8   
#>  [6] LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: Etc/UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] BiocArchive_0.99.13 colorout_1.2-2     
#> 
#> loaded via a namespace (and not attached):
#>  [1] utf8_1.2.3          generics_0.1.3      bitops_1.0-7        xml2_1.3.3          stringi_1.7.12      digest_0.6.31       magrittr_2.0.3     
#>  [8] evaluate_0.20       timechange_0.2.0    pkgload_1.3.2       fastmap_1.1.1       rprojroot_2.0.3     processx_3.8.0      pkgbuild_1.4.0     
#> [15] sessioninfo_1.2.2   BiocAddins_0.99.18  brio_1.1.3          urlchecker_1.0.1    ps_1.7.2            promises_1.2.0.1    BiocManager_1.30.20
#> [22] httr_1.4.5          rvest_1.0.3         selectr_0.4-2       fansi_1.0.4         purrr_1.0.1         codetools_0.2-19    cli_3.6.0          
#> [29] shiny_1.7.4         rlang_1.0.6         crayon_1.5.2        ellipsis_0.3.2      remotes_2.4.2       withr_2.5.0         cachem_1.0.7       
#> [36] yaml_2.3.7          BiocBaseUtils_1.1.0 devtools_2.4.5      tools_4.3.0         memoise_2.0.1       httpuv_1.6.9        curl_5.0.0         
#> [43] vctrs_0.5.2         R6_2.5.1            mime_0.12           lifecycle_1.0.3     lubridate_1.9.2     stringr_1.5.0       fs_1.6.1           
#> [50] htmlwidgets_1.6.1   usethis_2.1.6       miniUI_0.1.1.1      pkgconfig_2.0.3     desc_1.4.2          callr_3.7.3         pillar_1.8.1       
#> [57] later_1.3.0         glue_1.6.2          profvis_0.3.7       Rcpp_1.0.10         tibble_3.1.8        xfun_0.37           rstudioapi_0.14    
#> [64] knitr_1.42          xtable_1.8-4        htmltools_0.5.4     rmarkdown_2.20      testthat_3.1.6      compiler_4.3.0      prettyunits_1.1.1  
#> [71] RCurl_1.98-1.10
```
