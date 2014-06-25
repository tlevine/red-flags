#!/usr/bin/env Rscript
library(plyr)
library(ggplot2)
library(scales)

plot.contract <- function(contract) {
  if (!any(is.na(contract))) {
    contract$bidder <- factor(contract$bidder, levels = unique(contract$bidder[order(contract$amount, decreasing = FALSE)]))
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

is.lowest.bidder <- function(contract) {
  if (all(!is.na(contract))) {
    actual.order <- contract[order(contract$amount),'status']
    lowest.bidder.order <- 1:nrow(contract)
    statuses <- as.numeric(table(contract$status))
    features <- c(low.bidders.rejected = all(actual.order == lowest.bidder.order),
                  n.awarded = (statuses[1]),
                  n.evaluated = (statuses[2]),
                  n.rejected = (statuses[3]))
  } else {
    features <- c(low.bidders.rejected = FALSE,
                  n.awarded = 0,
                  n.evaluated = 0,
                  n.rejected = 0)
  }
  c(contract = contract[1,'contract'],
    contract.number = contract[1,'contract.number'],
    features)
}

plot.lowest.bidder <- function(contracts) {
  for (column in paste0('n.',c('awarded','evaluated','rejected'))) {
    contracts[,column] <- as.numeric(contracts[,column])
  }
  ggplot(contracts) +
    aes(x = n.evaluated, y = n.rejected, label = contract.number) +
    xlab('How many bids were evaluated and not awarded?') +
    ylab('How many bids were rejected?') +
    ggtitle('Evaluation and rejection of bids in World Bank contracts') +
    geom_text()
}

load.bids.csv <- function(bids.csv) {
  bids <- read.csv(bids.csv, colClasses = c('character', 'character', 'factor', 'numeric', 'character'))
  bids$contract.number <- sub('.*/', '', bids$contract)
  bids$status <- factor(bids$status, levels = c('Awarded','Evaluated','Rejected'))
  bids
}

round.numbers <- function(bids) {
  bids$is.round <- bids$amount %% 1000 == 0
  main.currency <- names(sort(table(bids$currency), decreasing = TRUE)[1])
  ddply(bids, 'contract.number', function(df) {
    c(round.bids = sum(df$is.round),
      total.bids = nrow(df),
      main.currency = main.currency)
  })
}

plot.bid.patters <- function(bids) {
  contracts <- round.numbers(bids)
  ggplot(contracts) +
    aes(x = total.bids, y = round.bids, label = contract.number) +
    xlab('Total count of bids on the contract') +
    ylab('Count of bids that are multiples of a thousand (in original currency)') +
    ggtitle('Round or unnatural numbers in bid prices') +
    geom_text()
}

very.round <- function(bids) {
  contracts <- round.numbers(bids)
  contracts <- subset(contracts, (!is.na(round.bids)) & round.bids > total.bids / 2 & total.bids > 1)
  contracts[order(contracts$round.bids, -contracts$total.bids, decreasing = TRUE),]
}

main <- function() {
  argv <- commandArgs(trailingOnly = TRUE)
  bids.csv <- if (length(argv) == 0) 'bids.csv' else argv[1]
  bids <- load.bids.csv(bids.csv)
  if (!file.exists('lowest-bidder')) {
    dir.create('lowest-bidder')
  }
  contracts <- ddply(bids, 'contract', is.lowest.bidder)
  ggsave(filename = 'big/lowest-bidder.png', plot = plot.lowest.bidder(contracts),
         width = 11, height = 8.5, units = 'in', dpi = 300)
  d_ply(bids, 'contract', plot.contract)
  ggsave(filename = 'big/bid-patterns.png', plot = plot.bid.patterns(bids),
         width = 11, height = 8.5, units = 'in', dpi = 300)
}

# main()
