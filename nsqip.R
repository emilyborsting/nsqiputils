# Author: Emily A Borsting
# install.packages("plyr", repos="http://cran.r-project.org")
# install.packages("RSQLite", repos="http://cran.r-project.org")

library("plyr")
library("RSQLite")


NSQIPfromDir <- function (cpt,datadir="./data") {
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

NSQIPfromCSV <- function (cpt,file="./data/nsqip.csv.gz") {
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

ByCPTCode <- function (cpt,con) {
 # Args:
 #   cpt: The CPT code number to filter on.
 #   con: Database connection
 #
 # Returns:
 #   A filtered nsqip data frame by cpt.
 
 res <- dbSendQuery(con, sprintf("select * from NSQIP where CPT = %s",cpt))
 data <- dbFetch(res,n=-1)
 dbClearResult(res)
 return(data)
}

ByCPTCodes <- function (cpts,con) {
 # Args:
 #   cpts: A collection of CPT codes to filter on.
 #   con: Database connection
 #
 # Returns:
 #   A filtered nsqip data frame by a collection of cpt codes.
 #   Null gender, non-plastic surgery specialities are excluded. 
 qry <- sprintf("select * 
                from NSQIP 
                where SURGSPEC = 'Plastics'
                and SEX is not null
                and ( ")
 i<-0
 for (cpt in cpts){
  if(i==0){
   qry <- sprintf("%s CPT = %s",qry, cpt)
  }else{
   qry <- sprintf("%s or CPT = %s",qry, cpt)
  }
  i<-i+1
 }
 qry <- sprintf("%s )",qry, cpt)
 res <- dbSendQuery(con, qry)
 data <- dbFetch(res,n=-1)
 dbClearResult(res)
 return(data)
}

TotalPatients <- function (cont) {
 res <- dbSendQuery(con, sprintf("select count(*) from NSQIP"))
 data <- dbFetch(res,n=-1)
 dbClearResult(res)
 return(as.numeric(data))
}

TotalPatientsMale <- function (cont) {
 res <- dbSendQuery(con, sprintf("select count(*) from NSQIP where SEX = 'male'"))
 data <- dbFetch(res,n=1)
 dbClearResult(res)
 return(as.numeric(data))
}

TotalPatientsFemale <- function (cont) {
 res <- dbSendQuery(con, sprintf("select count(*) from NSQIP where SEX = 'female'"))
 data <- dbFetch(res,n=1)
 dbClearResult(res)
 return(as.numeric(data))
}

SumPRSbyCPT <- function (cont) {
 res <- dbSendQuery(con, sprintf("select CPT, PRNCPTX, count(*) as num
                                 from NSQIP
                                 where SURGSPEC = 'Plastics'
                                 group by CPT
                                 order by num"))
 data <- dbFetch(res,n=-1)
 dbClearResult(res)
 return(data)
}
# Usage
setwd("~/Dropbox/Research/nsqip-utils")

# TXT -------------------------------------
full.data.txt <- NSQIPfromDir()
#cpt.data.txt <- NSQIPfromDir(cpt=33880)

# CSV -------------------------------------
#full.data.csv <- NSQIPfromCSV()
#cpt.data.csv <- NSQIPfromCSV(cpt=33880)

# SQL -------------------------------------
#con <- dbConnect(RSQLite::SQLite(),"./data/nsqip.db")
#cpt.data.sql <- ByCPT(cpt=15610,con)
#cpt.codes <- c(15756,15757,15738)
#cpt.data.sql <- ByCPTCodes(cpts=cpt.codes,con)
#nsqip.total.patients <-TotalPatients(con)
#aggregate.cpts.by.prs<-SumPRSbyCPT(con)
#nsqip.total.patients.male <-TotalPatientsMale(con)
# nsqip.total.patients.female <-TotalPatientsFemale(con)

# Excel  -------------------------------------


#csv.file.name <- paste(aggregate.cpts.by.prs, collapse='-' )
#write.csv(aggregate.cpts.by.prs, file = sprintf("nsqip.count.by.procedure.csv",csv.file.name),row.names=FALSE, na="")