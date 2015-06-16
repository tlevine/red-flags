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
             -bids.valuechange$price.ratio)
  write.csv(bids.valuechange[o,c('contract.country', 'bidder.country', 'contract', 'price.ratio')],
            'outputs/bids-valuechange.csv', row.names = FALSE)

  # Roundness
  cols <- c('contract.country', 'contract', 'round.bids', 'total.bids')
  bids.roundness <- merge(roundness(bids)[c('contract', 'round.bids', 'total.bids')],
                          contracts[c('contract', 'contract.country')])[cols]
  o <- order(bids.roundness$contract.country == '',
             bids.roundness$contract.country,
             -(bids.roundness$round.bids/bids.roundness$total.bids))
  write.csv(bids.roundness[o,], 'outputs/bids-roundness.csv', row.names = FALSE)

  # Lowest bidder not selected
  contracts.rejections <- subset(merge(ddply(bids, 'contract.number', lowest.bidder),
                                       contracts, all.x = TRUE),
                                 n.rejected > 0)
  total.bids <- rowSums(contracts.rejections[c('n.awarded', 'n.evaluated', 'n.rejected')])
  o <- order(contracts.rejections$contract.country == '',
             contracts.rejections$contract.country,
             -contracts.rejections$n.rejected / total.bids)
  write.csv(contracts.rejections[o, c('contract.country', 'contract', 'n.evaluated', 'n.rejected')],
            'outputs/contracts-rejections.csv', row.names = FALSE)

  # Contract pricing and generally strange price distributions
  projects.prices <- strange.prices(contracts)
  projects.countries <- sqldf('select project, [contract.country] from contracts group by project')
  projects.merged <- merge(projects.prices, projects.countries, all.x = TRUE)
  o <- order(is.na(projects.merged$contract.country) | projects.merged$contract.country == '',
             projects.merged$contract.country,
             -projects.merged$kurt)
  write.csv(projects.merged[o, c('contract.country', 'project', 'ks.D', 'kurt')],
            'outputs/project-prices.csv', row.names = FALSE)
}

# ggsave(filename = 'outputs/bid-patterns.pdf', plot = plot.bid.patterns(bids),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
# ggsave(filename = 'outputs/lowest-bidder.pdf', plot = plot.lowest.bidder(contracts.rejections),
#        width = 11, height = 8.5, units = 'in', dpi = 300)
