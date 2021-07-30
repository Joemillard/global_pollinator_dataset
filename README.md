# Pollinator datasets and metadata descriptions

This repository contains the files used either in the process of searching pollinators, or the list of pollinators themselves. This repository does not contain the scripts used to merge the pollinators here with the PREDICTS database (for that script please see here https://github.com/Joemillard/Global_effects_of_land-use_intensity_on_local_pollinator-biodiversity/blob/main/R/01_PREDICTS_compilation.R), or data for the pollinator expert check (note that this was carried out on the PREDICTS subset alone). For the set of taxa that were either removed or added following the expert check please see Supplementary Data 1 in the Nat Comms paper, or in lines 167-190 of the above script. 

There are four key files in this repository:

* 'global_polllinating_confirmation_manual-edit.csv' is the original direct evidence csv aggregated from the output of the Ecography paper (i.e. any animal genus found in a pollination related abstract), editing following my initial check of abstracts. Each of the columns are described below: <br>
		-- 'aggregated.scientific_name.i.' refers to each of the unique found in the initial scrape <br>
		-- 'unique_class' refers to the taxonomic class of each genus <br>
		-- 'unique_order' refers to the taxonomic order of each genus<br>
		-- 'unique_family'	refers to the taxonomic family of each genus<br>
		-- 'unique_loc' refers to the set of unique Scopus IDs in which each genus was found<br>
		-- 'DOI_count'	refers to the number of abstracts in which that genus was found<br>
		-- 'unique_year'	refers to the set of unique years of the abstracts in which that genus was found<br>
		-- 'unique_name'	refers to the set of unique countries in which that genus was found<br>
		-- 'unique_level' refers to the set of unique levels at which that taxonomic record was matched with the Catalogue of Life (see Ecography paper)<br>
		-- 'Pollinating evidence/reference' is a binomial variable created on my initial pass through the abstracts fir each genus, in which I assigned a Yes/No for to indicate whether that genus is a likely pollinator<br>
		-- 'Pollinating confidence' refers to the direct level of confidence assigned for each 'Y' above (see Nat Comms paper)<br>

* 'confirmed_pollinating_families_04_edit' is the list of unique families with some evidence of pollination from the above direct evidence check, edited following my check of each family.
* 'clade_extrapolation_2.csv' is the set of taxa extrapolated as pollinators, prioritised through the initial text-analysis
* 'clade_extrapolation_non_text-analysis.csv' is the set of taxa extrapolated on the basis of Wardhaugh (2015), that didn't appear in the text analysis
* 'non_family-genus_species-list.csv' is the set of taxonomic names for groups that were not extrapolated at the family level (i.e. they cannot be easily merged with the PREDICTS database, so instead I searched for all the generic names and merged these instead).

Supplementary Data 2 of the Nat Comms paper contains a list of references used in 
