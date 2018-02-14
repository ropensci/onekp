# onekp 0.X.X

 The goal of this version is to address all issues raised by the rOpenSci
 editor (Scott Chamberlain) and my two reviewers: Jessica Minnier and Zachary
 Foster.

## Updates based on editor comments

 * Added `URL` tag to DESCRIPTION

 * Added `BugReports` tag to DESCRIPTION

 * Wrapped all lines longer than 80 characters

 * Removed unused imports `readr` and `tidyr`

## Updates based on Zachary Foster's review

 * Add space between equal signs in argument lists

 * Change package name from `oneKP` to `onekp`

 * Let user set the download directory (defaulting to a tempdir).

 * Re-export the `magrittr` `%>%` operator

 * Update README

 * Add CONDUCT.md

 * Add R `devel` test to travis

 * More package-level documentation

 * Do not export print.OneKP function

 * Add documentation details to `retrieve_onekp`

 * Update intro vignette

 * Do not run examples that access the internet (call `retrieve_onekp`)

## Updates based on Jessica Minnier's review  

 There was some overlap between the two reviews, here I just list updates made that are unique to this review.

 * Clarify `filter_by_code` and `filter_by_species` examples

 * Cleanup the `download` documentation

 * Add `absolute` parameter to `download_*` functions. If TRUE, this returns
   the absolute path to the retrieved data.

# onekp 0.1.0

 * Initial release
