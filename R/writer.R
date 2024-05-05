#' Lazy File Writer
#'
#' Generates a closure that writes binary (raw) data to a file.
#'
#' The writer function automatically opens the file on the first write and closes when
#' it goes out of scope, or explicitly by setting \code{close = TRUE}. This can be used
#' for the \code{data} callback in \code{multi_add()} or \code{curl_fetch_multi()} such
#' that we only keep open file handles for active downloads. This prevents running out
#' of file descriptors when performing thousands of concurrent requests.
#'
#' @export
#' @param path file name or path on disk
#' @param append open file in append mode
#' @return Function with signature \code{writer(data = raw(), close = FALSE)}
file_writer <- function(path, append = FALSE){
  path <- enc2native(normalizePath(path, mustWork = FALSE))
  fp <- new_file_writer(path, append)
  structure(function(data = raw(), close = FALSE){
    stopifnot(is.raw(data))
    write_file_writer(fp, data, as.logical(close))
  }, class = "file_writer")
}

#'
new_file_writer <- function(path, append){
#
}

#'
write_file_writer <- function(fp, data, close){
#
}

#'
total_writers <- function(){
#
}
