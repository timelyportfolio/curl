% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch.R
\name{curl_fetch_memory}
\alias{curl_fetch_memory}
\alias{curl_fetch_disk}
\alias{curl_fetch_stream}
\alias{curl_fetch_multi}
\alias{curl_fetch_echo}
\title{Fetch the contents of a URL}
\usage{
curl_fetch_memory(url, handle)

curl_fetch_disk(url, path, handle)

curl_fetch_stream(url, fun, handle)

curl_fetch_multi(
  url,
  done = NULL,
  fail = NULL,
  pool = NULL,
  data = NULL,
  handle
)

curl_fetch_echo(url, handle)
}
\arguments{
\item{url}{A character string naming the URL of a resource to be downloaded.}

\item{handle}{a curl handle object}

\item{path}{Path to save results}

\item{fun}{Callback function. Should have one argument, which will be
a raw vector.}

\item{done}{callback function for completed request. Single argument with
response data in same structure as \link{curl_fetch_memory}.}

\item{fail}{callback function called on failed request. Argument contains
error message.}

\item{pool}{a multi handle created by \link{new_pool}. Default uses a global pool.}

\item{data}{(advanced) callback function, file path, or connection object for writing
incoming data. This callback should only be used for \emph{streaming} applications,
where small pieces of incoming data get written before the request has completed. The
signature for the callback function is \code{write(data, final = FALSE)}. If set
to \code{NULL} the entire response gets buffered internally and returned by in
the \code{done} callback (which is usually what you want).}
}
\description{
Low-level bindings to write data from a URL into memory, disk or a callback
function. These are mainly intended for \code{httr}, most users will be better
off using the \code{\link{curl}} or \code{\link{curl_download}} function, or the
http specific wrappers in the \code{httr} package.
}
\details{
The curl_fetch functions automatically raise an error upon protocol problems
(network, disk, ssl) but do not implement application logic. For example for
you need to check the status code of http requests yourself in the response,
and deal with it accordingly.

Both \code{curl_fetch_memory} and \code{curl_fetch_disk} have a blocking and
non-blocking C implementation. The latter is slightly slower but allows for
interrupting the download prematurely (using e.g. CTRL+C or ESC). Interrupting
is enabled when R runs in interactive mode or when
\code{getOption("curl_interrupt") == TRUE}.

The \code{curl_fetch_multi} function is the asynchronous equivalent of
\code{curl_fetch_memory}. It wraps \code{multi_add} to schedule requests which
are executed concurrently when calling \code{multi_run}. For each successful
request the \code{done} callback is triggered with response data. For failed
requests (when \code{curl_fetch_memory} would raise an error), the \code{fail}
function is triggered with the error message.
}
