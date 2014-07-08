#' Look for contract splitting, that is, repeated awards
#' below procurement thresholds, possibly to the same contractor.
#' 


splitting <- function(contracts) {
  contracts$method.procurement <- factor(sub(' ?- ?[a-zA-Z].*', '', as.character(contracts$method.procurement)))
  contracts$method.selection <- factor(sub('.*([A-Z]{3,4}).*', '\\1', as.character(contracts$method.selection)))
  contracts
}

ggplot(subset(contracts, project == 'P082604')) + aes(x = price.amount, fill = method.procurement) + facet_wrap(~ price.currency, scales = 'free') + geom_histogram() + scale_x_log10('Price', label = comma)
