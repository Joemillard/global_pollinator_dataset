### packages
library(dplyr)
library(stringr)
library(forcats)

### read in the pollinator data and COL

# read in direct confidence dataframe and filter for Y
direct_confidence <- read.csv("data/inputs/01_global_polllinating_confirmation_manual-edit.csv", stringsAsFactors = FALSE)
direct_confidence <- direct_confidence %>%
  filter(Pollinating.evidence.reference == "Y")

# read in clade extrapolation dataframe, filter out subfamily and tribe 
clade_extrapolation <- read.csv("data/inputs/03_clade_extrapolation.csv", stringsAsFactors = FALSE)

# seperate out genera into different dataframe
clade_extrapolation_genera <- clade_extrapolation %>%
  filter(clade_rank == "genus")

# and then filter out family
clade_extrapolation <- clade_extrapolation %>%
  filter(clade_rank != "subfamily") %>%
  filter(clade_rank != "tribe") %>%
  filter(clade_rank != "genus")

# read in clade extrapolation non text-analysis
extrap_non_text_analysis <- read.csv("data/inputs/04_clade_extrapolation_non_text-analysis.csv", stringsAsFactors = FALSE)

# seperate genera from extrapolation
extrap_non_text_analysis_genera <- extrap_non_text_analysis %>%
  filter(clade_rank == "genus")

# filter so just left with family level for extrapolation
extrap_non_text_analysis <- extrap_non_text_analysis %>%
  filter(clade_rank == "family")

# read in non-family/tribe genus list
non_family_genus_list <- read.csv("data/inputs/05_non_family-genus_species-list.csv", stringsAsFactors = FALSE)

# read in COL animal data - NEED TO READ IN DATAFRAME AFTER CORRECTING FOR WHOLE COL (12/11/2019)
unique_col <- readRDS("~/PhD/Aims/Aim 1 - collate pollinator knowledge/Data/Taxonomic data/2017-annual/cleaned/unique_COL_species_03.rds")

"data/inputs/2017_catalogue_of_life_cleaned.rds"

# subset for unique species
COL_taxa <- unique_col %>%
  rename(scientific_name = temp) %>%
  mutate_all(as.character) %>%
  filter(taxa_data.family.i. != "Not assigned") %>%
  filter(taxa_data.taxonomicStatus.i. == "accepted name") %>%
  select(scientific_name, taxa_data.class.i., taxa_data.order.i., taxa_data.family.i., taxa_data.taxonomicStatus.i.) %>%
  group_by(scientific_name) %>%
  unique() %>%
  ungroup() %>%
  mutate(scientific_name = stringr::word(scientific_name, 1, 2)) %>%
  mutate(genus = stringr::word(scientific_name, 1, 1)) %>%
  rename(Family = taxa_data.family.i.) %>%
  rename(Class = taxa_data.class.i.) %>%
  rename(Order = taxa_data.order.i.) %>%
  mutate(Family = trimws(Family)) %>%
  mutate(genus = trimws(genus))

### remove blank spaces from end of all strings
non_family_genus_list$genus <- trimws(non_family_genus_list$genus)
non_family_genus_list$family <- trimws(non_family_genus_list$family)
non_family_genus_list$clade <- trimws(non_family_genus_list$clade)
direct_confidence$aggregated.scientific_name.i. <- trimws(direct_confidence$aggregated.scientific_name.i.)
direct_confidence$unique_family <- trimws(direct_confidence$unique_family)
extrap_non_text_analysis$family <- trimws(extrap_non_text_analysis$family)
extrap_non_text_analysis$clade <- trimws(extrap_non_text_analysis$clade)
extrap_non_text_analysis_genera$clade <- trimws(extrap_non_text_analysis_genera$clade)
extrap_non_text_analysis_genera$family <- trimws(extrap_non_text_analysis_genera$family)
clade_extrapolation$family <- trimws(clade_extrapolation$family)
clade_extrapolation_genera$family <- trimws(clade_extrapolation_genera$family)
clade_extrapolation_genera$clade <- trimws(clade_extrapolation_genera$clade)

### merge pollinator data with COL

# merge direct confidence, and then filter out those species from COL_taxa
COL_direct <- inner_join(COL_taxa, direct_confidence, by = c("genus" = "aggregated.scientific_name.i.", "Family" = "unique_family"))
COL_direct <- droplevels(COL_direct)
COL_taxa_1 <- anti_join(COL_taxa, direct_confidence, by = c("genus" = "aggregated.scientific_name.i.", "Family" = "unique_family"))

# merge COL_taxa_1 with direct confidence from clade extrapolation
COL_direct_2 <- inner_join(COL_taxa_1, clade_extrapolation_genera, by = c("genus" = "clade", "Family" = "family"))
COL_direct_2 <- droplevels(COL_direct_2)
COL_taxa_2 <- anti_join(COL_taxa_1, clade_extrapolation_genera, by = c("genus" = "clade", "Family" = "family"))

# merge COL_taxa_2 with direct_confidence from non-text-analysis
COL_direct_3 <- inner_join(COL_taxa_2, extrap_non_text_analysis_genera, by = c("genus" = "clade", "Family" = "family"))
COL_direct_3 <- droplevels(COL_direct_3)
COL_taxa_3 <- anti_join(COL_taxa_2, extrap_non_text_analysis_genera, by = c("genus" = "clade", "Family" = "family"))

# merge clade extrap pollinator data with COL, then filter out
COL_extrap <- inner_join(COL_taxa_3, clade_extrapolation, by = c("Family" = "family"))
COL_extrap <- droplevels(COL_extrap)
COL_taxa_4 <- anti_join(COL_taxa_3, clade_extrapolation, by = c("Family" = "family")) 

# merge clade extrap clade/subfamily with COL, then filter out
COL_extrap_2 <- inner_join(COL_taxa_4, non_family_genus_list, by = c("genus" = "genus", "Family" = "family"))
COL_extrap_2 <- COL_extrap_2 %>%
  droplevels() %>%
  rename("subfamily/tribe" = "clade")
COL_taxa_5 <- anti_join(COL_taxa_4, non_family_genus_list, by = c("genus" = "genus", "Family" = "family"))

# merge clade extrap non text-analysis with COL, then filter out
COL_extrap_3 <- inner_join(COL_taxa_5, extrap_non_text_analysis, by = c("Family" = "family"))
COL_extrap_3 <- droplevels(COL_extrap_3)
COL_taxa_6 <- anti_join(COL_taxa_5, extrap_non_text_analysis, by = c("Family" = "family"))

### combine together all genera from COL with confidence

# rbind extrap and extrap_3
COL_extrap_1_3 <- rbind(COL_extrap, COL_extrap_3)
COL_extrap_1_3 <- COL_extrap_1_3 %>%
  select(-clade)

# rbind direct_2 and direct_3
COL_direct_2_3 <- rbind(COL_direct_2, COL_direct_3)

# rbind COL_extrap_1_3 and COL_direct_2_3
COL_bound <- rbind(COL_extrap_1_3, COL_direct_2_3)
COL_bound <- COL_bound %>%
  select(-additional_citations) %>%
  mutate("subfamily/tribe" = NA)

# rbind COL_bound to COL_extrap_2
COL_bound_2 <- rbind(COL_bound, COL_extrap_2)

# remove extra columns from COL_bound
COL_bound_2 <- COL_bound_2 %>%
  select(-class, -order, -taxa_data.taxonomicStatus.i.)

# select columns for COL_direct
COL_direct <- COL_direct %>%
  select(scientific_name, Class, Order, Family, genus, Pollinating.confidence) %>%
  rename("confidence" = "Pollinating.confidence") %>%
  mutate("clade_rank" = NA) %>%
  mutate("subfamily/tribe" = NA)

# bind direct_1 and final bound
COL_fin_bound <- rbind(COL_bound_2, COL_direct)

# unique species
COL_fin_bound <- COL_fin_bound %>%
  filter(!is.na(scientific_name)) %>%
  group_by(scientific_name) %>%
  unique() %>%
  ungroup()

# merge COL_fin_bound with other tribes and subfamilies
COL_fin_bound_2 <- full_join(COL_fin_bound, non_family_genus_list, by = c("genus", "Family" = "family"))

# remove unnecesary columns
COL_fin_bound_2 <- COL_fin_bound_2 %>%
  dplyr::select(-confidence.y, -order, -class) %>%
  filter(!is.na(scientific_name)) %>%
  mutate(clade_rank = paste(clade_rank.x, clade_rank.y)) %>%
  mutate(clade_new = paste(`subfamily/tribe`, clade)) %>%
  mutate(clade_rank = factor(clade_rank, levels = unique(COL_fin_bound_2$clade_rank))) %>%
  mutate(clade_rank  = fct_recode(clade_rank, "family" = "family NA", 
                                  "NA" = "genus NA", 
                                  "tribe" = "genus tribe", 
                                  "NA" = "NA NA", 
                                  "subfamily" = "NA subfamily", 
                                  "tribe" = "NA tribe", 
                                  "subfamily" = "subfamily subfamily",
                                  "tribe" = "tribe tribe")) %>%
  mutate(clade_rank = as.character(clade_rank)) %>%
  mutate(clade_new = gsub("NA ", "", clade_new)) %>%
  mutate(clade_new = factor(clade_new, levels = unique(COL_fin_bound_2$clade_new))) %>%
  mutate(clade_new  = fct_recode(clade_new, "Agaoninae" = "Agaoninae Agaoninae", 
                                 "Clerinae" = "Clerinae Clerinae", 
                                 "Drepanidini" = "Drepanidini Drepanidini", 
                                 "Eristalinae" = "Eristalinae Eristalinae", 
                                 "Glossophaginae" = "Glossophaginae Glossophaginae", 
                                 "Hemignathini" = "Hemignathini Hemignathini", 
                                 "Kradibiinae" = "Kradibiinae Kradibiinae",
                                 "Lepturini" = "Lepturini Lepturini",
                                 "Loriini" = "Loriini Loriini",
                                 "Pangoniinae" = "Pangoniinae Pangoniinae",
                                 "Phyllonycterinae" = "Phyllonycterinae Phyllonycterinae",
                                 "Syrphinae" = "Syrphinae Syrphinae")) %>%
  mutate(clade_new = as.character(clade_new))

# switch "NA" for NA
COL_fin_bound_2$clade_new[COL_fin_bound_2$clade_new == "NA"] <- NA
COL_fin_bound_2$clade_rank[COL_fin_bound_2$clade_rank == "NA"] <- NA

### second confidence layer for number of papers for each tribe/family ###

## count number of genera for each grouping from clade extrapolation
COL_taxa_sub <- full_join(COL_taxa, non_family_genus_list, by = c("Family" = "family", "genus" = "genus"))

# count number of genera for each grouping - using all unique COL
no_spec_2 <- COL_taxa_sub %>%
  select(-scientific_name, -class, -order, -clade_rank, -confidence) %>%
  unique() %>%
  group_by(Family, clade) %>%
  tally() %>%
  ungroup() %>%
  rename("col_genera" = "n")

## count papers for each clade ##
# identify all genera from extrapolated lists
tribe_genus <- non_family_genus_list %>%
  select(family, clade, genus) %>%
  unique()

# combine direct confidence with tribe-family data
dir_conf_tribe <- full_join(direct_confidence, tribe_genus, by = c("aggregated.scientific_name.i." = "genus", "unique_family" = "family"))

# select only columns needed for number of papers in each clade
dir_conf_tribe <- dir_conf_tribe %>%
  select(aggregated.scientific_name.i., unique_family, DOI_count, clade)

# count number of papers for each clade
clade_papers <- dir_conf_tribe %>%
  filter(!is.na(DOI_count)) %>%
  group_by(unique_family, clade) %>%
  summarise(sum(DOI_count)) %>%
  ungroup()

# tally number of genera in direct scrape
dir_conf_genera <- dir_conf_tribe %>%
  filter(!is.na(DOI_count)) %>%
  group_by(unique_family, clade) %>% 
  tally() %>%
  ungroup() %>%
  rename("scraped_genera" = "n")

# merge the number of papers and genera together
pap_gen <- full_join(dir_conf_genera, clade_papers, by = c("unique_family", "clade"))

## merge species counts and number of papers into main dataframe ##
spec_paper <- full_join(pap_gen, no_spec_2, by = c("unique_family" = "Family", "clade" = "clade"))

# calculate the confidence metric
spec_paper <- spec_paper %>%
  mutate(gen_prop = scraped_genera / col_genera) %>%
  mutate(DOI_total = sum(`sum(DOI_count)`, na.rm = TRUE)) %>%
  mutate(DOI_prop = `sum(DOI_count)` / DOI_total) %>%
  mutate(add_conf = gen_prop * DOI_prop) %>%
  mutate(fact_conf = NA)

# create new factor for percentile confidence
spec_paper$fact_conf[spec_paper$add_conf <= quantile(spec_paper$add_conf, 0.25, na.rm = TRUE)] <- "0-25"
spec_paper$fact_conf[(spec_paper$add_conf > quantile(spec_paper$add_conf, 0.25, na.rm = TRUE)) & (spec_paper$add_conf <= quantile(spec_paper$add_conf, 0.5, na.rm = TRUE))] <- "25-50"
spec_paper$fact_conf[(spec_paper$add_conf > quantile(spec_paper$add_conf, 0.5, na.rm = TRUE)) & (spec_paper$add_conf <= quantile(spec_paper$add_conf, 0.75, na.rm = TRUE))] <- "50-75"
spec_paper$fact_conf[(spec_paper$add_conf > quantile(spec_paper$add_conf, 0.75, na.rm = TRUE)) & (spec_paper$add_conf <= quantile(spec_paper$add_conf, 1, na.rm = TRUE))] <- "75-100"

# change the names of the factor levels for confidence
spec_paper <- spec_paper %>%
  mutate(fact_conf = factor(fact_conf, levels = unique(spec_paper$fact_conf))) %>%
  mutate(fact_conf  = fct_recode(fact_conf,  "d" = "0-25",
                                 "c" = "25-50",
                                 "b" = "50-75",
                                 "a" = "75-100")) %>%
  select(-scraped_genera, -`sum(DOI_count)`, -col_genera, -DOI_total)

# make direct confidence for COL_fin_bound 
direct <- COL_fin_bound %>%
  filter(confidence %in% c(1, 2, 3, 4)) %>%
  mutate(fact_conf = NA) %>%
  mutate(DOI_prop = NA) %>%
  mutate(gen_prop = NA) %>% 
  mutate(add_conf = NA) %>%
  mutate(fact_conf = NA)

# make extrapolated confidence dataframe for COL_fin_bound
extrap <- COL_fin_bound %>%
  filter(confidence %in% c(5.1, 5.2, 5.3, 5.4))

# join the extrapolated dataframe onto new confidence score
COL_fin_bound_conf <- inner_join(extrap, spec_paper, by = c("Family" = "unique_family", "subfamily/tribe" = "clade"))

# rbind the direct back onto the extrapolated taxa
fin_conf <- rbind(COL_fin_bound_conf, direct)

# write the final file to csv
saveRDS(fin_conf, "06_COL_compiled_pollinators.rds")