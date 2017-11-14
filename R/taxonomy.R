# Internal functions for accessing the NCBI taxonomy database

get_taxids <- function(x, warn=TRUE){
  # only consider unique IDs
  x <- unique(x)
  # open NCBI taxonomy database
  dbfile <- taxizedb::db_download_ncbi(verbose=FALSE)
  db <- taxizedb::src_ncbi(dbfile)
  # prepare SQL query
  cmd <- "SELECT name_txt, tax_id FROM names WHERE name_txt IN (%s)"
  cmd <- sprintf(cmd, paste0("'", x, "'", collapse=", "))
  table <- taxizedb::sql_collect(db, cmd)
  if(warn){
    # warn of missing ids
    msg <- "%s out of %s entries could not be assigned a species taxonomy ID. Here are the first few: %s"
    no_id <- setdiff(x, table$name_txt)
    if(length(no_id) > 0){
      warning(sprintf(
        msg,
        length(no_id),
        length(x),
        paste(head(no_id), collapse=", ")
      ))
    }
  }
  table
}

sciname2taxid <- function(names){
  dbfile <- taxizedb::db_download_ncbi(verbose=FALSE)
  db <- taxizedb::src_ncbi(dbfile)
  cmd <- "SELECT tax_id FROM names WHERE name_txt IN (%s)"
  cmd <- sprintf(cmd, paste0("'", names, "'", collapse=", "))
  taxizedb::sql_collect(db, cmd)$tax_id
}

downstream <- function(x, clades){
  dbfile <- taxizedb::db_download_ncbi(verbose=FALSE)
  db <- taxizedb::src_ncbi(dbfile)
  # prepare SQL query
  cmd <- "SELECT tax_id, hierarchy_string FROM hierarchy WHERE tax_id IN (%s)"
  cmd <- sprintf(cmd, paste0("'", x@table$tax_id, "'", collapse=", "))
  taxizedb::sql_collect(db, cmd) %>%
    dplyr::mutate(id = strsplit(.data$hierarchy_string, "-")) %>%
    tidyr::unnest(.data$id) %>%
    dplyr::filter(.data$id %in% clades) %>%
    { unique(.$tax_id) }
}
