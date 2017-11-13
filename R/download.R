#' Download a dataset
#'
#' These functions will return all files in the OneKP object of the given type
#' (e.g. protein FASTA files for get_peptides). If you do not want to retrieve
#' all these files (there are over a thousand), then you should filter the
#' OneKP object first, using the \code{filter_by_*} functions.
#'
#' @param x OneKP object
#' @return character vector of paths to the files that were downloaded
#' @name download
NULL

.download <- function(x, field, unwrap, uncache, dir=file.path('oneKP', field)){
  links <- x@links[x@links$file %in% x@table[[field]], ]
  apply(links, 1, function(link){
    file <- link[1]
    url  <- link[2]
    cache <- uncache(dir, file)
    if(!is.na(cache)){
      message(sprintf("Skipping %s", file))
      cache
    } else {
      path <- file.path(dir, file)
      if(!dir.exists(dir))
        dir.create(dir, recursive=TRUE)
      curl::curl_download(url=url, destfile=path, quiet=TRUE)
      unwrap(path)
    }
  })
}

.cache_by_extension <- function(old_ext, new_ext){
  function(dir, file){
    path <- file.path(dir, sub(old_ext, new_ext, file))
    if(file.exists(path)){
      path
    } else {
      NA
    }
  }
}

#' @rdname download
#' @export
download_assembly <- function(x){
  stop("NOT IMPLEMENTED")
}

#' @rdname download
#' @export
download_transrate_stats <- function(x){
  stop("NOT IMPLEMENTED")
}

#' @rdname download
#' @export
download_index <- function(x){
  stop("NOT IMPLEMENTED")
}

#' @rdname download
#' @export
download_geneID_to_orthoID_map <- function(x){
  stop("NOT IMPLEMENTED")
}

#' @rdname download
#' @export
download_peptides <- function(x){
  unwrap <- function(path){
    # create a temporary directory that will hold the extracted files
    dir <- tempdir()
    if(!dir.exists(dir))
      dir.create(dir)
    # get names of all files
    files <- file.path(dir, untar(path, compressed='bzip2', list=TRUE))
    # extract files 
    untar(path, compressed='bzip2', exdir=dir)
    # name and create the destination file
    final <- sub('.tar.bz2', '', path)
    file.create(final)
    # FIXME: 1KP stores the proteins in thousands of individual files.  I simple
    # cat them all into one file.  However, the names are NOT unique. The
    # filenames have the format '<1KP_code>.<id>.FAA'. The id is probably
    # important and I should write it into the headers before joining them. But
    # for now, I won't.
    file.append(final, files)
    # cleanup
    file.remove(path)
    unlink(dir, recursive=TRUE)
    final
  }
  .download(
    x,
    'Peptides',
    unwrap  = unwrap,
    uncache = .cache_by_extension(old_ext='.faa.tar.bz2', new_ext='.faa')
  )
}

#' @rdname download
#' @export
download_nucleotides <- function(x){
  stop("NOT IMPLEMENTED")
}

#' @rdname download
#' @export
download_filtered_gene_sets <- function(x){
  stop("NOT IMPLEMENTED")
}

#' @rdname download
#' @export
download_filtered <- function(x){
  stop("NOT IMPLEMENTED")
}
