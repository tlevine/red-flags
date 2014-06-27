load.bids.csv <- function(bids.csv) {
  bids <- read.csv(bids.csv, colClasses = c('character', 'character', 'factor', 'numeric', 'character'))
  bids$contract.number <- sub('.*/', '', bids$contract)
  bids$status <- factor(bids$status, levels = c('Awarded','Evaluated','Rejected'))
  bids
}


