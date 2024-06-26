#' Fetch the contents of a URL
#'
#' Low-level bindings to write data from a URL into memory, disk or a callback
#' function. These are mainly intended for \code{httr}, most users will be better
#' off using the \code{\link{curl}} or \code{\link{curl_download}} function, or the
#' http specific wrappers in the \code{httr} package.
#'
#' The curl_fetch functions automatically raise an error upon protocol problems
#' (network, disk, ssl) but do not implement application logic. For example for
#' you need to check the status code of http requests yourself in the response,
#' and deal with it accordingly.
#'
#' Both \code{curl_fetch_memory} and \code{curl_fetch_disk} have a blocking and
#' non-blocking C implementation. The latter is slightly slower but allows for
#' interrupting the download prematurely (using e.g. CTRL+C or ESC). Interrupting
#' is enabled when R runs in interactive mode or when
#' \code{getOption("curl_interrupt") == TRUE}.
#'
#' The \code{curl_fetch_multi} function is the asynchronous equivalent of
#' \code{curl_fetch_memory}. It wraps \code{multi_add} to schedule requests which
#' are executed concurrently when calling \code{multi_run}. For each successful
#' request the \code{done} callback is triggered with response data. For failed
#' requests (when \code{curl_fetch_memory} would raise an error), the \code{fail}
#' function is triggered with the error message.
#'
#' @param url A character string naming the URL of a resource to be downloaded.
#' @param handle a curl handle object
#' @export
#' @rdname curl_fetch
curl_fetch_memory <- function(url, handle){
  nonblocking <- isTRUE(getOption("curl_interrupt", TRUE))
#
  res <- handle_data(handle)
  res$content <- output
  res
}

#' @export
#' @param path Path to save results
#' @rdname curl_fetch
#'
curl_fetch_disk <- function(url, path, handle){
  nonblocking <- isTRUE(getOption("curl_interrupt", TRUE))
  path <- enc2native(normalizePath(path, mustWork = FALSE))
#
  res <- handle_data(handle)
  res$content <- output
  res
}

#' @export
#' @param fun Callback function. Should have one argument, which will be
#'   a raw vector.
#' @rdname curl_fetch
#'
curl_fetch_stream <- function(url, fun, handle){
  # Blocking = TRUE and partial = TRUE to prevent busy-waiting
  con <- curl_connection(url, mode = "", handle = handle, partial = TRUE)

  # 'f' means: do not error for status code
  open(con, "rbf")
  on.exit(close(con))
  while(isIncomplete(con)){
    buf <- readBin(con, raw(), 32768L)
    if(length(buf))
      fun(buf)
  }
  handle_data(handle)
}

#' @export
#' @rdname curl_fetch
#' @inheritParams multi
#'
curl_fetch_multi <- function(url, done = NULL, fail = NULL, pool = NULL,
                             data = NULL, handle){
  handle_setopt(handle, url = enc2utf8(url))
  multi_add(handle = handle, done = done, fail = fail, data = data, pool = pool)
  invisible(handle)
}

#' @export
#' @rdname curl_fetch
curl_fetch_echo <- function(url, handle){
  handle_setopt(handle, url = enc2utf8(url))
  curl_echo(handle)
}
