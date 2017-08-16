# Methods

All code that was used for pre-processing the data as well as the r-shiny application is available on github.
Preprocessing: https://github.com/AlastairKerr/DereticWelburnPreprocessingScripts
R-Shiny application: https://github.com/AlastairKerr/DereticWelburnApp

## Data sources
Protein sequences of Human, Zebrafish and Chicken were downloaded from Ensembl version 82.  Ensembl Biomart was used to extract the orthlolog relationship between the three species as well as GO terms for all the human genes.

## Reactome (version 55)
was used to extracted genes involved in mitotis pathways.

## Prosite patterns used to search protein sequences

```
 1. [RK][RK]x[TS][FAST]
 2. [RK][RK]x[TS][ILVM] 
 3. [RK][RK][TS][FAST]
 4. [RK][RK][TS][ILVM]
 5. [RK][RK][RK][TS][ILVM]
 6. [RK][RK][RK][TS][FAST]
 7. {RK}[RK]{RK}[TS][FAST]
 8. {RK}[RK]{RK}[TS][ILVM]

```

# Software

fuzzpro from the EMBOSS suite (version 6.6.0.0) was used to find matches to patterns in each of the 3 peptide datasets. Needle from the same suite was used to calculate the percentage identity between all possible pairwise regions that contained pattern matches in orthologous proteins and the highest identity per pair was recorded.

## iupred 
was used to calculate the likelihood for an amino acid to be disordered in a region between pattern match start sites.  Amino acids that had values over 0.5 were counted within  regions that were 50amino acids either side of pattern match start site. The largest such region that was less than 300 amino acids between pattern match start sites was reported.

## samtools (version 0.1.19 )
was used to both index and retrieve sequences from the fasta files.

##Shiny Application
The R-Shiny application can be launched in any R session with an installed shiny package using the commands.
```{r}
	library(shiny)
	runGitHub("DereticWelburnApp", “AlastairKerr")
```

The interface produces a table for proteins that match at least one of the prosite patterns in each of the three ortholgs. Additional filters can be applied to the number of pattern matches in a set protein region, data based on the percentage of amino acids predicted to be in disorder in the region, the maximum identity between two pattern containing regions in orthlogous proteins, and annotations to select Gene Ontology terms or mitosis pathways.
