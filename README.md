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
The extracted TXT PUF files are tab delimited and seperated by year. To do cross-year analysis we need to merge the dataset. To properly merge, ensure that each PUF's column headers are of the same case. You can make the headers all uppercase with `vim` by typing `ggvU` then saving `:wq`.

From there, attempt the merge.
```r
NSQIPFromDir() # Merge all TXT data, unfiltered
NSQIPFromDir(cpt=33880) # Merge all TXT data, filtered by CPT code
```
Merging all datasets can take over an hour. Merging by filtered CPT code takes closer to 10 minutes. Fortunately, there are faster ways to query and filter data.

### Step 2 : Clean (csv)
Save the previously merged data as a CSV file. It's helpful to remove `"NULL"` and `-99` as NULL values in CSV are simply represented as empty. Here's how you can do that with the gnu tool `sed`.
```sh
sed -e 's/\"NULL\"//g' -e 's/\"NULL\"//g' nsqip.csv
```
The merged, cleaned, and compressed CSV is ~500MB. Filtering is still slow.

### Step 3 : Query (sql)
For faster querying, use a database. A `schema.sql` is provided that includes indexes on commonly queried fields like CPT. 

Created the database with the included schema.
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

See `nsqip.R` for usage.

## Author
Emily A. Borsting

