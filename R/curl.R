#' Curl connection interface
#'
#' Drop-in replacement for base \code{\link{url}} that supports https, ftps,
#' gzip, deflate, etc. Default behavior is identical to \code{\link{url}}, but
#' request can be fully configured by passing a custom \code{\link{handle}}.
#'
#' As of version 2.3 curl connections support \code{open(con, blocking = FALSE)}.
#' In this case \code{readBin} and \code{readLines} will return immediately with data
#' that is available without waiting. For such non-blocking connections the caller
#' needs to call \code{\link{isIncomplete}} to check if the download has completed
#' yet.
#'
#'
#' @export
#' @param url character string. See examples.
#' @param open character string. How to open the connection if it should be opened
#'   initially. Currently only "r" and "rb" are supported.
#' @param handle a curl handle object

curl <- function(url = "https://hb.cran.dev/get", open = "", handle){
  curl_connection(url, open, handle)
}

# 'stream' currently only used for non-blocking connections to prevent
# busy looping in curl_fetch_stream()
curl_connection <- function(url, mode, handle, partial = FALSE){
#
  if(!identical(mode, "")){
    withCallingHandlers(open(con, open = mode), error = function(err) {
      close(con)
    })
  }
  return(con)
}
