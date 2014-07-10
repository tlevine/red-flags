#' Look for contract splitting, that is, repeated awards
#' below procurement thresholds, possibly to the same contractor.
#' 
library(plyr)
library(moments)

splitting <- function(contracts) {
  contracts$method.procurement <- factor(sub(' ?- ?[a-zA-Z].*', '', as.character(contracts$method.procurement)))
  contracts$method.selection <- factor(sub('.*([A-Z]{3,4}).*', '\\1', as.character(contracts$method.selection)))
  contracts$method.procurement 

# d_ply(contracts, 'project', plot.project)
}

project.kurtosis <- function(df) {c(
  kurtosis = kurtosis(df$price.amount, na.rm = TRUE),
  n.contracts = nrow(df)
)}

price.kurtosis <- function(contracts) {
  df <- ddply(contracts, c('project', 'price.currency'), project.kurtosis)
  df <- subset(df, !is.nan(kurtosis) & project != '')
  df <- df[order(df$kurtosis, decreasing = TRUE),]
  df
}
plot.project <- function(project) {
  project.name <- project[1,'project']
  p <- ggplot(project) +
    aes(x = price.amount, fill = method.procurement) +
    facet_wrap(~ price.currency, scales = 'free') +
    geom_histogram() + scale_x_log10('Price', label = comma) +
    ggtitle(project.name)
  ggsave(filename = paste0('outputs/splitting/', project.name, '.png'), plot = p)
}

# sqldf('select project, contracts.contract, bids.amount from bids join contracts on bids.contract = contracts.contract where project = "P079344"')
# P079344<-subset(contracts, project == 'P079344' & (method.selection != '' | method.procurement != ''))

