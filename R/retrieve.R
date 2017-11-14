#' Retrieve data from 1KP
#'
#' @param add_taxids If TRUE, add NCBI taxon ids for each species. This
#' requires downloading the NCBI taxonomy database, which will require a few
#' extra minutes the first time you run the function. This step is necessary
#' only if you wish to filter by NCBI taxon ids.
#' @param filter If TRUE, filter out entries that are associated with a single
#' species (for example crosses or datasets pooled across a genus). If set to
#' TRUE, then add_taxids will also be set to TRUE.
#' @return OneKP object
retrieve_oneKP <- function(add_taxids=TRUE, filter=TRUE){
  oneKP_url <- 'http://www.onekp.com/public_data.html'
  onekp <- new('OneKP')
  onekp@table <- oneKP_url %>%
    xml2::read_html() %>%
    rvest::html_nodes('table') %>%
    rvest::html_table(header=TRUE) %>%
    { .[[1]] }
  onekp@links <- oneKP_url %>%
    xml2::read_html() %>%
    rvest::html_nodes('td a') %>%
    xml2::as_list() %>%
    {
      data.frame(
        file = unlist(.),
        url  = vapply(FUN.VALUE="", ., function(link){attributes(link)$href}),
        stringsAsFactors=FALSE
      )
    }
  if(add_taxids || filter){
    taxnames <- get_taxids(onekp@table$Species, warn=!filter)
    onekp@table <- merge(onekp@table, taxnames, by.x='Species', by.y='name_txt', all.x=TRUE) 
    if(filter){
      onekp@table <- onekp@table[!is.na(onekp@table$tax_id), ]
    }
  } else {
    onekp@table$tax_id <- NA
  }
  onekp
}

get_taxids <- function(x, warn=TRUE){
  # only consider unique IDs
  x <- unique(x)
  # open NCBI taxonomy database
  dbfile <- taxizedb::db_download_ncbi()
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
