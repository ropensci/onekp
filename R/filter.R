#' Filter a OneKP object
#'
#' @param x OneKP object
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
#' filter_by_ancestor_id(onekp, 3700)
NULL

#' @rdname filter
#' @export
filter_by_code <- function(x, code) {
  x@table <- x@table[x@table[['1kP_Code']] %in% code, ]
  x
}

#' @rdname filter
#' @export
filter_by_ancestor_name <- function(x, names) {
  dbfile <- taxizedb::db_download_ncbi()
  db <- taxizedb::src_ncbi(dbfile)
  # prepare SQL query
  cmd <- "SELECT tax_id FROM names WHERE name_txt IN (%s)"
  cmd <- sprintf(cmd, paste0("'", names, "'", collapse=", "))
  tax_ids <- taxizedb::sql_collect(db, cmd)$tax_id
  filter_by_ancestor_id(x, tax_ids)
}

#' @rdname filter
#' @export
filter_by_ancestor_id <- function(x, ids) {
  dbfile <- taxizedb::db_download_ncbi()
  db <- taxizedb::src_ncbi(dbfile)
  # prepare SQL query
  cmd <- "SELECT tax_id, hierarchy_string FROM hierarchy WHERE tax_id IN (%s)"
  cmd <- sprintf(cmd, paste0("'", x@table$tax_id, "'", collapse=", "))
  taxa <- taxizedb::sql_collect(db, cmd) %>%
    transform(hierarchy_string=strsplit(hierarchy_string, "-")) %>%
    tidyr::unnest(hierarchy_string) %>%
    dplyr::filter(hierarchy_string %in% ids) %>%
    { unique(.$tax_id) }
  filter_by_taxid(x, taxa)
}

#' @rdname filter
#' @export
filter_by_species <- function(x, species) {
  species <- gsub('_', ' ', species)
  x@table <- x@table[x@table[['Species']] %in% species, ]
  x
}

#' @rdname filter
#' @export
filter_by_taxid <- function(x, tax_id) {
  x@table <- x@table[x@table[['tax_id']] %in% tax_id, ]
  x
}
