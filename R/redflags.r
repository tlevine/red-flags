#!/usr/bin/env Rscript
library(plyr)
library(ggplot2)
library(scales)

main <- function() {
  bids <- load.bids.csv()
  contracts <- load.contracts.csv()

  # Roundness
  roundness <- very.round(bids)
  write.csv(roundness, 'roundness.csv', row.names = FALSE)
  ggsave(filename = 'bid-patterns.png', plot = plot.bid.patterns(bids),
         width = 11, height = 8.5, units = 'in', dpi = 300)



  contracts <- ddply(bids, 'contract', is.lowest.bidder)
  write.csv(
    contracts[order(-as.numeric(contracts$n.rejected), as.numeric(contracts$n.evaluated)),][1:20,],
    'rejections.csv', row.names = FALSE)
  ggsave(filename = 'big/lowest-bidder.png', plot = plot.lowest.bidder(contracts),
         width = 11, height = 8.5, units = 'in', dpi = 300)
}
