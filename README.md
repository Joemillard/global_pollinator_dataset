# A global dataset of likely animal pollinators

### Introduction

This repository contains a set of input files for generating a set of likely animal pollinators in either the PREDICTS database or some set of taxonomic data (e.g. the Catalogue of Life). Each of the input files is the result of a search process for animal pollinators documented in Millard et al. (2021) (see metadata for a description of these files), which builds on the automated algorithms described in Millard et al. (2020) The two output files here are generated by merging each of the inputs (in a particular order according to pollination confidence) with either the PREDICTS database or the Catalogue of Life (i.e. they generate a set of likely pollinators in either of these datasets). 

Note also that the PREDICTS code included here removes a set of species that were deemed by experts unlikely to represent pollinators. The Catalogue of Life subset has not been checked in this manner meaning it should be treated with caution.

It's also important to note that the input files should not be treated as a list of pollinators at species level. These input files are intended for merging with taxonomic lists to generate species lists of pollinators:

- To generate the set of likely pollinators in the PREDICTS database (i.e. data/outputs/07_PREDICTS_pollinators_exp.rds) run R/01_PREDICTS_pollinators.R. For the set of taxa that were either removed or added following the expert check please see lines 168-214 (also see Supplementary Data 1 in Millard et al. 2021 for the set of taxa removed, and for the set of references used in my extrapolation of likely animal pollination).

- To generate the set of likely pollinating species in the Catalogue of Life (i.e. data/outputs/06_COL_compiled_pollinators.rds) run R/03_COL_pollinators.R. For this script you will need to have downloaded a copy of the COL from here https://www.catalogueoflife.org/data/download. Note that the 2017 COL will first require cleaning up with a script such as R/02_clean_COL.R. When merging with the COL it's important to be wary of duplicating species names. 

------------

### References

Millard, J.W., Freeman, R. and Newbold, T., 2020. Text‐analysis reveals taxonomic and geographic disparities in animal pollination literature. Ecography DOI: https://doi.org/10.1111/ecog.04532

Millard, J., Outhwaite, C.L. , Kinnersley, R., Freeman, R., Gregory, R.D., Adedoja, O., Gavini, S., Kioko, E., Kuhlmann, M., Ollerton, J. and Ren, Z.X., 2021. Global effects of land-use intensity on local pollinator biodiversity. Nature communications DOI: https://www.nature.com/articles/s41467-021-23228-3

------------

### License

This code is licensed under an MIT license, granting any person obtaining a copy of this software and associated documentation files, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The copyright notice and this permission notice (see 'LICENSE') are included in all copies or substantial portions of the Software. 

------------

### Acknowledgements

J.M. was funded by the London NERC DTP—award number NE/R012148/1—and the RSPB on a CASE studentship. This work was supported by a grant from the UK Natural Environment Research Council (grant ref. NE/R010811/1) and by a Royal Society University Research Fellowship awarded to T.N.
