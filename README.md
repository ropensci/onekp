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

Smarter filters are coming soon
