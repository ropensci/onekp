#' Filter a OneKP object
#'
#' @param x OneKP object
#' @param code character vector of 1KP IDs (e.g. URDJ)
#' @param clade vector of clade-level NCBI taxonomy IDs or scientific names
#' @param species vector of species-level scientific names or NCBI taxonomy IDs
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
#' filter_by_species(onekp, 3347)
#'
#' # filter by clade name scientific name
#' filter_by_clade(onekp, 'Brassicaceae')
#'
#' # filter by clade NCBI taxon ID
#' filter_by_clade(onekp, 3700)
NULL

#' @rdname filter
#' @export
filter_by_code <- function(x, code) {
  x@table <- x@table[x@table[['code']] %in% code, ]
  x
}

#' @rdname filter
#' @export
filter_by_clade <- function(x, clade) {
  if(all(is.character(clade))){
    clade <- sciname2taxid(clade) 
  }
  filter_by_species(x, downstream(x, clade))
}

#' @rdname filter
#' @export
filter_by_species <- function(x, species) {
  selection <- if(all(is.character(species))){
    species <- gsub('_', ' ', species)
    x@table[['species']] %in% species
  } else {
    x@table[['tax_id']] %in% species
  }
  x@table <- x@table[selection, ]
  x
}
