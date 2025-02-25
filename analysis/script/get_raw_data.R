# Grabbing data at a few different stages:
# 1. The "labelled" data - that is raw except the magic numbers are now words.
# 2. The processed data, at the stage before it goes to the MSK stats team for adding the derived variables.  Hence I'll call this "prederived".
# 3. The released consortium data.

library(synapser)
library(tidyverse)
library(here)

synLogin()


################
# Labeled data #
################

# The raw-raw data uses magic number coding. 
# We are downloading the "labelled" data which uses words.
# The transition between these two is part of Sage's processing, so 
#   it should be reproducible.
synGet(
  entity = "syn51318735",
  downloadLocation = here('data-raw', 'labeled')
)



##############
# Prederived #
##############

# This is the data at the stage before derived variables are added:
# (query from synapse at the link from Xindi:)
query <- synTableQuery("SELECT * FROM syn21446696 WHERE ( ( \"double_curated\" = 'false' ) AND ( \"table_type\" = 'data' ) )")
prederived <- read.table(
  query$filepath, 
  header = T,
  sep = ","
) %>%
  as_tibble %>%
  rename_all(tolower)

# try to create something like a reasonable file name.
# note that "form" is not unique so we can't use that.
prederived <- prederived %>%
  mutate(
    save_name = str_replace_all(tolower(name), ' ', '_')
  )

purrr::walk2(
  .x = prederived$id,
  .y = prederived$save_name,
  .f = \(x,y) {
    save_synapse_table_as_csv(
      synid = x,
      save_path = here('data-raw', 'prederived'),
      rename_to = y
    )
  }
)


###########
# Release #
###########

# Copying some code from the off label use manuscript.
datasets_to_get <- tribble(
  ~synapse_name, ~save_name,
  "cancer_level_dataset_index.csv", "ca_ind",
  "cancer_level_dataset_non_index.csv", "ca_non_ind",
  "cancer_panel_test_level_dataset.csv", "cpt",
  "patient_level_dataset.csv", "pt",
  "regimen_cancer_level_dataset.csv", "reg",
  "imaging_level_dataset.csv", "img'",
  "med_onc_note_level_dataset.csv", "med_onc",
  "pathology_report_level_dataset.csv", "path",
#  "tm_level_dataset.csv", "tm",
  'ca_radtx_dataset.csv', 'rad',
)

# A bit overkill todo this, but it does work:
release_folders <- tibble::tribble(
  ~cohort, ~synid,
  "NSCLC", "syn54107384", # 3.1 consortium
)

datasets_to_get <- release_folders %>%
  mutate(
    children = purrr::map(
      .x = synid,
      .f = (function(id) {
        dat <- get_syn_children_df(id) %>%
          # only need limited info for this project
          select(
            dat_name = name,
            dat_synid = id
          ) %>%
          filter(dat_name %in% dft_datasets_to_get$synapse_name)
        
        dat %<>% left_join(., dft_datasets_to_get,
                           by = c(dat_name = "synapse_name"))
        return(dat)
      })
    )
  ) %>%
  unnest(children)

release_save_helper <- function(synid) {
  synGet(
    entity = synid, 
    downloadLocation = here("data-raw", 'release'),
    ifcollision = "overwrite.local"
  )
}

purrr::walk(
  .x = datasets_to_get$dat_synid,
  .f = release_save_helper
)



