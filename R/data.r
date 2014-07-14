load.contracts.csv <- function(fn = 'data/contracts.csv') {
  read.csv(fn, colClasses = c('factor','character','character','character','numeric','factor','numeric'))
}

load.bids.csv <- function(fn = 'data/bids.csv') {
  bids <- read.csv(fn, colClasses = c('character', 'character', 'factor', 'numeric', 'character'))
  bids$contract.number <- sub('.*/', '', bids$contract)
  bids$status <- factor(bids$status, levels = c('Awarded','Evaluated','Rejected'))
  bids
}
