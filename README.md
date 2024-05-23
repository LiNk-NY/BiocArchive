
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

BiocManager::install("Bioconductor/BiocArchive")
```

# Load the package

``` r
library(BiocArchive)
```

# Last release version

The `lastBuilt` helper function finds the last built date for the
supplied Bioconductor version. Other functions rely on this date to
install the appropriate packages.

``` r
lastBuilt(version = "3.14")
#>         3.14 
#> "2022-04-13"
```

# Archived installations

To install Bioconductor packages from previous releases, we strongly
recommend using Bioconductor Docker containers, where possible. Such
containers will have `BiocManager` installed. `BiocArchive` allows
versioned installations of [CRAN](https://cran.r-project.org/) packages
from either the Posit Public Package Manager (`P3M`) or the CRAN
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
#>                                              CRAN 
#> "https://packagemanager.posit.co/cran/2022-04-13"
```

``` r

install("MultiAssayExperiment", version = "3.14", dry.run = TRUE)
#>                                              CRAN 
#> "https://packagemanager.posit.co/cran/2022-04-13"
```

**Note**. The `dry.run` argument returns the `CRAN` repository location.
The default is to install `CRAN` packages from the P3M snapshot
repository.

# P3M installations

The [Posit Public Package
Manager](https://packagemanager.posit.co/client/) (`P3M`) allows
installations of packages from their respective snapshot repositories.
To enable installation from these repositories, users must either set
their `getOption("BiocArchive.snapshot")` option or the `snapshot`
argument to `P3M`. By default, the package uses `P3M` snapshots tied to
the last build date of the Bioconductor version.

``` r
install("DESeq2", version = "3.14", dry.run = TRUE, snapshot = "P3M")
#>                                              CRAN 
#> "https://packagemanager.posit.co/cran/2022-04-13"
```

``` r

install(
    "MultiAssayExperiment", version = "3.14", dry.run = TRUE, snapshot = "P3M"
)
#>                                              CRAN 
#> "https://packagemanager.posit.co/cran/2022-04-13"
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
#>         '/tmp/RtmpUQWJ6y/downloaded_packages'
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
versions with those in the `P3M` repository.

``` r
valid(version = "3.14")
```

**Note**. The R version must coincide with the Bioconductor version
sought.

# Session Information

``` r
sessionInfo()
#> R version 4.4.0 Patched (2024-04-29 r86495)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 22.04.4 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0 
#> LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
#>  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
#> [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: America/New_York
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] tinytest_1.4.1      BiocArchive_0.99.19 colorout_1.3-0.1   
#> 
#> loaded via a namespace (and not attached):
#>  [1] vctrs_0.6.5         httr_1.4.7          cli_3.6.2           knitr_1.46          rlang_1.1.3        
#>  [6] xfun_0.44           pkgload_1.3.4       generics_0.1.3      glue_1.7.0          htmltools_0.5.8.1  
#> [11] fansi_1.0.6         rmarkdown_2.27      tibble_3.2.1        evaluate_0.23       fastmap_1.2.0      
#> [16] yaml_2.3.8          lifecycle_1.0.4     memoise_2.0.1       BiocManager_1.30.23 compiler_4.4.0     
#> [21] rvest_1.0.4         codetools_0.2-20    pkgconfig_2.0.3     timechange_0.3.0    rstudioapi_0.16.0  
#> [26] digest_0.6.35       R6_2.5.1            utf8_1.2.4          pillar_1.9.0        curl_5.2.1         
#> [31] parallel_4.4.0      magrittr_2.0.3      tools_4.4.0         lubridate_1.9.3     xml2_1.3.6         
#> [36] cachem_1.1.0
```
