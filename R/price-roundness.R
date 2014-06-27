is.round <- function(amounts) {
  modulus <- 10^(1 + floor(log10(amounts))/2)
  amounts %% modulus == 0
}

round.numbers <- function(bids) {
  bids$is.round <- is.round(bids$amount)
  ddply(bids, 'contract.number', function(df) {
    main.currency <- names(sort(table(df$currency), decreasing = TRUE))[1]
    data.frame(round.bids = sum(df$is.round, na.rm = TRUE),
               total.bids = nrow(df),
               main.currency = main.currency)
  })
}

plot.bid.patterns <- function(bids) {
  contracts <- round.numbers(bids)
  ggplot(contracts) +
    aes(x = total.bids, y = round.bids, label = contract.number) +
    xlab('Total count of bids on the contract') +
    ylab('Count of round bids (mostly trailing zeroes in the original currency)') +
    ggtitle('Round or unnatural numbers in bid prices') +
    geom_text()
}

very.round <- function(bids) {
  contracts <- round.numbers(bids)
  contracts <- subset(contracts, (!is.na(round.bids)) & round.bids > total.bids / 2 & total.bids > 1)
  contracts[order(contracts$round.bids, -contracts$total.bids, decreasing = TRUE),]
}
