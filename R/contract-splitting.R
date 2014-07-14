#' Look for contract splitting, that is, repeated awards
#' below procurement thresholds, possibly to the same contractor.

#' Standardize the names of the procurement and selection methods
#'
#' @param contracts a data frame with method.procurement and method.selection columns
#' @return the data frame with standardized method.procurement and method.selection columns
standardize.methods <- function(contracts) {
  contracts$method.procurement <- factor(sub(' ?- ?[a-zA-Z].*', '', as.character(contracts$method.procurement)))
  contracts$method.selection <- factor(sub('.*([A-Z]{3,4}).*', '\\1', as.character(contracts$method.selection)))
  contracts
}

#' Within a particular data frame, produce a price.standardized
#' column as the standardized price.amount column. Ignore NAs.
standardize.prices <- function(df) {
  .mean <- mean(df$price.amount, na.rm = TRUE)
  .sd <- sd(df$price.amount, na.rm = TRUE)
  df$price.standardized <- (df$price.amount - .mean) / .sd
  df
}

#' Detect strange prices
#'
#' Use Pearson kurtosis and Kolmogorov-Smirnov statistics to
#' look for unusual patterns in contract prices, by project.
#'
#' @param contracts a data frame with contract-level data
#' @return a data frame of project-level data with the newly computed statistics
strange.prices <- function(contracts) {
  df <- ddply(contracts, c('project', 'price.currency'), standardize.prices)
  df <- subset(df, !is.na(price.standardized) & project != '')
  that.population <- df$price.standardized
  ddply(df, 'project', function(df) {
    this.population <- df$price.standardized
    c(ks.D = unname(ks.test(this.population, that.population)$statistic),
      kurt = kurtosis(df$price.standardized))
  }
  df <- df[order(df$ks.D, decreasing = TRUE),]
  df
}

#' Plot a histogram of prices for a project.
#'
#' This isn't used in the detector, but you can use it like so.
#' 
#'   d_ply(contracts, 'project', plot.project)
#'
#' @param project Data frame of contract-level data for one project
#' @param dir The directory in which to save the plot.
#' @return NULL
plot.project <- function(project, dir = 'outputs/splitting/') {
  project.name <- project[1,'project']
  p <- ggplot(project) +
    aes(x = price.amount, fill = method.procurement) +
    facet_wrap(~ price.currency, scales = 'free') +
    geom_histogram() + scale_x_log10('Price', label = comma) +
    ggtitle(project.name)
  ggsave(filename = paste0(dir, project.name, '.png'), plot = p)
}
