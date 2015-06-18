#' Determine whether a bid price (or any number) is "round".
#'
#' This function tries to determine whether a bid price is
#' round. A bid price is considered round if it has more trailing
#' zeroes than other digits.
#'
#' @param number The number or numbers to test for roundness
#' @return Whether the number is round
#' @export
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
  bids$is.round <- is.round(bids$opening.price.amount)
  ddply(bids, 'contract', function(df) {
    main.currency <- names(sort(table(df$opening.price.currency), decreasing = TRUE))[1]
    data.frame(round.bids = sum(df$is.round, na.rm = TRUE),
               total.bids = nrow(df),
               main.currency = main.currency)
  })
}

#' Plot round numbers in bid prices.
#'
#' Unusually round bid prices raise suspicioun of bid rigging.
#' Given a data frame of bids, this function plots the number of
#' round bids and the number of total bids for each contract.
#'
#' @param bids Data frame of bids, with the columns "currency" and "contract.number"
#' @return A ggplot plot
#' @export
plot.bid.patterns <- function(bids) {
  contracts <- round.numbers(bids)
  ggplot(contracts) +
    aes(x = total.bids, y = round.bids, label = contract.number) +
    xlab('Total count of bids on the contract') +
    ylab('Count of round bids (mostly trailing zeroes in the original currency)') +
    ggtitle('Round or unnatural numbers in bid prices') +
    geom_text()
}

#' Find suspicious roundness patterns in contracts.
#'
#' Unusually round bid prices raise suspicioun of bid rigging.
#' Given a data frame of bids, this function counts how many of
#' those bids are round. It also counts the total number of
#' bids and checks which currency is most common for the bids.
#' (That is, it calls `round.numbers`.) Then it selects contracts
#' with unusually high degrees of roundness.
#'
#' @param bids Data frame of bids, with the columns "currency" and "contract.number"
#' @return Data frame of bids containing only the bids for which bid prices were identified and containing new "round.bids" and "total.bids" columns for the counts of round bids and of total bids
#' @export
roundness <- function(contracts, bids) {
  df <- subset(round.numbers(bids),!is.na(round.bids) & total.bids > 1)
  bids.roundness <- merge(contracts, df[c('contract', 'round.bids', 'total.bids')])
  bids.roundness$suspiciousness.score <- bids.roundness$round.bids/bids.roundness$total.bids
  bids.roundness
}
