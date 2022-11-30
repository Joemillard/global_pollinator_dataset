### packages
library(dplyr)
library(here)

### read in the pollinator data and PREDICTS

# read in direct confidence dataframe and filter for Y
direct_confidence <- read.csv("C:/Users/joeym/Documents/PhD/Aims/Aim 2 - understand response to environmental change/Data/global clade extrapolation/global_polllinating_confirmation_manual-edit.csv", stringsAsFactors = FALSE)
direct_confidence <- direct_confidence %>%
  filter(Pollinating.evidence.reference == "Y")

# read in clade extrapolation dataframe, filter out subfamily and tribe, and seperate out genera into different dataframe
clade_extrapolation <- read.csv("C:/Users/joeym/Documents/PhD/Aims/Aim 2 - understand response to environmental change/Data/global clade extrapolation/clade_extrapolation_2.csv", stringsAsFactors = FALSE)

# seperate genera from extrapolation
clade_extrapolation_genera <- clade_extrapolation %>%
  filter(clade_rank == "genus")

# filter so just left with family level for extrapolation
clade_extrapolation <- clade_extrapolation %>%
  filter(clade_rank != "subfamily") %>%
  filter(clade_rank != "tribe") %>%
  filter(clade_rank != "genus")

# read in clade extrapolation non text-analysis
extrap_non_text_analysis <- read.csv("C:/Users/joeym/Documents/PhD/Aims/Aim 2 - understand response to environmental change/Data/global clade extrapolation/clade_extrapolation_non_text-analysis.csv", stringsAsFactors = FALSE)

# seperate genera from extrapolation
extrap_non_text_analysis_genera <- extrap_non_text_analysis %>%
  filter(clade_rank == "genus")

# filter so just left with family level for extrapolation
extrap_non_text_analysis <- extrap_non_text_analysis %>%
  filter(clade_rank == "family")

# read in non-family/tribe genus list
non_family_genus_list <- read.csv("C:/Users/joeym/Documents/PhD/Aims/Aim 2 - understand response to environmental change/Data/global clade extrapolation/non_family-genus_species-list.csv", stringsAsFactors = FALSE)

# read in the PREDICTS data, and create extra copy just with taxonomic data for size
PREDICTS <- readRDS("C:/Users/joeym/Documents/PhD/Aims/Aim 2 - understand response to environmental change/Data/PREDICTS/database.rds")
PREDICTS_taxa <- PREDICTS %>%
  select(Kingdom, Phylum, Class, Order, Family, Genus) %>%
  filter(Kingdom == "Animalia") %>%
  unique()

### remove blank spaces from end of all strings ***IMPORTANT - STILL TO DO 05/06/19 ***
PREDICTS_taxa$Family <- trimws(PREDICTS_taxa$Family)
PREDICTS_taxa$Genus <- trimws(PREDICTS_taxa$Genus)
non_family_genus_list$genus <- trimws(non_family_genus_list$genus)
non_family_genus_list$family <- trimws(non_family_genus_list$family)
direct_confidence$aggregated.scientific_name.i. <- trimws(direct_confidence$aggregated.scientific_name.i.)
direct_confidence$unique_family <- trimws(direct_confidence$unique_family)
extrap_non_text_analysis$family <- trimws(extrap_non_text_analysis$family)
extrap_non_text_analysis_genera$clade <- trimws(extrap_non_text_analysis_genera$clade)
extrap_non_text_analysis_genera$family <- trimws(extrap_non_text_analysis_genera$family)
clade_extrapolation$family <- trimws(clade_extrapolation$family)
clade_extrapolation_genera$family <- trimws(clade_extrapolation_genera$family)
clade_extrapolation_genera$clade <- trimws(clade_extrapolation_genera$clade)

### merge pollinator data with PREDICTS

# merge direct confidence, and then filter out those species from PREDICTS_taxa
PREDICTS_direct <- inner_join(PREDICTS_taxa, direct_confidence, by = c("Genus" = "aggregated.scientific_name.i."))
PREDICTS_direct <- droplevels(PREDICTS_direct)
PREDICTS_taxa_1 <- anti_join(PREDICTS_taxa, direct_confidence, by = c("Genus" = "aggregated.scientific_name.i."))

# merge PREDICTS_taxa_1 with direct confidence from clade extrapolation
PREDICTS_direct_2 <- inner_join(PREDICTS_taxa_1, clade_extrapolation_genera, by = c("Genus" = "clade"))
PREDICTS_direct_2 <- droplevels(PREDICTS_direct_2)
PREDICTS_taxa_2 <- anti_join(PREDICTS_taxa_1, clade_extrapolation_genera, by = c("Genus" = "clade"))

# merge PREDICTS_taxa_2 with direct_confidence from non-text-analysis
PREDICTS_direct_3 <- inner_join(PREDICTS_taxa_2, extrap_non_text_analysis_genera, by = c("Genus" = "clade"))
PREDICTS_direct_3 <- droplevels(PREDICTS_direct_3)
PREDICTS_taxa_3 <- anti_join(PREDICTS_taxa_2, extrap_non_text_analysis_genera, by = c("Genus" = "clade"))

# merge clade extrap pollinator data with PREDICTS, then filter out
PREDICTS_extrap <- inner_join(PREDICTS_taxa_3, clade_extrapolation, by = c("Family" = "family"))
PREDICTS_extrap <- droplevels(PREDICTS_extrap)
PREDICTS_taxa_4 <- anti_join(PREDICTS_taxa_3, clade_extrapolation, by = c("Family" = "family")) 

# merge clade extrap clade/subfamily with PREDICTS, then filter out
PREDICTS_extrap_2 <- inner_join(PREDICTS_taxa_4, non_family_genus_list, by = c("Genus" = "genus"))
PREDICTS_extrap_2 <- droplevels(PREDICTS_extrap_2)
PREDICTS_taxa_5 <- anti_join(PREDICTS_taxa_4, non_family_genus_list, by = c("Genus" = "genus"))

# merge clade extrap non text-analysis with PREDICTS, then filter out
PREDICTS_extrap_3 <- inner_join(PREDICTS_taxa_5, extrap_non_text_analysis, by = c("Family" = "family"))
PREDICTS_extrap_3 <- droplevels(PREDICTS_extrap_3)
PREDICTS_taxa_6 <- anti_join(PREDICTS_taxa_5, extrap_non_text_analysis, by = c("Family" = "family"))

# from the last set of species not identified as pollinators (PREDICTS_taxa_6), subset for the sawflies, Rhagonhycha,
# sawflies in predicts are the siricidae and the tenthredinidae
# and check that the masaridae and pompilidae are coming through
# rhagonhycha not in the remainder of the predicts data

# subset for the sawflies from the remainder of the species
PREDICTS_expert <- PREDICTS_taxa_6 %>% filter(Family %in% c("Siricidae", "Tenthredinidae", "Tabanidae")) %>%
  mutate(clade_rank = NA) %>%
  mutate(confidence = 5.4)

### combine together all genera from PREDICTS with confidence
# pollinat_dataframes
pollinat_dataframes <- list(PREDICTS_direct,
                            PREDICTS_direct_2,
                            PREDICTS_direct_3,
                            PREDICTS_extrap,
                            PREDICTS_extrap_2,
                            PREDICTS_extrap_3,
                            PREDICTS_expert)

# count row numbers in each pollinator predicts subset
for(i in 1:length(pollinat_dataframes)) {print(nrow(pollinat_dataframes[[i]]))}

# PREDICTS subsetting
predicts_subsets <- list(PREDICTS_taxa,
                         PREDICTS_taxa_1, 
                         PREDICTS_taxa_2, 
                         PREDICTS_taxa_3, 
                         PREDICTS_taxa_4, 
                         PREDICTS_taxa_5, 
                         PREDICTS_taxa_6)

# count row numbers pf each of PREDICTS subsets as pollinators removed
for(i in 1:length(predicts_subsets)) {print(nrow(predicts_subsets[[i]]))}

# rbind extrap and extrap_3
PREDICTS_extrap_1_3 <- rbind(PREDICTS_extrap, PREDICTS_extrap_3)
PREDICTS_extrap_1_3 <- PREDICTS_extrap_1_3 %>%
  select(-clade, -class, -order)

# rbind direct_2 and direct_3
PREDICTS_direct_2_3 <- rbind(PREDICTS_direct_2, PREDICTS_direct_3) %>%
  select(-class, -order, -family)

# rbind PREDICTS_extrap_1_3 and PREDICTS_direct_2_3
PREDICTS_bound <- rbind(PREDICTS_extrap_1_3, PREDICTS_direct_2_3)
PREDICTS_bound <- PREDICTS_bound %>%
  select(-additional_citations)

# remove 'clade' column from extrap_2
PREDICTS_extrap_2 <- PREDICTS_extrap_2 %>%
  select(-class, -order, -family, -clade)

# rbind PREDICTS_bound to PREDICTS_extrap_2
PREDICTS_bound_2 <- rbind(PREDICTS_bound, PREDICTS_extrap_2)

# select columns for PREDICTS_direct
PREDICTS_direct <- PREDICTS_direct %>%
  select(Kingdom, Phylum, Class, Order, Family, Genus, Pollinating.confidence) %>%
  rename("confidence" = "Pollinating.confidence") %>%
  mutate("clade_rank" = NA)

# bind direct_1 and final bound
PRED_fin_bound <- rbind(PREDICTS_bound_2, PREDICTS_direct)

# pollination expert adjustments to the set of pollinators in PREDICTS
# add in taxa that have been missed - the sawflies from Jeff
PRED_fin_bound_ex <- rbind(PRED_fin_bound, PREDICTS_expert)

# csv write for those that were removed/added
pollinator_save <- PRED_fin_bound_ex %>%
  dplyr::select(Phylum, Class, Order, Family, Genus) %>% 
  unique() %>%
  filter(Genus != "") %>%
  arrange(Phylum, Class, Order, Family, Genus)

# for any of those removed, kept, added indicate in new column
# added families
pollinator_save$status[pollinator_save$Family %in% c("Siricidae", "Tenthredinidae", "Tabanidae")] <- "ADDED"

# removed families
pollinator_save$status[pollinator_save$Family %in% c("Formicidae", 
                                                     "Coccinellidae", 
                                                     "Anthicidae", 
                                                     "Heleomyzidae", 
                                                     "Lygaeidae",  
                                                     "Mycetophilidae",
                                                     "Drosophilidae",
                                                     "Phoridae")] <- "REMOVED"

# removed genera
pollinator_save$status[pollinator_save$Genus %in% c(
  "Epichlorops", "Incertella", "Psilacrum", "Rhopalopterum", # chloropidae
  "Apatura", # lepidoptera
  "Aphanisticus", "Chrysobothris", "Melanophila", "Trachys", # Buprestidae 
  "Golinca", # Cetoniidae 
  "Dyacopterus", "Otopteropus", "Ptenochirus", # Pteropodidae 
  "Timeliopsis", # Meliphagidae 
  "Amazona", "Eclectus", "Psittacula", # Psittacidae
  "Galerella", "Martes", "Rattus")] <- "REMOVED"

# genera kept in
pollinator_save$status[is.na(pollinator_save$status)] <- "KEPT"

# save the csv for final set of pollinators as to whether added, removed etc
write.csv(pollinator_save, "pollinating_PREDICTS_genera.csv")

# remove any taxa that ecologists have suggested we remove
PRED_fin_bound_ex_2 <- PRED_fin_bound_ex %>%
  filter(!Family %in% c("Formicidae", 
                        "Coccinellidae", 
                        "Anthicidae", 
                        "Heleomyzidae", 
                        "Lygaeidae",  
                        "Mycetophilidae",
                        "Drosophilidae",
                        "Phoridae")) %>%
  filter(!Genus %in% c(
    "Epichlorops", "Incertella", "Psilacrum", "Rhopalopterum", # chloropidae
    "Apatura", # lepidoptera
    "Aphanisticus", "Chrysobothris", "Melanophila", "Trachys", # Buprestidae 
    "Golinca", # Cetoniidae 
    "Dyacopterus", "Otopteropus", "Ptenochirus", # Pteropodidae 
    "Timeliopsis", # Meliphagidae 
    "Amazona", "Eclectus", "Psittacula", # Psittacidae
    "Galerella", "Martes", "Rattus")) # carnivora/rodentia

### remerging pollinator back with predicts

# merge the pollinators in predicts with confidence back onto predicts data
PREDICTS_pollinators <- inner_join(PREDICTS, PRED_fin_bound_ex_2, by = c("Kingdom", "Phylum", "Class", "Order","Family", "Genus"))
PREDICTS_pollinators <- droplevels(PREDICTS_pollinators)

# save predicts pollinators as RDS
saveRDS(PREDICTS_pollinators, "outputs/PREDICTS_pollinators_8_exp.rds")