#!/usr/bin/env Rscript
library(plyr)
library(ggplot2)
library(scales)

plot.contract <- function(contract) {
  if (!any(is.na(contract))) {
    contract$bidder <- factor(contract$bidder, levels = contract$bidder[order(contract$amount, decreasing = FALSE)])
    contract.url <- contract[1,'contract']
    contract.number <- contract[1,'contract.number']
    p <- ggplot(contract) +
      aes(x = bidder, y = amount, label = currency, fill = status) +
      ggtitle(contract.url) + xlab('Name of bidder') +
      scale_y_continuous('Amount bid (in the labeled currency)', labels = comma) +
      theme(legend.position = 'top') +
      scale_fill_manual(values = c('#00FFFF', '#666666', '#FF0000')) +
      geom_bar(stat = 'identity') + geom_text(hjust = 0) + coord_flip()
    ggsave(filename = paste0('lowest-bidder/', contract.number, '.png'), plot = p,
           width = 11, height = 8.5, units = 'in', dpi = 100)
  }
}

is.suspicious <- function(contract) {
  if (!any(is.na(contract)) & length(levels(contract$currency) == 1)) {
    actual.order <- contract[order(contract$amount),'status']
    suspicious.order <- 1:nrow(contract)
    statuses <- table(contract$status)
    features <- c(low.bidders.rejected = all(actual.order == suspicious.order),
                  n.awarded = statuses[[1]],
                  n.evaluated = statuses[[2]],
                  n.rejected = statuses[[3]])
  } else {
    features <- c(low.bidders.rejected = FALSE,
                  n.awarded = 0,
                  n.evaluated = 0,
                  n.rejected = 0)
  }
  c(contract = contract[1,'contract'], features)
}

plot.suspiciousness <- function(contracts) {
  ggplot(contracts) +
    aes(x = n.evaluated, y = n.rejected, label = contract.number) +
    xlab('How many bids were evaluated and not awarded?') +
    ylab('How many bids were rejected?') +
    ggtitle('Evaluation and rejection of bids in World Bank contracts') +
    geom_text()
}

load.bids.csv <- function(bids.csv) {
  bids <- read.csv(bids.csv, colClasses = c('character', 'character', 'factor', 'numeric', 'character'))
  bids$contract.number <- sub('.*/', '', contract.url)
  bids$status <- factor(bids$status, levels = c('Awarded','Evaluated','Rejected'))
  bids
}

main <- function() {
  argv <- commandArgs(trailingOnly = TRUE)
  bids.csv <- if (length(argv) == 0) 'bids.csv' else argv[1]
  bids <- load.bids.csv(bids.csv)
  if (!file.exists('lowest-bidder')) {
    dir.create('lowest-bidder')
  }
  contracts <- ddply(bids, 'contract', is.suspicious)
  ggsave(filename = 'evaluation-rejection.png', plot = plot.contracts(contracts),
         width = 11, height = 8.5, units = 'in', dpi = 300)
  d_ply(bids, 'contract', plot.contract)
}

# main()
