#' Async Concurrent Requests
#'
#' AJAX style concurrent requests, possibly using HTTP/2 multiplexing.
#' Results are only available via callback functions. Advanced use only!
#' For downloading many files in parallel use [multi_download] instead.
#'
#' Requests are created in the usual way using a curl \link{handle} and added
#' to the scheduler with \link{multi_add}. This function returns immediately
#' and does not perform the request yet. The user needs to call \link{multi_run}
#' which performs all scheduled requests concurrently. It returns when all
#' requests have completed, or case of a \code{timeout} or \code{SIGINT} (e.g.
#' if the user presses \code{ESC} or \code{CTRL+C} in the console). In case of
#' the latter, simply call \link{multi_run} again to resume pending requests.
#'
#' When the request succeeded, the \code{done} callback gets triggered with
#' the response data. The structure if this data is identical to \link{curl_fetch_memory}.
#' When the request fails, the \code{fail} callback is triggered with an error
#' message. Note that failure here means something went wrong in performing the
#' request such as a connection failure, it does not check the http status code.
#' Just like \link{curl_fetch_memory}, the user has to implement application logic.
#'
#' Raising an error within a callback function stops execution of that function
#' but does not affect other requests.
#'
#' A single handle cannot be used for multiple simultaneous requests. However
#' it is possible to add new requests to a pool while it is running, so you
#' can re-use a handle within the callback of a request from that same handle.
#' It is up to the user to make sure the same handle is not used in concurrent
#' requests.
#'
#' The \link{multi_cancel} function can be used to cancel a pending request.
#' It has no effect if the request was already completed or canceled.
#'
#' The \link{multi_fdset} function returns the file descriptors curl is
#' polling currently, and also a timeout parameter, the number of
#' milliseconds an application should wait (at most) before proceeding. It
#' is equivalent to the \code{curl_multi_fdset} and
#' \code{curl_multi_timeout} calls. It is handy for applications that is
#' expecting input (or writing output) through both curl, and other file
#' descriptors.
#'
#' @name multi
#' @rdname multi
#' @seealso Advanced download interface: [multi_download]
#'
#' @param handle a curl \link{handle} with preconfigured \code{url} option.
#' @param done callback function for completed request. Single argument with
#' response data in same structure as \link{curl_fetch_memory}.
#' @param fail callback function called on failed request. Argument contains
#' error message.
#' @param data (advanced) callback function, file path, or connection object for writing
#' incoming data. This callback should only be used for \emph{streaming} applications,
#' where small pieces of incoming data get written before the request has completed. The
#' signature for the callback function is \code{write(data, final = FALSE)}. If set
#' to \code{NULL} the entire response gets buffered internally and returned by in
#' the \code{done} callback (which is usually what you want).
#' @param pool a multi handle created by \link{new_pool}. Default uses a global pool.
#' @export
multi_add <- function(handle, done = NULL, fail = NULL, data = NULL, pool = NULL){
  if(is.null(pool))
    pool <- multi_default()
  if(inherits(data, "connection")){
    con <- data
    if(isOpen(con) && identical(summary(con)$text, "text")){
      data <- function(x, finalize = FALSE){
        cat(rawToChar(x), file = con)
        flush(con)
      }
    } else {
      was_open <- isOpen(con)
      data <- function(x, finalize = FALSE){
        if(!isOpen(con))
          open(con, 'wb')
        writeBin(x, con = con)
        if(isTRUE(finalize && !was_open)){
          close(con)
        } else {
          flush(con)
        }
      }
    }
  } else if(is_string(data)){
    data <- file_writer(path = data)
  }
  stopifnot(inherits(handle, "curl_handle"))
  stopifnot(inherits(pool, "curl_multi"))
  stopifnot(is.null(done) || is.function(done))
  stopifnot(is.null(fail) || is.function(fail))
  stopifnot(is.null(data) || is.function(data))
#
}

#' @param timeout max time in seconds to wait for results. Use \code{0} to poll for results without
#' waiting at all.
#' @param poll If \code{TRUE} then return immediately after any of the requests has completed.
#' May also be an integer in which case it returns after n requests have completed.
#' @export
#'
#' @rdname multi
multi_run <- function(timeout = Inf, poll = FALSE, pool = NULL){
  if(is.null(pool))
    pool <- multi_default()
  stopifnot(is.numeric(timeout))
  stopifnot(inherits(pool, "curl_multi"))
#
}

#' @param total_con max total concurrent connections.
#' @param host_con max concurrent connections per host.
#' @param multiplex enable HTTP/2 multiplexing if supported by host and client.
#' @export
#'
#' @rdname multi
multi_set <- function(total_con = 50, host_con = 6, multiplex = TRUE, pool = NULL){
  if(is.null(pool))
    pool <- multi_default()
  stopifnot(inherits(pool, "curl_multi"))
  stopifnot(is.numeric(total_con))
  stopifnot(is.numeric(host_con))
  stopifnot(is.logical(multiplex))
#
}

#' @export
#'
#' @rdname multi
multi_list <- function(pool = NULL){
  if(is.null(pool))
    pool <- multi_default()
  stopifnot(inherits(pool, "curl_multi"))
#
}

#' @export
#'
#' @rdname multi
multi_cancel <- function(handle){
  stopifnot(inherits(handle, "curl_handle"))
#
}

#' @export
#'
#' @rdname multi
new_pool <- function(total_con = 100, host_con = 6, multiplex = TRUE){
#
  multi_set(pool = pool, total_con = total_con, host_con = host_con, multiplex = multiplex)
}

multi_default <- local({
  global_multi_handle <- NULL
  function(){
    if(is.null(global_multi_handle)){
      global_multi_handle <<- new_pool()
    }
    stopifnot(inherits(global_multi_handle, "curl_multi"))
    return(global_multi_handle)
  }
})

#' @export
print.curl_multi <- function(x, ...){
  len <- length(multi_list(x))
  cat(sprintf("<curl multi-pool> (%d pending requests)\n", len))
}

#' @export
#'
#' @rdname multi

multi_fdset <- function(pool = NULL){
  if(is.null(pool))
    pool <- multi_default()
  stopifnot(inherits(pool, "curl_multi"))
#
}
