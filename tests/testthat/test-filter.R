context("filter")

test_that("Bad input to filter triggers an error", {
  expect_error(filter_by_clade(onekp, "Dragon"))
})

test_that("Filters work", {
  expect_equal(
    filter_by_code(onekp, c('URDJ', 'ROAP'))@table$tax_id,
    c("13333", "13099")
  )
  expect_equal(filter_by_species(onekp, 'Pinus radiata')@table$tax_id, "3347")
  expect_equal(filter_by_species(onekp, 3347)@table$species, 'Pinus radiata')
  expect_equal(
    filter_by_clade(onekp, 'Brassiceae')@table$species,
    c('Brassica nigra', 'Sinapis alba')
  )
  expect_equal(
    filter_by_clade(onekp, 981071)@table$species,
    c('Brassica nigra', 'Sinapis alba')
  )
})

test_that("Nothing gets you nothing", {
  # filter by an imaginary species
  expect_equal(nrow(filter_by_species(onekp, 'foobar')@table), 0)
  # filter by clade that is in NCBI but not in this dataset 
  expect_equal(nrow(filter_by_clade(onekp, 'Homo')@table), 0)
  # filter by a code that is not in the table
  expect_equal(nrow(filter_by_code(onekp, 'asdfasdf')@table), 0)
})
