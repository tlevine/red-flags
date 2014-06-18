#!/usr/bin/env Rscript
library(plyr)
library(ggplot2)
library(scales)

plot.contract <- function(contract) {
  if (!any(is.na(contract))) {
    contract$bidder <- factor(contract$bidder, levels = contract$bidder[order(contract$amount, decreasing = TRUE)])
    contract.url <- contract[1,'contract']
    contract.number <- sub('.*/', '', contract.url)
    p <- ggplot(contract) +
      aes(x = bidder, y = amount, label = currency, fill = status) +
      ggtitle(contract.url) + xlab('Name of bidder') +
      scale_y_continuous('Amount bid (in the labeled currency)', labels = comma) +
      theme(legend.position = 'top') +
      geom_bar(stat = 'identity') + geom_text(hjust = 0) + coord_flip()
    ggsave(filename = paste0(contract.number, '.png'), plot = p)
  }
}

main <- function() {
  argv <- commandArgs(trailingOnly = TRUE)
  bids.csv <- if (length(argv) == 0) 'bids.csv' else argv[1]
  bids <- read.csv(bids.csv, colClasses = c('character', 'character', 'factor', 'numeric', 'character'))
  bids$status <- factor(bids$status, levels = c('Awarded','Evaluated','Rejected'))
  pdf('lowest-bidder.pdf', width = 11, height = 8.5)
  d_ply(bids, 'contract', plot.contract)
  dev.off()
}

# main()
