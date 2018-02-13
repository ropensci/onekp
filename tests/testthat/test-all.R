context("all")

kp <- NULL
prots <- NULL
nucs <- NULL

test_that("Can download 1KP table of data", {
  expect_silent(kp <<- retrieve_oneKP())
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

test_that("Can download protein sequence", {
  expect_equal(
    {
      prots <<- download_peptides(filter_by_clade(kp, 'Brassicaceae'))
      gsub("\\.faa$", "", basename(prots)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  # test re-downloading, which should reuse the existing files
  expect_equal(
    {
      prots <<- download_peptides(filter_by_clade(kp, 'Brassicaceae'))
      gsub("\\.faa$", "", basename(prots)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  expect_true(all(file.exists(prots)))
})

test_that("Can download nucleotide sequence", {
  expect_equal(
    {
      nucs <<- download_nucleotides(filter_by_clade(kp, 'Brassicaceae'))
      gsub("\\.fna$", "", basename(nucs)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  # test re-downloading, which should reuse the existing files
  expect_equal(
    {
      nucs <<- download_nucleotides(filter_by_clade(kp, 'Brassicaceae'))
      gsub("\\.fna$", "", basename(nucs)) 
    },
    filter_by_clade(kp, 'Brassicaceae')@table$code
  )
  expect_true(all(file.exists(nucs)))
})

unlink('OneKP', recursive=TRUE)
