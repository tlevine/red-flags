#' Look for contract splitting, that is, repeated awards
#' below procurement thresholds, possibly to the same contractor.
#' 
library(plyr)
library(moments)

#' Run the contract-splitting detector.
splitting <- function(contracts) {
  contracts$method.procurement <- factor(sub(' ?- ?[a-zA-Z].*', '', as.character(contracts$method.procurement)))
  contracts$method.selection <- factor(sub('.*([A-Z]{3,4}).*', '\\1', as.character(contracts$method.selection)))
  contracts$method.procurement 
}

#' Within a particular data frame, produce a price.standardized
#' column as the standardized price.amount column. Ignore NAs.
standardize.prices <- function(df) {
  .mean <- mean(df$price.amount, na.rm = TRUE)
  .sd <- sd(df$price.amount, na.rm = TRUE)
  df$price.standardized <- (df$price.amount - .mean) / .sd
  df
}

strange.prices <- function(contracts) {
  df <- ddply(contracts, c('project', 'price.currency'), standardize.prices)
  df <- subset(df, !is.na(price.standardized) & project != '')
  that.population <- df$price.standardized
  ddply(df, 'project', function(df) {
    this.population <- df$price.standardized
    c(D = unname(ks.test(this.population, that.population)$statistic))
  }
  df <- df[order(df$D, decreasing = TRUE),]
  df
}

#' This isn't used in the detector, but you can use it like so.
#' 
#'   d_ply(contracts, 'project', plot.project)
#'
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

