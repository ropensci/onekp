context("retrieval")

data(onekp)

test_that("The cached metadata is the same as the online data", {
  skip_on_cran()
  skip_on_travis()
  expect_equal(retrieve_onekp(), onekp)
})

test_that("1KP table contains the right material", {
  expect_equal(
    names(onekp@table),
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
  expect_output(print(onekp))
  # expect_true(!any(is.na(kp@table$tax_id)))
})
