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
  o <- order(bids.roundness$country == '',
             bids.roundness$country,
             -(bids.roundness$round.bids/bids.roundness$total.bids))
  write.csv(bids.roundness[o,], 'outputs/bids-roundness.csv', row.names = FALSE)

  # Lowest bidder not selected
  contracts.countries <- sqldf('select contract_number as contract, country from bids group by contract_number')
  contracts.rejections <- merge(ddply(bids, 'contract', lowest.bidder), contracts.countries, all.x = TRUE)
  o <- order(contracts.rejections$country == '',
             contracts.rejections$n.rejected / contract.rejections$n.evaluated)
  contracts.rejections <- contracts.rejections[o,]
  write.csv(contracts.rejections[c('country', 'contract', 'n.evaluated', 'n.rejected')],
            'outputs/contracts-rejections.csv', row.names = FALSE)

  # Contract pricing and generally strange price distributions
  projects.prices <- strange.prices(contracts)
  projects.countries <- sqldf('select project, country from bids group by project')
  projects.merged <- merge(projects.prices, projects.countries, all.x = TRUE)
  projects.merged <- projects[order(projects$country, -projects$kurt),]
  write.csv(projects.merged, 'outputs/project-prices.csv', row.names = FALSE)
}

# ggsave(filename = 'outputs/bid-patterns.pdf', plot = plot.bid.patterns(bids),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
# ggsave(filename = 'outputs/lowest-bidder.pdf', plot = plot.lowest.bidder(contracts.rejections),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
