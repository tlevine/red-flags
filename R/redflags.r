#!/usr/bin/env Rscript
library(plyr)
library(ggplot2)
library(scales)


main <- function() {
  argv <- commandArgs(trailingOnly = TRUE)
  bids.csv <- if (length(argv) == 0) 'bids.csv' else argv[1]
  bids <- load.bids.csv(bids.csv)
  if (!file.exists('lowest-bidder')) {
    dir.create('lowest-bidder')
  }
  roundness <- very.round(bids)
  roundness$contract.url <- paste0('http://search.worldbank.org/wcontractawards/procdetails/', roundness$contract.number)
  write.csv(roundness, 'roundness.csv', row.names = FALSE)
  ggsave(filename = 'big/bid-patterns.png', plot = plot.bid.patterns(bids),
         width = 11, height = 8.5, units = 'in', dpi = 300)

  contracts <- ddply(bids, 'contract', is.lowest.bidder)
  write.csv(
    contracts[order(-as.numeric(contracts$n.rejected), as.numeric(contracts$n.evaluated)),][1:20,],
    'rejections.csv', row.names = FALSE)
  ggsave(filename = 'big/lowest-bidder.png', plot = plot.lowest.bidder(contracts),
         width = 11, height = 8.5, units = 'in', dpi = 300)
# d_ply(bids, 'contract', plot.contract)
}

# main()
