price.ratio <- bids$contract.price.amount / bids$evaluated.price.amount
subset(bids, price.ratio > 2)[c('contract', 'evaluated.price.raw', 'contract.price.raw')]
