# Access 1000 plants dataset

For info on the 1000 plant proteome project see the project [home page](https://sites.google.com/a/ualberta.ca/onekp/)

If you use this package, please cite the [1KP papers](https://sites.google.com/a/ualberta.ca/onekp/papers-to-cite).

## Examples

Retrieve the protein and gene transcript FASTA files for two 1KP transcriptomes: 

``` R
onekp <- retrieve_oneKP()
seqs <- filter_by_code(onekp, c('URDJ', 'ROAP'))
retrieve_proteins(seqs)
retrieve_nucleotides(seqs)
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

`oneKP` can also filter by species names, taxon ids, or ancestor.

```R
# filter by species name
filter_by_species(onekp, 'Pinus radiata')

# filter by species NCBI taxon ID
filter_by_taxid(onekp, 3347)

# filter by ancestor name scientific name (get all data for the Brassicaceae family)
filter_by_ancestor_name(onekp, 'Brassicaceae')

# filter by ancestor NCBI taxon ID
filter_by_ancestor_id(onekp, 3700)
```

So to get the protein sequences for all species in Brassicaceae:

``` R
onekp <- retrieve_oneKP()
seqs <- filter_by_ancestor_name(onekp, 'Brassicaceae')
retrieve_proteins(seqs)
retrieve_nucleotides(seqs)
```
