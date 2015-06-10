#' Plot the prices of bids on a contract to check for suspicious bid-rejections.
#'
#' Make a plot in the style of Francis's conceptual drawing of the
#' different bid prices for the purpose of finding suspicious
#' rejections of low bidders.
#'
#' @param contract A data frame containing the bids for a single contract.
#' @return A ggplot2 plot, or NULL (if the contract is missing data)
#' @export
plot.contract <- function(contract) {
  if (!any(is.na(contract))) {
    contract$bidder <- factor(contract$bidder, levels = unique(contract$bidder[order(contract$opening.price.amount, decreasing = FALSE)]))
    contract.url <- contract[1,'contract']
    contract.number <- contract[1,'contract.number']
    p <- ggplot(contract) +
      aes(x = bidder, y = opening.price.amount, label = currency, fill = status) +
      ggtitle(contract.url) + xlab('Name of bidder') +
      scale_y_continuous('Amount bid (in the labeled currency)', labels = comma) +
      theme(legend.position = 'top') +
      scale_fill_manual(values = c('#00FFFF', '#666666', '#FF0000')) +
      geom_bar(stat = 'identity') + geom_text(hjust = 0) + coord_flip()
    ggsave(filename = paste0('lowest-bidder/', contract.number, '.png'), plot = p,
           width = 11, height = 8.5, units = 'in', dpi = 100)
  }
}


#' Run the lowest bidder non-selection detector
#'
#' @param contract A data frame of bids on one contract
#' @return A vector with the contract and statistics about bid selections
#' @export
lowest.bidder <- function(contract) {
  if (all(!is.na(contract))) {
    actual.order <- contract[order(contract$opening.price.amount),'status']
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

#' Draw a plot about bid selections with a focus on detection low bidder non-selection
#'
#' @param contracts A data frame of contracts
#' @return A ggplot2 plot
#' @export
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
