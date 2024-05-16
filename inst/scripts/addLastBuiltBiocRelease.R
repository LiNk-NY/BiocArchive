library(BiocArchive)
library(yaml)

config <- read_yaml("~/bioc/bioconductor.org/config.yaml")
names(config)

lasts <- lastBuilt(version = "all")
lasts <- format(as.Date(lasts), "%m/%d/%Y")
release_last_built_dates <- list(release_last_built_dates = rev(as.list(lasts)))

cat(
    as.yaml(release_last_built_dates)
)

## modify config.yaml with copy and paste :/

## check read in
read_yaml("~/bioc/bioconductor.org/config.yaml")$release_last_built_dates
