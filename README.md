# nsqip utils

This project contains utility functions for working with the [ACS NSQIP dataset](http://site.acsnsqip.org/about/) using [R](http://www.r-project.org/).

> ***N.B.*** American College of Surgeons National Surgical Quality Improvement Program (ACS NSQIP®) data is not included in this repository and must be acquired independently.

## Installation

This package depends on the following packages.
```r
install.packages("plyr", repos="http://cran.r-project.org")
install.packages("RSQLite", repos="http://cran.r-project.org")
```

## Data

ACS NSQIP® provides a set of yearly, self-extracting `TXT`, `SPSS` or `SAS` files. This project uses `TXT`. The upfront effort to use a database is worth the time investment. The following assumes familiarity with unix-like operating systems and standard `gnu-utils`.

### Step 1 : Merge (tab delimited text)
The extracted `TXT` PUF files are tab delimited and separated by year. To do cross-year analysis we need to merge the dataset. To merge, ensure that each PUF's column headers are of the same case. You can make the headers all uppercase with `vim` by typing `ggvU` then saving `:wq`.

From there, attempt the merge.
```r
NSQIPFromDir() # Merge all TXT data, unfiltered
NSQIPFromDir(cpt=33880) # Merge all TXT data, filtered by CPT code
```
Merging all datasets can take over an hour. Merging by filtered CPT code takes closer to 10 minutes. Fortunately, there are faster ways to query and filter data.

### Step 2 : Clean (csv)
Save the previously merged data as a CSV file. Remove `"NULL"` and `-99` as NULL values in CSV are simply represented by an empty field.
```sh
# replace "NULL" and -99; save the new file as nsqip.nulls.99.csv
sed -e 's/\"NULL\"//g' -e 's/-99//g' nsqip.csv > nsqip.nulls.99.csv
# compress the new CSV file with gzip
gzip nsqip.nulls.99.csv
```
The merged, cleaned, and compressed `nsqip.nulls.99.csv.gz` is ~500MB. The combined CSV is still consumable by `R` but filtering is still slow.

### Step 3 : Query (sql)
For faster querying, use a database.

Create a database with the included schema that includes indexes on commonly queried fields like CPT.
```sh
cat schema.sql | sqlite3 data/nsqip.db
```
Open the database, then import the cleaned and merged CSV file.
```sh
sqlite3 data/nsqip.db 
sqlite> .mode csv NSQIP
sqlite> .import data/nsqip.nulls.99.csv NSQIP
```
The database file is ~3.8 GB. Querying is extremely fast; filtering by CPT code has gone from 10 minutes to less than a tenth of a second.

## Usage

See [nsqip.R](https://github.com/emilyborsting/nsqiputils/blob/master/nsqip.R) for usage.

## Author
Emily A. Borsting

