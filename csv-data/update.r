load.contracts.csv <- function(fn = 'contracts.csv') {
  cl <- c('factor','character','factor', 'character','character','numeric','factor','numeric')
  read.csv(fn, colClasses = cl)
}

load.bids.csv <- function(fn = 'bids.csv') {
  bids <- read.csv(fn, colClasses = c('factor', 'factor', 'character', 'factor', 'factor',
                                      'factor', 'numeric', 'character',
                                      'factor', 'numeric', 'character',
                                      'factor', 'numeric', 'character'))
  bids$contract.number <- sub('.*/', '', bids$contract)
  bids$status <- factor(bids$status, levels = c('Awarded','Evaluated','Rejected'))
  bids
}

contracts <- load.contracts.csv()
bids <- load.bids.csv()

save(contracts, file = '../data/contracts.RData')
save(bids, file = '../data/bids.RData')
