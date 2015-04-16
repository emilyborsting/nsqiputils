# Author: Emily A Borsting
# install.packages("plyr", repos="http://cran.r-project.org")
library("plyr")

PrepareNSQIP <- function (cpt,datadir="./data") {
  # Merges all TXT nsqip files in a directory and filters on a given CPT.
  #
  # Args:
  #   cpt: The CPT code number to filter on.
  #   datadir: Directory containing NSQIP files. Default is `./data`.
  #
  # Returns:
  #   A merged and filtered nsqip datatable by cpt.
  data <- data.frame()
  for(file in list.files(datadir, full.name=TRUE)){
    data <- join(data,subset(read.delim(file, quote=""), CPT==cpt),
                 type="full", # Do a full join
                 match="first")
  }
  return(data)
}
