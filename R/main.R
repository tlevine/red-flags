#' redflags.
#'
#' @name redflags
#' @docType package
#' @import plyr moments ggplot2 scales
NULL

#' Contracts for projects financed by the World Bank
#'
#' A dataset about contracts, with the following variables about each contract
#'
#' \itemize{
#' \item foo. bar baz
#' }
#'
#' @docType data
#' @keywords datasets
#' @name contracts
#' @usage data(contracts)
#' @format A data frame with 4340 observations of 7 variables
NULL

#' Bids on contracts for projects financed by the World Bank
#'
#' A dataset about bids on contracts, with multiple bidders per contract
#' and with the following variables about each bid
#'
#' \itemize{
#' \item foo. bar baz
#' }
#'
#' @docType data
#' @keywords datasets
#' @name bids
#' @usage data(bids)
#' @format A data frame with 14680 observations of 6 variables
NULL

#' Summarize the analysis that Tom did June/July 2014
#'
#' @export
detect <- function() {
  data(bids)
  data(contracts)

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
