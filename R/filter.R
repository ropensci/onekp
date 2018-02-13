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
    clade <- taxizedb::name2taxid(clade) 
  }

  # Get all NCBI taxonomy IDs descending from the input clades
  taxa <- lapply(taxizedb::downstream(
    clade,
    downto            = 'species',
    ambiguous_node    = TRUE,
    ambiguous_species = TRUE
  ), function(d){
   d$childtaxa_id 
  }) %>% unlist %>% unname

  # Find the common ids
  onekp_species <- intersect(taxa, x@table$tax_id)

  filter_by_species(x, onekp_species)
}

#' @rdname filter
#' @export
filter_by_species <- function(x, species) {
  selection <- if(all(grepl('^[0-9]+$', species, perl = TRUE))){
    x@table$tax_id %in% species
  } else {
    species <- gsub('_', ' ', species)
    x@table$species %in% species
  }
  x@table <- x@table[selection, ]
  x
}
