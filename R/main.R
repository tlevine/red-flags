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
  bids.roundness <- roundness(bids)[c('country', 'contract', 'round.bids', 'total.bids')]
  o <- order(bids.roundness$country, -(bids.roundness$round.bids/bids.roundness$total.bids))
  write.csv(bids.roundness[o,], 'bids-roundness.csv', row.names = FALSE)

  # Lowest bidder not selected
  contracts.rejections <- ddply(bids, 'contract', lowest.bidder)
  write.csv(contracts.lb[c('country', 'contract', 'n.evaluated', 'n.rejected')]
            'contracts-rejections.csv', row.names = FALSE)

  # Contract pricing and generally strange price distributions
  projects.prices <- strange.prices(contracts)
  projects.prices.ksD      <- projects.prices[order(projects.prices$ks.D, decreasing = TRUE),][1:15,]
  projects.prices.kurtosis <- projects.prices[order(projects.prices$kurt, decreasing = TRUE),][1:15,]
  write.csv(projects.prices.ksD, 'project-prices-ksD.csv', row.names = FALSE)
  write.csv(projects.prices.kurtosis, 'project-prices-kurtosis.csv', row.names = FALSE)
  # ggsave ...
}

# ggsave(filename = 'bid-patterns.pdf', plot = plot.bid.patterns(bids),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
# ggsave(filename = 'lowest-bidder.pdf', plot = plot.lowest.bidder(contracts.lb),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
