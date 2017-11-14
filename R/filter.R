#' Filter a OneKP object
#'
#' @param x OneKP object
#' @param code character vector of 1KP IDs (e.g. URDJ)
#' @param ids vector of NCBI taxonomy IDs
#' @param names vector of scientific names (
#' @return OneKP object
#' @name filter
#' @examples
#' onekp <- retrieve_oneKP()
#' onekp
#'
#' # filter by 1KP ID
#' filter_by_code(onekp, c('URDJ', 'ROAP'))
#'
#' # filter by species name
#' filter_by_species(onekp, 'Pinus radiata')
#'
#' # filter by species NCBI taxon ID
#' filter_by_taxid(onekp, 3347)
#'
#' # filter by ancestor name scientific name
#' filter_by_ancestor_name(onekp, 'Brassicaceae')
#'
#' # filter by ancestor NCBI taxon ID
#' filter_by_ancestor_taxid(onekp, 3700)
NULL

#' @rdname filter
#' @export
filter_by_code <- function(x, code) {
  x@table <- x@table[x@table[['code']] %in% code, ]
  x
}

#' @rdname filter
#' @export
filter_by_ancestor_name <- function(x, names) {
  filter_by_ancestor_taxid(x, sciname2taxid(names))
}

#' @rdname filter
#' @export
filter_by_ancestor_taxid <- function(x, ids) {
  filter_by_taxid(x, downstream(x, ids))
}

#' @rdname filter
#' @export
filter_by_species <- function(x, names) {
  names <- gsub('_', ' ', names)
  x@table <- x@table[x@table[['species']] %in% names, ]
  x
}

#' @rdname filter
#' @export
filter_by_taxid <- function(x, ids) {
  x@table <- x@table[x@table[['tax_id']] %in% ids, ]
  x
}
