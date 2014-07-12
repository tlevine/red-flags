#' Determine whether a bid price (or any number) is "round".
#'
#' This function tries to determine whether a bid price is
#' round. A bid price is considered round if it has more trailing
#' zeroes than other digits.
#'
#' @param number The number or numbers to test for roundness
#' @return Whether the number is round
is.round <- function(n) {
  modulus <- 10^(1 + floor(log10(n))/2)
  n %% modulus == 0
}

#' Count round numbers in bid prices.
#'
#' Unusually round bid prices raise suspicioun of bid rigging.
#' Given a data frame of bids, this function counts how many of
#' those bids are round. It also counts the total number of
#' bids and checks which currency is most common for the bids.
#' The currency information is mainly helpful for debugging.
#'
#' @param bids Data frame of bids, with the columns "currency" and "contract.number"
#' @return Data frame of contracts, with the columns "round.bids", "total.bids", and "main.currency".
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
