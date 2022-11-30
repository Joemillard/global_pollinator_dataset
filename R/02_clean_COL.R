## script for cleaning the COL taxonomic download - i.e. removing the author names and subsetting for animals

# vector for the packages to install 
packages <- c("dplyr", "stringr", "data.table")

# packages to read in
library(dplyr)
library(stringr)
library(data.table)

### function for removing author column from the scientific name column
species <- function(taxa_data, count){
  
  # create a list
  data <- list()  
  
  # iterate over the number of counts defined as an argument
  for (i in 1:count){
    
    # catch errors
    tryCatch({
      
      # whenever see the pattern of author in scientific name, remove it, make a dataframe from rows at that iteration, save to list
      temp <- gsub(taxa_data$scientificNameAuthorship[i], "", taxa_data$scientificName[i])
      temp_spec <- data.frame(temp, taxa_data$kingdom[i], taxa_data$class[i], taxa_data$order[i], taxa_data$scientificNameAuthorship[i], taxa_data$family[i], taxa_data$..taxonID[i], taxa_data$acceptedNameUsageID[i], taxa_data$parentNameUsageID[i], taxa_data$taxonomicStatus[i])
      data[[i]] <- temp_spec
      
      # print iteration number when error encountered
    }, error = function(x) print(c(i, taxa_data$scientificName[i])))
  }
  
  # bind the data lists and return the final bound object 
  species_names <- rbindlist(data)
  return(species_names)
}

# download and read in 2017 catalogue of life data
taxa <- read.delim("data/inputs/2017_catalogue_of_life.txt", stringsAsFactors=FALSE, quote = "")

# clean data - seleting the appropriate columns and filtering for animals
new_taxa <- taxa %>%
  dplyr::rename(..taxonID = ï..taxonID) %>%
  dplyr::select(taxonRank, scientificName, kingdom, class, scientificNameAuthorship, order, family,..taxonID, acceptedNameUsageID, parentNameUsageID, taxonomicStatus) %>%
  filter(kingdom == "Animalia")

# remove punctutation and special charactes from species and author columns
new_taxa$scientificNameAuthorship <- gsub("[[:punct:]]", "", new_taxa$scientificNameAuthorship)
new_taxa$scientificName <- gsub("[[:punct:]]", "", new_taxa$scientificName)

# run function and time it - remove the author information from the species column
system.time({
  species_names <- species(taxa_data = new_taxa, count = nrow(new_taxa))
})

# save as rds file
saveRDS(species_names, "data/inputs/2017_catalogue_of_life_cleaned.rds")