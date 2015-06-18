#' The first half of each argument is the statistical unit.
#' columns <- c('contract.country', 'contract', 'suspiciousness.score')
join.contracts <- function(contracts.valuechange,
                              contracts.roundness,
                              contracts.rejections) {
  data(contracts)
  contract.level <- list(valuechange = contracts.valuechange,
                         roundness = contracts.roundness,
                         rejections = contracts.rejections)
  
  df <- contracts[c('contract.country', 'contract', 'project')]
  for (name in names(contract.level)) {
    sub.df <- contract.level[[name]]
    sub.df[name] <- sub.df$suspiciousness.score
    df <- merge(df, sub.df[c('contract', name)])
  }
  df
}

join.projects <- function(contracts.valuechange, contracts.roundness,
                          contracts.rejections, projects.prices) {
  contract.flags <- join.contracts(contracts.valuechange,
                                   contracts.roundness,
                                   contracts.rejections)
  f <- function(df)
    sapply(df[c('valuechange', 'roundness', 'rejections')], max)
  project.flags <- ddply(contract.flags, 'project', f)
  projects.prices$price.kurtosis <- projects.prices$suspiciousness.score
  merge(projects.prices[c('contract.country', 'project', 'price.kurtosis')], project.flags)
}

model.projects <- function(projects.joined) {
  numbers <- c('valuechange', 'roundness', 'rejections', 'price.kurtosis')
  df <- subset(projects.joined[numbers], valuechange < 5 & roundness > 0)
  pca <- princomp(df, cor = TRUE)

}
