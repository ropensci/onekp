#' OneKP print generic function
#'
#' @param x OneKP object
#' @param ... Additional arguments (unused)
print.OneKP <- function(x, ...){
  cat("OneKP object\n")
  cat(sprintf(
    'Slot "table": metadata for %s transcriptomes from %s species\n',
    nrow(x@table),
    length(unique(x@table$species))
  ))
  cat('Slot "links": map of file names from "table" to URLs\n')
}
setMethod("show", "OneKP",
  function(object) print(object)
)
