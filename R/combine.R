#' The first half of each argument is the statistical unit.
#' columns <- c('contract.country', 'contract', 'suspiciousness.score')
combine.contracts <- function(contracts.valuechange, contracts.roundness,
                              contracts.rejections, projects.prices) {
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

combine.projects <- function(contracts.valuechange, contracts.roundness,
                             contracts.rejections, projects.prices) {
  df <- combine.contracts(contracts.valuechange, contracts.roundness,
                          contracts.rejections, projects.prices)

}
