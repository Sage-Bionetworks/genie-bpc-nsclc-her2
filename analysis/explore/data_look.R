library(tidyverse)
library(magrittr)


# Just keeping these for reference:

nsclc_lab %>% count(redcap_repeat_instance)
nsclc_lab %>% count(redcap_repeat_instrument) # That's the one.
nsclc_lab %>% count(redcap_data_access_group)
# This is interesting, the curator rows appear to be non-instrument rows.  This is such a mess.
nsclc_lab %>% filter(!is.na(redcap_repeat_instrument)) %>% count(cur_curator, redcap_repeat_instrument)

nsclc_lab %>% count(cur_cohort)
nsclc_lab %>% count(cur_activity)

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
# radiation conclusion: 



ca_dx_p1 <- read_csv(here(path_prederived, 'cancer_diagnosis_part_1.csv'))
ca_dx_p2 <- read_csv(here(path_prederived, 'cancer_diagnosis_part_2.csv'))
setdiff(names(ca_dx_p1), names(ca_dx_p2))
setdiff(names(ca_dx_p2), names(ca_dx_p1))
dim(ca_dx_p1)
dim(ca_dx_p2)



