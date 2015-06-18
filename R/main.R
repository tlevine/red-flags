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

  bids.valuechange <- merge(change.in.contract.value(bids),
                            contracts[c('contract', 'contract.country')])
  o <- order(is.na(bids.valuechange$contract.country) | bids.valuechange$contract.country == '',
             bids.valuechange$contract.country,
             -bids.valuechange$suspiciousness.score)
  columns <- c('contract.country', 'bidder.country', 'contract', 'suspiciousness.score', 'price.ratio')
  write.csv(bids.valuechange[o,columns],
            'outputs/bids-valuechange.csv', row.names = FALSE)

  # Roundness
  cols <- c('contract.country', 'contract', 'suspiciousness.score', 'round.bids', 'total.bids')
  bids.roundness <- roundness(contracts, bids)[cols]
  o <- order(bids.roundness$contract.country == '',
             bids.roundness$contract.country,
             -(bids.roundness$suspiciousness.score))
  write.csv(bids.roundness[o,], 'outputs/bids-roundness.csv', row.names = FALSE)

  # Lowest bidder not selected
  contracts.rejections <- high.rejections(bids, contracts)
  o <- order(contracts.rejections$contract.country == '',
             contracts.rejections$contract.country,
             -contracts.rejections$suspiciousness.score)
  columns <- c('contract.country', 'contract', 'suspiciousness.score', 'n.evaluated', 'n.rejected')
  write.csv(contracts.rejections[o, columns],
            'outputs/contracts-rejections.csv', row.names = FALSE)

  # Contract pricing and generally strange price distributions
  projects.prices <- strange.prices(contracts)
  projects.countries <- sqldf('select project, contract_country as "contract.country" from contracts group by project')
  projects.merged <- merge(projects.prices, projects.countries, all.x = TRUE)
  o <- order(is.na(projects.merged$contract.country) | projects.merged$contract.country == '',
             projects.merged$contract.country,
             -projects.merged$suspiciousness.score)
  columns <- c('contract.country', 'project', 'suspiciousness.score', 'ks.D', 'kurt')
  write.csv(projects.merged[o, columns],
            'outputs/project-prices.csv', row.names = FALSE)

  list(bids.valuechange, bids.roundness, contracts.rejections, projects.merged)
}

# ggsave(filename = 'outputs/bid-patterns.pdf', plot = plot.bid.patterns(bids),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
# ggsave(filename = 'outputs/lowest-bidder.pdf', plot = plot.lowest.bidder(contracts.rejections),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
