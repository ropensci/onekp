#' Filter a OneKP object
#'
#' @param x OneKP object
#' @return OneKP object
#' @name filter
#' @examples
#' onekp <- retrieve_oneKP()
#' onekp
#' x <- filter_by_code(onekp, c('URDJ', 'ROAP'))
#' x
NULL

#' @rdname filter
#' @export
filter_by_code    <- function(x, code) {
  x@table <- x@table[x@table[['1kP_Code']] %in% code, ]
  x
}

#' @rdname filter
#' @export
filter_by_node    <- function(x, node) {
  stop("NOT IMPLEMENTED")
}

#' @rdname filter
#' @export
filter_by_species <- function(x, species) {
  stop("NOT IMPLEMENTED")
}
