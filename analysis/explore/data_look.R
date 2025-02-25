library(tidyverse)
library(magrittr)

# _lab for labelled, meaning it uses words rather than magic numbers.
nsclc_lab <- readr::read_csv(
  here('data', 'NSCLC2BPCIntake_data.csv')
)

nsclc_lab %>% select(1:10) %>% glimpse

nsclc_lab %>% count(redcap_repeat_instance)
nsclc_lab %>% count(redcap_repeat_instrument) # That's the one.
nsclc_lab %>% count(redcap_data_access_group)
# This is interesting, the curator rows appear to be non-instrument rows.  This is such a mess.
nsclc_lab %>% filter(!is.na(redcap_repeat_instrument)) %>% count(cur_curator, redcap_repeat_instrument)

nsclc_lab %>% count(cur_cohort)
nsclc_lab %>% count(cur_activity)

