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
    contract.level[[name]][,contract.level] <- df$suspiciousness.score
    df <- merge(df, contract.level[[name]][c('contract', 'suspiciousness.score')])
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
  merge(project.flags, projects.prices[c('project', 'suspiciousness.score')])
}
