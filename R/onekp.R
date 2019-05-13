#' @importFrom rlang .data
#' @importFrom methods new
#' @importFrom utils head untar download.file
utils::globalVariables(c("%>%", "."))
NULL

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
NULL

#' onekp: access data from the 1KP project
#'
#' The 1000 Plants Initiative (www.onekp.com) has sequenced the transcriptomes
#' of over 1000 plant species. This package allows these sequences and metadata
#' to be retrieved and filtered by code, species or recursively by clade.
#' Scientific names and NCBI taxonomy IDs are both supported.
#'
#' @section Main Functions:
#'
#' \code{retrieve_onekp} - retrieve all 1KP metadata
#'
#' \code{filter_by_code} - filter metadata by 1KP code
#'
#' \code{filter_by_clade} - filter metadata by clade
#'
#' \code{filter_by_species} - filter metadata by species
#'
#' \code{download_peptides} - get protein sequences linked to metadata
#'
#' \code{download_nucleotides} - get DNA sequences linked to metadata
#'
#' @section Author(s):
#'
#' Zebulun Arendsee <email: zbwrnz@gmail.com>
#'
#' @section Bug Reports:
#'
#' Any bugs or issues can be reported at <https://github.com/ropensci/onekp/issues>
#'
#' @docType package
#' @name onekp
NULL
