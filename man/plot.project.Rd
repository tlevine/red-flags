% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/contract-splitting.R
\name{plot.project}
\alias{plot.project}
\title{Plot a histogram of prices for a project.}
\usage{
\method{plot}{project}(project, dir = "outputs/splitting/")
}
\arguments{
\item{project}{Data frame of contract-level data for one project}

\item{dir}{The directory in which to save the plot.}
}
\description{
This isn't used in the detector, but you can use it like so.
}
\details{
d_ply(contracts, 'project', plot.project)
}

