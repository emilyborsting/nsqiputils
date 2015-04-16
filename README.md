# nsqiputils

This project contains utility functions for working with the [ACS NSQIP dataset](http://site.acsnsqip.org/about/) using [R](http://www.r-project.org/).

> ***Nota bene*** American College of Surgeons National Surgical Quality Improvement Program (ACS NSQIP®) data is not included in this repository and must be acquired indepedently.

## Installation

This package depends on the plyr package.
```r
install.packages("plyr", repos="http://cran.r-project.org")
```

## Preparing the data
PUF files should be text delimited & (optionally) gziped. For example:

    ./data
    ├── ACS_NSQIP_PUF05_06.txt.gz`
    ├── ACS_NSQIP_PUF07.txt.gz
    ├── ACS_NSQIP_PUF08.txt.gz
    ├── ACS_NSQIP_PUF09.txt.gz
    ├── ACS_NSQIP_PUF10.txt.gz
    ├── ACS_NSQIP_PUF11.txt.gz
    ├── ACS_NSQIP_PUF12.txt.gz
    └── ACS_NSQIP_PUF13.txt.gz


## Author
Emily A. Borsting

