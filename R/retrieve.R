#' Retrieve data from 1KP
#'
#' @return OneKP object
retrieve_oneKP <- function(){
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
  onekp
}
