context("all")

kp <- NULL

test_that("Can download 1KP table of data", {
  expect_silent(kp <<- retrieve_oneKP())
  expect_equal(
    names(kp@table),
    c('species', 'code', 'family', 'tissue', 'peptides', 'nucleotides', 'tax_id')
  )
  expect_true(!any(is.na(kp@table$tax_id)))
  expect_equal(
    filter_by_code(kp, c('URDJ', 'ROAP'))@table$tax_id,
    c(13333, 13099)
  )
  expect_equal(filter_by_species(kp, 'Pinus radiata')@table$tax_id, 3347)
  expect_equal(filter_by_taxid(kp, 3347)@table$species, 'Pinus radiata')
  expect_equal(
    filter_by_ancestor_name(kp, 'Brassiceae')@table$species,
    c('Brassica nigra', 'Sinapis alba')
  )
  expect_equal(
    filter_by_ancestor_taxid(kp, 981071)@table$species,
    c('Brassica nigra', 'Sinapis alba')
  )
})
