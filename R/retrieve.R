#' Retrieve data from 1KP
#'
#' @param add_taxids If TRUE, add NCBI taxon ids for each species. This
#' requires downloading the NCBI taxonomy database, which will require a few
#' extra minutes the first time you run the function. This step is necessary
#' only if you wish to filter by NCBI taxon ids.
#' @return OneKP object
retrieve_oneKP <- function(add_taxids=TRUE){
  onekp <- new('OneKP')
  onekp@table <- 'http://www.onekp.com/public_data.html' %>%
    xml2::read_html() %>%
    rvest::html_nodes('table') %>%
    rvest::html_table(header=TRUE) %>%
    { .[[1]] }
  onekp@links <- 'http://www.onekp.com/public_data.html' %>%
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

  if(add_taxids){

    taxnames <- get_taxids(onekp@table$Species)

    onekp@table <- merge(onekp@table, taxnames, by.x='Species', by.y='name_txt', all.x=TRUE) 

    msg <- "%s out of %s entries could not be assigned a species taxonomy ID. Here are the first few: %s"
    no_id <- is.na(onekp@table$tax_id)
    if(sum(no_id) > 0){
      warning(sprintf(
        msg,
        sum(no_id),
        length(no_id),
        paste(head(x[no_id, 'Species']), collapse=", ")
      ))
    }

  } else {
    onekp@table$taxid <- NA
  }

  onekp
}

get_taxids <- function(x){
  dbfile <- taxizedb::db_download_ncbi()

  db <- taxizedb::src_ncbi(dbfile)

  cmd <- "SELECT name_txt, tax_id FROM names WHERE name_txt IN (%s)"
  cmd <- sprintf(cmd, paste0("'", unique(x), "'", collapse=", "))

  sql_collect(db, cmd)
}
