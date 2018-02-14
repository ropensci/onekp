[![Travis-CI Build Status](https://travis-ci.org/arendsee/onekp.svg?branch=master)](https://travis-ci.org/arendsee/onekp)
[![Coverage Status](https://img.shields.io/codecov/c/github/arendsee/onekp/master.svg)](https://codecov.io/github/arendsee/onekp?branch=master)
[![](https://badges.ropensci.org/178_status.svg)](https://github.com/ropensci/onboarding/issues/178)

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

## Installation


```r
library(devtools)
install_github('arendsee/onekp')
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


## Caveats

The dataset is a little dirty.

I attempt to map species to NCBI taxonomy IDs, but this fails for 95 out of
1171 taxa. Many of the species are either ambiguous or pool data across species
(e.g. *Hemerocallis sp.*). Worse, some are mis-named: "Kalanchoe
crenato-diagremontiana", which presumably refers to *Kalanchoe crenato* and the
sister species *Kalanchoe daigremontiana* (which they misspelled). Others are
just weird:

 * *Ettlia(?) oleoabundans*
 * *coccoid-prasinophyt*
 * *Ribes aff. giraldii* - *Rives giraldii* is a species, but what is *aff.*?

Others use names that are not from the NCBI taxonomy, e.g.

 * *Tribulus eichlerianus*
 * *Chlorochytridion tuberculata*
 * *Oenothera suffulta suffulta* - *Oenothera suffulta* is in NCBI common tree

Another issue is inconsistency in tissue naming.

The tissue column is of great biological importance and but is unfortunately
not very well standardized. For example, the following tissue types are included:

 1. young leaf AND shoot
    - 'young leaves and shoot'
    - 'young leaves and shoots'
 2. leaf
    - 'leaf'
    - 'Leaf'
    - 'leaves'
 3. leaf AND flower
    - 'leaf and flower'
    - 'leaves and flowers'
 4. flower AND stem AND leaf


```r
library(onekp)
onekp <- retrieve_onekp()
onekp@table %>%
    subset(grepl('lea[vf]', tissue, ignore.case=TRUE, perl=TRUE)) %>%
    subset(grepl('stem', tissue, ignore.case=TRUE)) %>%
    subset(grepl('flower', tissue, ignore.case=TRUE)) %>%
    subset(!grepl('bud|fruit|young|apex|devel', tissue, ignore.case=TRUE, perl=TRUE)) %$%
    tissue %>% unique %>% sort
```

```
##  [1] "flower, stem, leaves"   "flowers, leaves, stem" 
##  [3] "flowers, leaves, stems" "flowers, stem, leaves" 
##  [5] "flowers, stems, leaves" "leaf, stem, flower"    
##  [7] "leaf, stem, flowers"    "leaves, stem, flower"  
##  [9] "leaves, stem, flowers"  "leaves,stem, flowers"
```

Additionally, many of the entries are entirely missing a tissue annotation or
the annotation appears to be truncated (e.g. 'the little turrets (so mix of
young sporoph').

Making sense of all this would require either actually reading the tissue
annotations or performing fancy computational linguistics.

# Contributing

We welcome any contributions!

 * By participating in this project you agree to abide by the terms outlined in
   the [Contributor Code of Conduct](CONDUCT.md).


# Funding

This material is based upon work supported by the National Science Foundation under Grant No. IOS 1546858
