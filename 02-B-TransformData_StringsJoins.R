#**** TRANSFORMING DATA - PART B****#
#**** String functions and joining tables

#load the packages we'll need
library(tidyverse)
library(lubridate)
library(janitor)
  
# load in data of prez candidate campaign trips - we'll get back to this in a minute
events <- readRDS("events_saved.rds")

#### STRING FUNCTIONS USING THE STRINGR PACKAGE ####
































# this can start to get a little tedious though...  so enter **case_when()**
events %>%
  mutate(new_type = case_when(
            event_type == "campaign event" ~ "event",
            event_type == "campaign events" ~ "event",
            event_type == "event speech" ~ "speech",
            event_type == TRUE ~ "other"
      ))

# Of course, you may be asking: wouldn't it be nice if we could standardize...
# ...based on certain keywords or patterns?  Instead of spelling out every variation.

# The answer is yes. Thanks to "string functions"...!

# We'll show a quick example of what that looks like, and then start from the beginning in the next module.
# 
events %>%
  mutate(new_type = case_when(
    str_detect(event_type, "event") ~ "event")
  )


# We'll take a closer look at string functions now using the stringr package.

# First, are there questions? Let's discuss.










# 
# ## Your Turn 11
# 
# Use `left_join()` to add the country codes in `country_codes` to the gapminder data.
# 
# ```{r}
# country_codes
# ```
# 
# **Challenge**: Which codes in country_codes have no matches in gapminder?
# 
# ```{r}
# 
# ```
# 
# 
# ***


