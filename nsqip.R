# Author: Emily A Borsting
# install.packages("plyr", repos="http://cran.r-project.org")
library("plyr")

NSQIPFromDir <- function (cpt,datadir="./data") {
  # Merges all TXT nsqip files in a directory and filters on a given CPT.
  #
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

# usage
full.data <- NSQIPFromDir()
#filtered.by.cpt.data<- NSQIPFromDir(cpt=420029)