[![stable](http://badges.github.io/stability-badges/dist/stable.svg)](http://github.com/badges/stability-badges)
[![Travis-CI Build Status](https://travis-ci.org/ropensci/onekp.svg?branch=master)](https://travis-ci.org/ropensci/onekp)
[![Coverage Status](https://img.shields.io/codecov/c/github/ropensci/onekp/master.svg)](https://codecov.io/github/ropensci/onekp?branch=master)

# onekp

The [1000 Plants initiative
(1KP)](https://sites.google.com/a/ualberta.ca/onekp/) provides the
transcriptome sequences to over 1000 plants from diverse lineages. `onekp`
allows researchers in plant genomics and transcriptomics to access this dataset
through a simple R interface. The metadata for each transcriptome project is
scraped from the 1KP project website. This metadata includes the species,
tissue, and research group for each sequence sample. `onekp` leverages the
taxonomy program `taxizedb`, a local database version of `taxize` package, to
allow filtering of the metadata by taxonomic group (entered as either a taxon
name or NCBI ID). The raw nucleotide or translated peptide sequence can then be
downloaded for the full, or filtered, table of transcriptome projects. 

## Alternatives to `onekp`

The data may also be accessed directly through CyVerse (previously iPlant).
CyVerse efficiently distributes data using the iRODS data system. This approach
is preferable for high-throughput cases or in where iRODS is already in play.
Further, accessing data straight from the source at CyVerse is more stable than
scraping it from project website. However, the `onekp` R package is generally
easier to use (no iRODS dependency or CyVerse API) and offers powerful
filtering solutions. 

## Contact info

1KP staff

 * [Gane Ka-Shu Wong](https://sites.google.com/a/ualberta.ca/professor-gane-ka-shu-wong/) - Principal investigator

 * [Michael Deyholos](mkdeyholos@gmail.com) - Alberta co-investigator

 * [Yong Zhang](zhangy@genomics.org.cn) - Shenzhen co-investigator

 * [Eric Carpenter](ejc@ualberta.ca) - Database manager

R package maintainer

 * [Zebulun Arendsee](arendsee@iastate.edu)


## Installation

`onekp` is on CRAN, but currently is a little out of date. So for now it is
better to install through github. 


```r
library(devtools)
install_github('ropensci/onekp')
```

## Examples

Retrieve the protein and gene transcript FASTA files for two 1KP transcriptomes: 


```r
onekp <- retrieve_onekp()
seqs <- filter_by_code(onekp, c('URDJ', 'ROAP'))
download_peptides(seqs, 'oneKP/pep')
download_nucleotides(seqs, 'oneKP/nuc')
```

This will create the following directory:

```
oneKP
 ├── nuc 
 │   ├── ROAP.fna
 │   └── URDJ.fna
 └── pep
     ├── ROAP.faa
     └── URDJ.faa
```

`onekp` can also filter by species names, taxon ids, or clade.


```r
# filter by species name
filter_by_species(onekp, 'Pinus radiata')

# filter by species NCBI taxon ID
filter_by_species(onekp, 3347)

# filter by clade name scientific name (get all data for the Brassicaceae family)
filter_by_clade(onekp, 'Brassicaceae')

# filter by clade NCBI taxon ID
filter_by_clade(onekp, 3700)
```

So to get the protein sequences for all species in Brassicaceae:


```r
onekp <- retrieve_onekp()
seqs <- filter_by_clade(onekp, 'Brassicaceae')
download_peptides(seqs, 'oneKP/pep')
download_nucleotides(seqs, 'oneKP/nuc')
```

# Funding

Development of this R package was supported by the National Science Foundation under Grant No. IOS 1546858.

# Contributing

We welcome any contributions!

 * By participating in this project you agree to abide by the terms outlined in
   the [Contributor Code of Conduct](CONDUCT.md).

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
