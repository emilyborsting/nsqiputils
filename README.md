# nsqip utils

This project contains utility functions for working with the [ACS NSQIP dataset](http://site.acsnsqip.org/about/) using [R](http://www.r-project.org/).

> ***Nota bene*** American College of Surgeons National Surgical Quality Improvement Program (ACS NSQIP®) data is not included in this repository and must be acquired indepedently.

## Installation

This package depends on the plyr package.
```r
install.packages("plyr", repos="http://cran.r-project.org")
```

## Data

By default, NSQIP gives you a set of yearly, self-extracting TXT, SPSS or SAS files. While it's possible to work with the data in any format, the upfront effort to put it in a database is well woth the time investment. The following steps assume you are familiar with `unix-like` operating systems and standard `gnu-utils`.

### Step 1 : Merge (tab delimited text)
Once extracted, the TXT PUF files are tab delimited and seperated by year. To do cross-year analysis we need to merge the dataset. For the merge to properly join on all fields, ensure that each PUF's file headers are either all uppercase or lowercase. You can do that by opening each file with `vim` and typing `ggvU` saving with `esc` then `:wq.`

    NSQIPFromDir() # see nsqip.R for usage

Merging all datasets can take over an hour. Merging by CPT code takes closer to ten minutes. While workable, unless you know exactly what CPT code you want to work with there are faster ways to query and filter data.

### Step 2 : Clean (csv)
Save the previously merged data as a CSV file. It's helpful to remove `"NULL"` and `-99` as NULL values in CSV are simply represented as empty. Here's how you can do that with the gnu tool `sed`.

    sed -e 's/\"NULL\"//g' -e 's/\"NULL\"//g' nsqip.csv

The merged, cleaned, and compressed CSV is ~500MB. Filtering is still slow.

### Query (sql)
For faster querying, use a database.

    cat schema.sql | sqlite3 data/nsqip.db # create the database
    sqlite3 data/nsqip.db # open the database via the command line

Import the merged CSV file.

    sqlite> .mode csv NSQIP
    sqlite> .import data/nsqip.nulls.99.csv NSQIP

The database file is ~3.8 GB. Filtering and querying is extremely fast and makes iteration easy. Filtering by CPT code has gone from 10 minutes to less than a tenth of a second.

## Usage

See `nsqip.R` for usage.

## Author
Emily A. Borsting

