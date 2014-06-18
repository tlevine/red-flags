#!/usr/bin/env Rscript
library(plyr)
library(ggplot2)
library(scales)

plot.contract <- function(contract) {
  if (!any(is.na(contract))) {
    p <- ggplot(contract) +
      aes(x = bidder, y = amount, label = currency, fill = status) +
      ggtitle(contract[1,'contract']) + xlab('Name of bidder') +
      scale_y_continuous('Amount bid (in the labeled currency)', labels = comma) +
      theme(legend.position = 'top') +
      geom_bar(stat = 'identity') + geom_text(hjust = 0) + coord_flip()
    print(p)
  }
}

main <- function() {
  argv <- commandArgs(trailingOnly = TRUE)
  bids.csv <- if (length(argv) == 0) 'bids.csv' else argv[1]
  bids <- read.csv(bids.csv, colClasses = c('character', 'character', 'factor', 'numeric', 'factor'))
  pdf('lowest-bidder.pdf', width = 11, height = 8.5)
  d_ply(bids, 'contract', plot.contract)
  dev.off()
}

main()
