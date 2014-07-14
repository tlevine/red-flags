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

  # Lowest bidder not selected
  contracts.lb <- ddply(bids, 'contract', lowest.bidder)
  write.csv(
    contracts.lb[order(-as.numeric(contracts.lb$n.rejected), as.numeric(contracts.lb$n.evaluated)),][1:20,],
    'rejections.csv', row.names = FALSE)
  ggsave(filename = 'lowest-bidder.png', plot = plot.lowest.bidder(contracts.lb),
         width = 11, height = 8.5, units = 'in', dpi = 300)

  # Contract pricing and generally strange price distributions
  projects.prices <- strange.prices(contracts)
  write.csv(projects.prices, 'project-prices.csv', row.names = FALSE)
  # ggsave ...
}
