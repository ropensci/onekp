context("all")

kp    <- NULL
prots <- NULL
nucs  <- NULL

test_that("Can download 1KP table of data", {
  expect_silent(kp <<- retrieve_onekp())
  expect_equal(
    names(kp@table),
    c(
      'species',
      'code',
      'family',
      'tissue',
      'peptides',
      'nucleotides',
      'tax_id'
    )
  )
  # check that printing at least prints something ...
  expect_output(print(kp))
  # expect_true(!any(is.na(kp@table$tax_id)))
  expect_equal(
    filter_by_code(kp, c('URDJ', 'ROAP'))@table$tax_id,
    c("13333", "13099")
  )
  expect_equal(filter_by_species(kp, 'Pinus radiata')@table$tax_id, "3347")
  expect_equal(filter_by_species(kp, 3347)@table$species, 'Pinus radiata')
  expect_equal(
    filter_by_clade(kp, 'Brassiceae')@table$species,
    c('Brassica nigra', 'Sinapis alba')
  )
  expect_equal(
    filter_by_clade(kp, 981071)@table$species,
    c('Brassica nigra', 'Sinapis alba')
  )
})

test_dir <- 'onekp_test'
test_that("Can download protein sequence", {
  dir <- file.path(test_dir, 'pro')
  expect_equal(
    {
      prots <<- download_peptides(filter_by_clade(kp, 'Brassicaceae'), dir)
      gsub("\\.faa$", "", basename(prots)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  # test re-downloading, which should reuse the existing files
  expect_equal(
    {
      prots <<- download_peptides(filter_by_clade(kp, 'Brassicaceae'), dir)
      gsub("\\.faa$", "", basename(prots)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  expect_true(all(file.exists(prots)))
})

test_that("Can download nucleotide sequence", {
  dir <- file.path(test_dir, 'nuc')
  expect_equal(
    {
      nucs <<- download_nucleotides(filter_by_clade(kp, 'Brassicaceae'), dir)
      gsub("\\.fna$", "", basename(nucs)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  # test re-downloading, which should reuse the existing files
  expect_equal(
    {
      nucs <<- download_nucleotides(filter_by_clade(kp, 'Brassicaceae'), dir)
      gsub("\\.fna$", "", basename(nucs)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  expect_true(all(file.exists(nucs)))
})

test_that("Nothing gets you nothing", {
  # filter by an imaginary species
  expect_equal(nrow(filter_by_species(kp, 'foobar')@table), 0)
  # filter by clade that is in NCBI but not in this dataset 
  expect_equal(nrow(filter_by_clade(kp, 'Homo')@table), 0)
  # filter by a code that is not in the table
  expect_equal(nrow(filter_by_code(kp, 'asdfasdf')@table), 0)
  # downloading an empty table gets an empty vector of paths
  expect_true(identical(
    download_peptides(filter_by_species(kp, 'foobar')),
    character(0)
  ))
  expect_true(identical(
    download_nucleotides(filter_by_species(kp, 'foobar')),
    character(0)
  ))
})

test_that("Bad input to filter triggers an error", {
  expect_error(filter_by_clade(kp, "Dragon"))
})

unlink('onekp_test', recursive = TRUE)
