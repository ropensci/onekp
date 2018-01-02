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
#' @examples
#' \dontrun{
#' onekp <- retrieve_oneKP()
#' seqs <- filter_by_code(onekp, c('URDJ', 'ROAP'))
#' download_peptides(seqs)
#' download_nucleotides(seqs)
#' }
NULL

#' Download a file if not already cached
#'
#' @param x OneKP object
#' @param field Kind of thing to download (e.g. 'nucleotides' or 'peptides')
#' @param unwrap A function to extract the data from the raw download
#' @param uncache A function to retrieve an item cache
#' @param dir The directory to which final data should be written
#' @return List of filenames
#' @noRd
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

#' Make function to make cache names based off extensions
#'
#' @param old_ext The extension of the raw file
#' @param new_ext The extension of the file to be cached
#' @return A function of a directory name and a filename
#' @noRd
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

#' Extract a single fasta file from the compressed archive 1KP stores
#'
#' 1KP stores sequence as thousands of individual files, one for each gene. I
#' simple cat them all into one file. However, the names are NOT unique. The
#' filenames have the format '<1KP_code>.<id>.FAA'. The id is probably
#' important and I should write it into the headers before joining them. But
#' for now, I won't.
#'
#' @param path The filename of the raw data
#' @return A path to the unwrapped data
#' @noRd
.unwrap_sequence <- function(path){
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
  file.append(final, files)
  # cleanup
  file.remove(path)
  unlink(dir, recursive=TRUE)
  final
}

#' @rdname download
#' @export
download_peptides <- function(x){
  .download(
    x,
    'peptides',
    unwrap  = .unwrap_sequence,
    uncache = .cache_by_extension(old_ext='.faa.tar.bz2', new_ext='.faa')
  )
}

#' @rdname download
#' @export
download_nucleotides <- function(x){
  .download(
    x,
    'nucleotides',
    unwrap  = .unwrap_sequence,
    uncache = .cache_by_extension(old_ext='.fna.tar.bz2', new_ext='.fna')
  )
}
