context("download")

prots <- NULL
nucs  <- NULL
test_dir <- 'onekp_test'

data(onekp)

test_that("Can download protein sequence", {
  dir <- file.path(test_dir, 'pro')
  expect_equal(
    {
      prots <<- download_peptides(filter_by_clade(onekp, 'Brassicaceae'), dir)
      gsub("\\.faa$", "", basename(prots)) 
    },
    filter_by_clade(onekp, 'Brassicaceae')@table$code
  )
  # test re-downloading, which should reuse the existing files
  expect_equal(
    {
      prots <<- download_peptides(filter_by_clade(onekp, 'Brassicaceae'), dir)
      gsub("\\.faa$", "", basename(prots)) 
    },
    filter_by_clade(onekp, 'Brassicaceae')@table$code
  )
  expect_true(all(file.exists(prots)))
})

test_that("Can download nucleotide sequence", {
  dir <- file.path(test_dir, 'nuc')
  expect_equal(
    {
      nucs <<- download_nucleotides(filter_by_clade(onekp, 'Brassicaceae'), dir)
      gsub("\\.fna$", "", basename(nucs)) 
    },
    filter_by_clade(onekp, 'Brassicaceae')@table$code
  )
  # test re-downloading, which should reuse the existing files
  expect_equal(
    {
      nucs <<- download_nucleotides(filter_by_clade(onekp, 'Brassicaceae'), dir)
      gsub("\\.fna$", "", basename(nucs)) 
    },
    filter_by_clade(onekp, 'Brassicaceae')@table$code
  )
  expect_true(all(file.exists(nucs)))
})

test_that("Downloading nothing returns empty vector", {
  # downloading an empty table gets an empty vector of paths
  expect_true(identical(
    download_peptides(filter_by_species(onekp, 'foobar')),
    character(0)
  ))
  expect_true(identical(
    download_nucleotides(filter_by_species(onekp, 'foobar')),
    character(0)
  ))
})

unlink('onekp_test', recursive = TRUE)
