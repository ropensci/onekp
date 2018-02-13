#' Retrieve data from 1KP
#'
#' @param add_taxids If TRUE, add NCBI taxon ids for each species. This
#' requires downloading the NCBI taxonomy database, which will require a few
#' extra minutes the first time you run the function. This step is necessary
#' only if you wish to filter by NCBI taxon ids.
#' @param filter If TRUE, filter out entries that are associated with a single
#' species (for example crosses or datasets pooled across a genus). If set to
#' TRUE, then add_taxids will also be set to TRUE.
#' @export
#' @return OneKP object
#' @examples
#' # scrape data from the OneKP website 
#' kp <- retrieve_oneKP()
#' # print to see data summary
#' kp
#' # access the metadata table
#' head(kp@table)
retrieve_oneKP <- function(add_taxids = TRUE, filter = TRUE){
  oneKP_url <- 'http://www.onekp.com/public_data.html'
  onekp <- new('OneKP')
  onekp@table <- oneKP_url %>%
    xml2::read_html() %>%
    rvest::html_nodes('table') %>%
    rvest::html_table(header = TRUE) %>%
    { .[[1]] } %>%
    dplyr::select(
      species     = 'Species',
      code        = '1kP_Code',
      family      = 'Family',
      tissue      = 'Tissue Type',
      peptides    = 'Peptides',
      nucleotides = 'Nucleotides'
    )
  onekp@links <- oneKP_url %>%
    xml2::read_html() %>%
    rvest::html_nodes('td a') %>%
    xml2::as_list() %>%
    {
      data.frame(
        file = unlist(.),
        url  = vapply(FUN.VALUE = "", ., function(link){attributes(link)$href}),
        stringsAsFactors = FALSE
      )
    }
  onekp@table$tax_id <- if(add_taxids || filter){
    taxizedb::name2taxid(onekp@table$species, out_type = 'uid')
  } else {
    onekp@table$tax_id <- NA
  }
  onekp
}
