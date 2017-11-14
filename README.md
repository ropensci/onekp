[![Travis-CI Build Status](https://travis-ci.org/arendsee/oneKP.svg?branch=master)](https://travis-ci.org/arendsee/oneKP)
[![Coverage Status](https://img.shields.io/codecov/c/github/arendsee/oneKP/master.svg)](https://codecov.io/github/arendsee/oneKP?branch=master)

# Access 1000 plants dataset

For info on this project see the 1KP [home page](https://sites.google.com/a/ualberta.ca/onekp/).

## Examples

Retrieve the protein and gene transcript FASTA files for two 1KP transcriptomes: 

``` R
onekp <- retrieve_oneKP()
seqs <- filter_by_code(onekp, c('URDJ', 'ROAP'))
download_proteins(seqs)
download_nucleotides(seqs)
```

This will create the following directory:

```
oneKP
 ├── Nucleotides
 │   ├── ROAP.fna
 │   └── URDJ.fna
 └── Peptides
     ├── ROAP.faa
     └── URDJ.faa
```

`oneKP` can also filter by species names, taxon ids, or clade.

```R
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

``` R
onekp <- retrieve_oneKP()
seqs <- filter_by_clade(onekp, 'Brassicaceae')
download_peptides(seqs)
download_nucleotides(seqs)
```

## Future Directions

I currently access the data by scraping URLs from an HTML table on the 1KP
website. It would be better to get the data from a more stable source. Luckily,
the 1KP data is managed by iPlant/CyVerse. Refactoring `onekp` to directly
access CyVerse would be a mostly internal change that should not affect the
API. It would, however, add an iRODs dependency and break portability to
Windows (good riddance).
