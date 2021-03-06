% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/polca-tidiers.R
\name{glance.poLCA}
\alias{glance.poLCA}
\title{Augment data with information from a(n) poLCA object}
\usage{
\method{glance}{poLCA}(x, ...)
}
\arguments{
\item{x}{A \code{poLCA} object returned from \code{\link[poLCA:poLCA]{poLCA::poLCA()}}.}

\item{...}{Additional arguments. Not used. Needed to match generic
signature only. \strong{Cautionary note:} Misspelled arguments will be
absorbed in \code{...}, where they will be ignored. If the misspelled
argument has a default value, the default value will be used.
For example, if you pass \code{conf.lvel = 0.9}, all computation will
proceed using \code{conf.level = 0.95}. Additionally, if you pass
\code{newdata = my_tibble} to an \code{\link[=augment]{augment()}} method that does not
accept a \code{newdata} argument, it will use the default value for
the \code{data} argument.}
}
\value{
A one-row \link[tibble:tibble]{tibble::tibble} with columns:

\item{logLik}{the data's log-likelihood under the model}
\item{AIC}{the Akaike Information Criterion}
\item{BIC}{the Bayesian Information Criterion}
\item{g.squared}{The likelihood ratio/deviance statistic}
\item{chi.squared}{The Pearson Chi-Square goodness of fit statistic
for multiway tables}
\item{df}{Number of parameters estimated, and therefore degrees of
freedom used}
\item{df.residual}{Number of residual degrees of freedom left}
}
\description{
Augment accepts a model object and a dataset and adds
information about each observation in the dataset. Most commonly, this
includes predicted values in the \code{.fitted} column, residuals in the
\code{.resid} column, and standard errors for the fitted values in a \code{.se.fit}
column. New columns always begin with a \code{.} prefix to avoid overwriting
columns in the original dataset.

Users may pass data to augment via either the \code{data} argument or the
\code{newdata} argument. If the user passes data to the \code{data} argument,
it \strong{must} be exactly the data that was used to fit the model
object. Pass datasets to \code{newdata} to augment data that was not used
during model fitting. This still requires that all columns used to fit
the model are present.

Augment will often behavior different depending on whether \code{data} or
\code{newdata} is specified. This is because there is often information
associated with training observations (such as influences or related)
measures that is not meaningfully defined for new observations.

For convenience, many augment methods provide default \code{data} arguments,
so that \code{augment(fit)} will return the augmented training data. In these
cases augment tries to reconstruct the original data based on the model
object, with some varying degrees of success.

The augmented dataset is always returned as a \link[tibble:tibble]{tibble::tibble} with the
\strong{same number of rows} as the passed dataset. This means that the
passed data must be coercible to a tibble. At this time, tibbles do not
support matrix-columns. This means you should not specify a matrix
of covariates in a model formula during the original model fitting
process, and that \code{\link[splines:ns]{splines::ns()}}, \code{\link[stats:poly]{stats::poly()}} and
\code{\link[survival:Surv]{survival::Surv()}} objects are not supported in input data. If you
encounter errors, try explicitly passing a tibble, or fitting the original
model on data in a tibble.

We are in the process of defining behaviors for models fit with various
\link{na.action} arguments, but make no guarantees about behavior when data is
missing at this time.
}
\examples{

library(poLCA)
library(dplyr)

data(values)
f <- cbind(A, B, C, D)~1
M1 <- poLCA(f, values, nclass = 2, verbose = FALSE)

M1
tidy(M1)
augment(M1)
glance(M1)

library(ggplot2)

ggplot(tidy(M1), aes(factor(class), estimate, fill = factor(outcome))) +
  geom_bar(stat = "identity", width = 1) +
  facet_wrap(~ variable)
## Three-class model with a single covariate.

data(election)
f2a <- cbind(MORALG,CARESG,KNOWG,LEADG,DISHONG,INTELG,
             MORALB,CARESB,KNOWB,LEADB,DISHONB,INTELB)~PARTY
nes2a <- poLCA(f2a, election, nclass = 3, nrep = 5, verbose = FALSE)

td <- tidy(nes2a)
td

# show

ggplot(td, aes(outcome, estimate, color = factor(class), group = class)) +
  geom_line() +
  facet_wrap(~ variable, nrow = 2) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

au <- augment(nes2a)
au
au \%>\%
  count(.class)

# if the original data is provided, it leads to NAs in new columns
# for rows that weren't predicted
au2 <- augment(nes2a, data = election)
au2
dim(au2)

}
\seealso{
\code{\link[=glance]{glance()}}, \code{\link[poLCA:poLCA]{poLCA::poLCA()}}

Other poLCA tidiers: \code{\link{augment.poLCA}},
  \code{\link{tidy.poLCA}}
}
\concept{poLCA tidiers}
