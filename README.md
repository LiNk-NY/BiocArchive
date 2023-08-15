
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
from either the RStudio Package Manager (`RSPM`) or the CRAN
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

install("MultiAssayExperiment", version = "3.14", dry.run = TRUE)
#>                                              CRAN 
#> "https://packagemanager.posit.co/cran/2022-04-13"
```

**Note**. The `dry.run` argument returns the `CRAN` repository location.
The default is to install `CRAN` packages from the RSPM snapshot
repository.

# RSPM installations

The [RStudio Package
Manager](https://packagemanager.rstudio.com/client/) (`RSPM`) allows
installations of packages from their respective snapshot repositories.
To enable installation from these repositories, users must either set
their `getOption("BiocArchive.snapshot")` option or the `snapshot`
argument to `RSPM`. By default, the package uses `RSPM` snapshots tied
to the last build date of the Bioconductor version.

``` r
install("DESeq2", version = "3.14", dry.run = TRUE, snapshot = "RSPM")
#>                                              CRAN 
#> "https://packagemanager.posit.co/cran/2022-04-13"

install(
    "MultiAssayExperiment", version = "3.14", dry.run = TRUE, snapshot = "RSPM"
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
#>         '/tmp/RtmpNKrPsH/downloaded_packages'
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
versions with those in the `RSPM` repository.

``` r
valid(version = "3.14")
```

**Note**. The R version must coincide with the Bioconductor version
sought.

# Session Information

``` r
sessionInfo()
#> R version 4.3.1 (2023-06-16)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Ubuntu 22.04.2 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0 
#> LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: America/New_York
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets 
#> [6] methods   base     
#> 
#> other attached packages:
#> [1] BiocArchive_0.99.14
#> 
#> loaded via a namespace (and not attached):
#>  [1] utf8_1.2.3          generics_0.1.3     
#>  [3] bitops_1.0-7        xml2_1.3.5         
#>  [5] stringi_1.7.12      digest_0.6.33      
#>  [7] magrittr_2.0.3      evaluate_0.21      
#>  [9] timechange_0.2.0    pkgload_1.3.2.1    
#> [11] fastmap_1.1.1       rprojroot_2.0.3    
#> [13] processx_3.8.2      pkgbuild_1.4.2     
#> [15] sessioninfo_1.2.2   brio_1.1.3         
#> [17] urlchecker_1.0.1    ps_1.7.5           
#> [19] promises_1.2.1      BiocManager_1.30.22
#> [21] httr_1.4.6          rvest_1.0.3        
#> [23] fansi_1.0.4         purrr_1.0.2        
#> [25] selectr_0.4-2       codetools_0.2-19   
#> [27] cli_3.6.1           shiny_1.7.5        
#> [29] rlang_1.1.1         crayon_1.5.2       
#> [31] ellipsis_0.3.2      withr_2.5.0        
#> [33] remotes_2.4.2.1     cachem_1.0.8       
#> [35] yaml_2.3.7          devtools_2.4.5     
#> [37] tools_4.3.1         memoise_2.0.1      
#> [39] httpuv_1.6.11       curl_5.0.2         
#> [41] vctrs_0.6.3         R6_2.5.1           
#> [43] mime_0.12           lifecycle_1.0.3    
#> [45] lubridate_1.9.2     stringr_1.5.0      
#> [47] fs_1.6.3            htmlwidgets_1.6.2  
#> [49] usethis_2.2.2       miniUI_0.1.1.1     
#> [51] pkgconfig_2.0.3     desc_1.4.2         
#> [53] callr_3.7.3         pillar_1.9.0       
#> [55] later_1.3.1         glue_1.6.2         
#> [57] profvis_0.3.8       Rcpp_1.0.11        
#> [59] tibble_3.2.1        xfun_0.40          
#> [61] rstudioapi_0.15.0   knitr_1.43         
#> [63] xtable_1.8-4        htmltools_0.5.6    
#> [65] rmarkdown_2.24      testthat_3.1.10    
#> [67] compiler_4.3.1      prettyunits_1.1.1  
#> [69] RCurl_1.98-1.12
```
