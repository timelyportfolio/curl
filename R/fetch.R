#' Fetch the contents of a URL.
#'
#' @param url A character string naming the URL of a resource to be downloaded.
#' @param handle a curl handle object
#' @export
#' @useDynLib curl R_curl_fetch_memory
#' @examples
#' # Redirect + cookies
#' res <- curl_fetch_memory("http://httpbin.org/cookies/set?foo=123&bar=ftw")
#' res$content
#'
#' # Save to disk
#' res <- curl_fetch_disk("http://httpbin.org/stream/10", tempfile())
#' res$content
#' readLines(res$content)
curl_fetch_memory <- function(url, handle = new_handle()){
  output <- .Call(R_curl_fetch_memory, url, handle)
  res <- handle_response_data(handle)
  res$content <- output
  res
}

#' @export
#' @param path Path to save results
#' @rdname curl_fetch_memory
#' @useDynLib curl R_curl_fetch_disk
curl_fetch_disk <- function(url, path, handle = new_handle()){
  path <- normalizePath(path, mustWork = FALSE)
  output <- .Call(R_curl_fetch_disk, url, handle, path, "wb")
  res <- handle_response_data(handle)
  res$content <- output
  res
}

#' @export
#' @param fun Callback function. Should have one argument, which will be
#'   a raw vector.
#' @rdname curl_fetch_memory
#' @useDynLib curl R_curl_connection
curl_fetch_stream <- function(url, fun, handle = new_handle()){
  con <- .Call(R_curl_connection, url, "rb", handle, FALSE)
  on.exit(close(con))
  while(length(bin <- readBin(con, raw(), 8192L))){
    fun(bin)
  }
  handle_response_data(handle)
}