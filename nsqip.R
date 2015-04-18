# Author: Emily A Borsting
# install.packages("plyr", repos="http://cran.r-project.org")
# install.packages("RSQLite", repos="http://cran.r-project.org")

library("plyr")
library("RSQLite")
library("DBI")


NSQIPFromDir <- function (cpt,datadir="./data") {
  # Args:
  #   cpt: The CPT code number to filter on. Optional, but resulting data is huge.
  #   datadir: Directory containing NSQIP files. Default is `./data`.
  #
  # Returns:
  #   A merged and filtered nsqip datatable by cpt.
  data <- data.frame()
  for(file in list.files(datadir, full.name=TRUE)){
    if(missing(cpt)){
      data <- join(data,read.delim(file, quote=""), type="full", match="first")
    }else{
      data <- join(data,subset(read.delim(file, quote=""), CPT==cpt), type="full", match="first")
    }
  }
  return(data)
}

NSQIPFromCSV <- function (cpt,file="./data/nsqip.csv.gz") {
  # Args:
  #   cpt: The CPT code number to filter on. Optional, but resulting data is huge.
  #   file: File containing NSQIP data. Default is `./data/nsqip.csv.gz`.
  #
  # Returns:
  #   A filtered nsqip data frame by cpt.
  data <- data.frame()
  if(missing(cpt)){
    data <- join(data,read.delim(file, quote=""), type="full", match="first")
  }else{
    data <- join(data,subset(read.delim(file, quote=""), CPT==cpt), type="full", match="first")
  }
  return(data)
}

ByCPT <- function (cpt,con) {
  # Args:
  #   cpt: The CPT code number to filter on.
  #   con: Database connection
  #
  # Returns:
  #   A filtered nsqip data frame by cpt.
  res <- dbSendQuery(con, sprintf("SELECT * FROM NSQIP WHERE CPT = %s",cpt))
  data <- dbFetch(res)
  dbClearResult(res)
  return(data)
}
# usage
# TXT -------------------------------------
#full.data.txt <- NSQIPFromDir()
#cpt.data.txt <- NSQIPFromDir(cpt=420029)

# CSV -------------------------------------
#full.data.csv <- NSQIPFromCSV()
#cpt.data.csv <- NSQIPFromCSV(cpt=420029)

# SQL -------------------------------------
con <- dbConnect(RSQLite::SQLite(), "./data/nsqip.db")
cpt.data.sql <- ByCPT(cpt=33880,con)