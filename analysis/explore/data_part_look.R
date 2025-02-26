library(tidyverse)
library(magrittr)

check_unique <- function(dat, col) {
  rows_orig <- nrow(dat)
  rows_unique <- dat %>%
    distinct(pick(all_of(col)), .keep_all = F) %>%
    nrow
  return(rows_orig == rows_unique)
}


# Questions I have initially:
# - what's up with all the "parts" of the data?
# - what's added and removed in the derived variables steps?

path_prederived <- here('data-raw', 'prederived')

rad_p1 <- read_csv(here(path_prederived, 'ca_directed_radtx_part_1.csv'))
rad_p2 <- read_csv(here(path_prederived, 'ca_directed_radtx_part_2.csv'))
rad_p3 <- read_csv(here(path_prederived, 'ca_directed_radtx_part_3.csv'))

rad_p1 %>% glimpse
rad_p2 %>% glimpse
rad_p3 %>% glimpse
# radiation conclusion: Only part_1 seems to have information.



ca_dx_p1 <- read_csv(here(path_prederived, 'cancer_diagnosis_part_1.csv'))
ca_dx_p2 <- read_csv(here(path_prederived, 'cancer_diagnosis_part_2.csv'))
setdiff(names(ca_dx_p1), names(ca_dx_p2))
setdiff(names(ca_dx_p2), names(ca_dx_p1))
intersect(names(ca_dx_p1), names(ca_dx_p2))
dim(ca_dx_p1)
dim(ca_dx_p2)

# Check that the datasets are all unique based on the
#   intersecting columns (excepting the synapse garbage).
map_lgl(
  .x = list(ca_dx_p1, ca_dx_p2),
  .f = \(x) { check_unique(
    x,
    col = c('cohort', 'record_id', 'redcap_repeat_instance')
  )}
)
# Conclusion:  There appears to be some unique data in both parts.  They have differing number of rows, but hopefully the same keys.  Cancer index is not a key in the second set though.







path_p1 <- read_csv(here(path_prederived, 'prissmm_pathology_part_1.csv'))
path_p2 <- read_csv(here(path_prederived, 'prissmm_pathology_part_2.csv')) # crc?
path_p3 <- read_csv(here(path_prederived, 'prissmm_pathology_part_3.csv')) # bladder?
path_p4 <- read_csv(here(path_prederived, 'prissmm_pathology_part_4.csv')) # breast?
path_p5 <- read_csv(here(path_prederived, 'prissmm_pathology_part_5.csv'))
path_p6 <- read_csv(here(path_prederived, 'prissmm_pathology_part_6.csv'))
purrr::reduce(
  .f = intersect, 
  .x = list(
    names(path_p1),
    names(path_p2),
    names(path_p3),
    names(path_p4),
    names(path_p5),
    names(path_p6)
  )
)

check_unique <- function(dat, col) {
  rows_orig <- nrow(dat)
  rows_unique <- dat %>%
    distinct(pick(all_of(col)), .keep_all = F) %>%
    nrow
  return(rows_orig == rows_unique)
}

# Check that the datasets are all unique based on the
#   intersecting columns (excepting the synapse garbage).
map_lgl(
  .x = list(path_p1, path_p2, path_p3, path_p4, path_p5, path_p6),
  .f = \(x) { check_unique(
    x,
    col = c('cohort', 'record_id', 'redcap_repeat_instance')
  )}
)
# Conclusion: Unique data in all 6 parts.  They went really wide with this dataset, it's a very sparse fill.  The unique keys are shared between datasets.

# In all parts I'm not sure that redcap repeat instance is meaningful, but it's there if it is.
  
  
  


