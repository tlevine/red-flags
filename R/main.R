#' Summarize the analysis that Tom did June/July 2014
#'
#' @export
detect <- function() {
  bids <- data(bids)
  contracts <- data(contracts)

  # Roundness
  roundness <- very.round(bids)
  write.csv(roundness, 'roundness.csv', row.names = FALSE)
  ggsave(filename = 'bid-patterns.pdf', plot = plot.bid.patterns(bids),
         width = 11, height = 8.5, units = 'in', dpi = 300)

  # Lowest bidder not selected
  contracts.lb <- ddply(bids, 'contract', lowest.bidder)
  write.csv(
    contracts.lb[order(-as.numeric(contracts.lb$n.rejected), as.numeric(contracts.lb$n.evaluated)),][1:20,],
    'rejections.csv', row.names = FALSE)
  ggsave(filename = 'lowest-bidder.pdf', plot = plot.lowest.bidder(contracts.lb),
         width = 11, height = 8.5, units = 'in', dpi = 300)

  # Contract pricing and generally strange price distributions
  projects.prices <- strange.prices(contracts)
  write.csv(projects.prices, 'project-prices.csv', row.names = FALSE)
  # ggsave ...
}
