# Author: Emily A Borsting
# install.packages("plyr", repos="http://cran.r-project.org")
# install.packages("RSQLite", repos="http://cran.r-project.org")

library("plyr")
library("RSQLite")


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
  data <- dbFetch(res,n=-1)
  dbClearResult(res)
  return(data)
}

ByMultipleCPT <- function (cpts,con) {
  # Args:
  #   cpts: A collection of CPT codes to filter on.
  #   con: Database connection
  #
  # Returns:
  #   A filtered nsqip data frame by a collection of cpt codes.
  qry <- sprintf("SELECT * FROM NSQIP WHERE ")
  i<-0
  for (cpt in cpts){
    if(i==0){
      qry <- sprintf("%s CPT = %s",qry, cpt)
    }else{
      qry <- sprintf("%s OR CPT = %s",qry, cpt)
    }
    i<-i+1
  }
  res <- dbSendQuery(con, qry)
  data <- dbFetch(res,n=-1)
  dbClearResult(res)
  return(data)
}
# Usage

# TXT -------------------------------------
#full.data.txt <- NSQIPFromDir()
#cpt.data.txt <- NSQIPFromDir(cpt=33880)

# CSV -------------------------------------
#full.data.csv <- NSQIPFromCSV()
#cpt.data.csv <- NSQIPFromCSV(cpt=33880)

# SQL -------------------------------------
con <- dbConnect(RSQLite::SQLite(),"./data/nsqip.db")
#cpt.data.sql <- ByCPT(cpt=15610,con)
cpt.codes <- c(15756,15757,15738)
cpt.data.sql <- ByMultipleCPT(cpts=cpt.codes,con)
# Excel exporting
csv.file.name <- paste(cpt.codes, collapse='-' )
write.csv(cpt.data.sql, file = sprintf("nsqip.codes.%s.csv",csv.file.name),row.names=FALSE, na="")