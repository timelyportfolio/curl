#' @rdname curl_options
#' @export
curl_symbols <- function(filter = ""){
  m <- grep(filter, curl_symbol_data$name, ignore.case = TRUE)
  curl_symbol_data[m,]
}

#'
#' @export
#' @rdname curl_options
curl_version <- function(){
#
}

#' Parse date/time
#'
#' Can be used to parse dates appearing in http response headers such
#' as \code{Expires} or \code{Last-Modified}. Automatically recognizes
#' most common formats. If the format is known, \code{\link{strptime}}
#' might be easier.
#'
#' @param datestring a string consisting of a timestamp
#'
#' @export
parse_date <- function(datestring){
#
  class(out) <- c("POSIXct", "POSIXt")
  out
}


#'
split_string <- function(x, split = ":"){
#
}

trimws <- function(x) {
  sub("\\s+$", "", sub("^\\s+", "", x))
}

is_string <- function(x){
  is.character(x) && length(x)
}
