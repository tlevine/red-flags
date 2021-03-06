% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/price-roundness.R
\name{plot.bid.patterns}
\alias{plot.bid.patterns}
\title{Plot round numbers in bid prices.}
\usage{
\method{plot}{bid.patterns}(bids)
}
\arguments{
\item{bids}{Data frame of bids, with the columns "currency" and "contract.number"}
}
\value{
A ggplot plot
}
\description{
Unusually round bid prices raise suspicioun of bid rigging.
Given a data frame of bids, this function plots the number of
round bids and the number of total bids for each contract.
}

