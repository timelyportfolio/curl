#' Internet Explorer proxy settings
#'
#' Lookup and mimic the system proxy settings on Windows as set by Internet
#' Explorer. This can be used to configure curl to use the same proxy server.
#'
#' The [ie_proxy_info] function looks up your current proxy settings as configured
#' in IE under "Internet Options" under "LAN Settings". The [ie_get_proxy_for_url]
#' determines if and which proxy should be used to connect to a particular
#' URL. If your settings have an "automatic configuration script" this
#' involves downloading and executing a PAC file, which can take a while.
#'
#' 
#' @export
#' @rdname ie_proxy
#' @name ie_proxy
ie_proxy_info <- function(){
#
}

#' 
#' @param target_url url with host for which to lookup the proxy server
#' @export
#' @rdname ie_proxy
ie_get_proxy_for_url <- function(target_url = "http://www.google.com"){
  stopifnot(is.character(target_url))
  info <- ie_proxy_info()
  if(length(info$Proxy)){
    if(isTRUE(grepl("<local>", info$ProxyBypass, fixed = TRUE)) &&
       isTRUE(grepl("(://)[^./]+/", paste0(target_url, "/")))){
      return(NULL)
    } else {
      return(info$Proxy)
    }
  }
  if(isTRUE(info$AutoDetect) || length(info$AutoConfigUrl)){
#
    if(isTRUE(out$HasProxy)){
      return(out$Proxy)
    }
  }
  return(NULL);
}

#' 
get_windows_build <- function(){
#
}
