# Pollinator datasets and metadata descriptions

This repository contains the files used either in the process of searching pollinators, or the list of pollinators themselves. This repository does not contain the scripts used to merge the pollinators here with the PREDICTS database (for that script please see here https://github.com/Joemillard/Global_effects_of_land-use_intensity_on_local_pollinator-biodiversity/blob/main/R/01_PREDICTS_compilation.R), or data for the pollinator expert check (note that this was carried out on the PREDICTS subset alone). For the set of taxa that were either removed or added following the expert check please see Supplementary Data 1 in the Nat Comms paper, or in lines 167-190 of the above script. The Nat Comms paper also contains a set of references used in my extrapolation process of pollination.

There are five key files in this repository:

* 'global_polllinating_confirmation_manual-edit.csv' is the original direct evidence csv aggregated from the output of the Ecography paper (i.e. any animal genus found in a pollination related abstract), editing following my initial check of abstracts. Each of the columns are described below: <br>
		-- 'aggregated.scientific_name.i.' refers to each of the unique genera found in the initial scrape <br>
		-- 'unique_class' refers to the taxonomic class of each genus<br>
		-- 'unique_order' refers to the taxonomic order of each genus<br>
		-- 'unique_family' refers to the taxonomic family of each genus<br>
		-- 'unique_loc' refers to the set of unique Scopus IDs in which each genus was found<br>
		-- 'DOI_count' refers to the number of abstracts in which that genus was found<br>
		-- 'unique_year' refers to the set of unique years of the abstracts in which that genus was found<br>
		-- 'unique_name' refers to the set of unique countries in which that genus was found<br>
		-- 'unique_level' refers to the set of unique levels at which that taxonomic record was matched with the Catalogue of Life (see Ecography paper)<br>
		-- 'Pollinating evidence/reference' is a binomial variable created on my initial pass through the abstracts for each genus, in which I assigned a Yes/No to indicate whether that genus is a likely pollinator<br>
		-- 'Pollinating confidence' refers to the direct level of confidence assigned for each 'Y' above (see Nat Comms paper)<br>

* 'confirmed_pollinating_families_04_edit' is the list of unique families with some evidence of pollination from the above direct evidence check, edited following my check of each family. Each of the columns are described below: <br>
		-- 'class' refers to the taxonomic class of each unique family with some direct evidence of pollination<br>
		-- 'order' refers to the taxonomic order of each unique family with some direct evidence of pollination<br> 
		-- 'family' refers to the taxonomic family of each unique family with some direct evidence of pollination<br>	
		-- 'species' refers to the number of species in total that family<br>	
		-- 'scraped' refers to the number of unique species of that family found in the initial taxonomic scrape<br>	
		-- 'prop' refers to the proportion of species in that family with evidence (i.e. 'scraped'/'species')<br>
		-- 'family_checked' indicates that JM has check that family<br>
		-- 'extrapolated' indicates whether that family (or a tribe/subfamily within that family) was extrapolated as pollinating<br>

* 'clade_extrapolation_2.csv' is the set of taxa extrapolated as pollinators, prioritised through the initial text-analysis. Any taxa here assigned a value of direct confidence is one for which I found direct evidence at the genus level whilst searching for evidence to extrapolate. Each of the columns are described below: <br>
		-- 'class' refers to the taxonomic class of each extrapolated group<br>	
		-- 'order' refers to the taxonomic order of each extrapolated group<br>		
		-- 'family' refers to the taxonomic family of each extrapolated group<br>		
		-- 'clade' refers to the taxonoic group extrapolated<br>	
		-- 'clade_rank'	refers to the taxonomic level of the extrapolated group<br>
		-- 'confidence' refers to the confidence at which that group was extrapolated (see Nat Comms paper for more details)<br>
		-- 'additional_citations' refers to any additional references used in making the decision to extrapolate<br>

* 'clade_extrapolation_non_text-analysis.csv' is the set of taxa extrapolated on the basis of Wardhaugh (2015), that didn't appear in the text analysis. Columns here take the same format as above.

* 'non_family-genus_species-list.csv' is the set of taxonomic names for groups that were not extrapolated at the family level (i.e. they cannot be easily merged with the PREDICTS database, so instead I searched for all the generic names and merged these instead). Each of the columns are described below: <br>
		-- class refers to the taxonomic class of that extrapolated non family group<br>
		-- order refers to the taxonomic order	of that extrapolated non family group<br>
		-- family refers to the taxonomic family of that extrapolated non family group<br>	
		-- clade refers to the extrapolated non-family group<br> 	
		-- clade_rank refers to the level at which that group was extrapolated<br>	
		-- genus refers to the names of the genera within those non-family groups, used to match against PREDICTS<br>	
		-- confidence refers to the confidence at which that non-family group was extrapolated.<br>
