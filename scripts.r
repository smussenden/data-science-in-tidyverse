### NICAR R class script file

### Install packages
install.packages(c("tidyverse", "lubridate", "janitor", "fivethirtyeight", "rmarkdown", "usethis"))

### Load libraries
library(tidyverse)
library(lubridate)
library(janitor)
library(fivethirtyeight)
library(rmarkdown)
library(usethis)
### COURSE MATERIAL for my class  
--First two weeks in Excel (filter, sort, pivot tables)
--Next three weeks in SQL (filter, sort, pivot tables, joins, connect to DB)
--Rest of class in R (connect to databases, filter, sort, group by, summary, join, visualization, functions, etc..., cleaning data, etc....)
--Eventually move into scraping in R with Rvest, models. 
--Create video tutorials, text tutorials, resources for cheat sheets. 
--EACH TIME I do a new language, show how we did it in previous language and showing there. 
--Go through sarah code. 
--Andrew Tran and Houston Chron guy and Aaron Kessler

## Need to get olga pierce code for connecting to databases, working with funcitons. 
### andrew tran's graphic stuff is pretty good, will need some modification to teach it.
### in gg plot, every chart needs data set and aesthetic and plot type
## You can chain together dplyr AND ggplot in one function, don't need to separate
## ggsave() for saving stuff out.
## Plotly is kind of like data wrapper
https://learn.r-journalism.com/en/visualizing/charts_with_ggplot/ggplot2/
  https://github.com/andrewbtran/NICAR/blob/master/2019/mapping/01_maps_code.R
http://www.machlis.com/nicar19.html

### THESE Transform Data stuff is great. strings, joins, scoped transforms
glimpse(joined)

### For logging changes from dplyr as comments https://cran.r-project.org/web/packages/tidylog/index.html
http://www.compjournalism.com/?p=218
http://mjwebster.github.io/DataJ/
### Joins v enterprise joins, talk about differences (relational databases vs combining data sets)
### Aaron package on strings is pretty good, great to use that. 
### Start using ifelse. Start using case_when for cleaning data.  SHOW THESE IN R. case_when keeps NAs. 
#### Use the little magic wand dropdown to automatically indent code.
#### Add a little ' when I knit a file out 
### Personal preference on storing things as objects -- maybe just do exploratory queries without storing it as object
### Janitor Package! Cleans up column names... clean_names() KEEPS ME FROM HAVIN TO DO THIS
EMS_all <- EMS_all %>%
  rename(incident_date = Incident.Date, 
         incident_number = Incident.Number,
         primary_impression =  Primary.Impression,
         arrived_on_scene_time = Times...Arrived.on.Scene.Time,
         zipcode = Incident.Postal.Code..E8.15.,
         destination_patient_disposition = Destination.Patient.Disposition..E20.10.,
         destination_code = Destination.Code..E20.2.
  ) 

d**.  
#' * `ifelse()`  
#'   
#' let's see `ifelse()` in action

events %>% 
  mutate(new_type = ifelse(event_type == "event speech", "TEST", event_type)) 

#' ok now let's clean a few columns for real

events %>% 
  mutate(new_type = ifelse(event_type == "campaign event", "event", event_type),
         new_type = ifelse(event_type == "campaign events", "event", new_type),
         new_type = ifelse(event_type == "event speech", "speech", new_type)
  ) 

#' this can start to get a little tedious though. enter `case_when`

events %>%
  mutate(new_type = case_when(
    event_type == "campaign event" ~ "event",
    event_type == "campaign events" ~ "event",
    event_type == "event speech" ~ "speech",
    event_type == TRUE ~ "other"
  ))

#' Of course, you may be asking: wouldn't it be nice if we could standardize...  
#' ...based on certain keywords or patterns?  Instead of spelling out every variation.  
#'   
#' The answer is yes. Thanks to "string functions"...!  
#'   
#' We'll show a quick example of what that looks like, and then start from the beginning in the next module.  

events %>%
  mutate(new_type = case_when(
    str_detect(event_type, "event") ~ "event")
  )


#' We'll take a closer look at string functions now using the stringr package.  
#'   
#' First, are there questions? Let's discuss.

### STR_DETECT - wildcards. Kind of like like -- There's also starts with or ends with or REGEX.  Use for that.  STR STARTS WITH and END WITH. 
### STR_SPLIT - Text to columns 
### STR_C is concatenate!!! Can concatenate srings and numbers
### STR_SUB --- pull out pieces of strings. 

### COMMAND SHIFT C - comment an entire thing
### ALT SHIFT K -- Shortcut refernce. 
### Note to self...DROP SQL analysis assignment, use R or Excel. ONLY TEACH STUDENT STHIS 
### https://github.com/utdata
#### The class materials I've been writing this semester. It's definitely been a learning experience, and I suspect this will change.
### https://utdata.github.io/rwd-class/
###This is a Google Drive folder with all my other materials, which won't be organized or anything, but ...
#### https://drive.google.com/drive/u/1/folders/0B8ConnGcXrv8dDFua1pjT2xRUVk
#### -- You can use git directly within R - clone repos inside. 
#### -- in class files vs class files
#### -- R is a language with dplyr designed for people to read it
#### -- designed from ground up to do data analysis and visualization and statistics
#### -- command + enter on line allows you to run
#### -- Tibble is a data frame that makes it possible to look at data. 
### Note to self -- teach the tidyverse, and only teach base R.  Much more easy and understandable to use. 
#### -- c is a list of stuff vector c("one","two","three")
### tibble is a handy way of seeing field types, etc...
### factors are for categorical analysis, but can cause problems when doing normal stuff.  default 
### read_csv pulls in as a tibble whereas read.csv pulls in as base dataframe.
### Another good reason to teach R -- a solid ecosystem of documentation. 
#### Tidyverse other related.
#### Andrew course https://journalismcourses.org/RC0818.html
#### select(-amount)
#### Use MINUS sign to reverse select
### EVERYTHING is great
--Can also select a range. with colons or numbers.
### Rstats  on twitter. 
--#### R STUDIO CHEATSHEETS ARE WITHIN R!!!!!!!!!!!! HELP MENU
  #### Look up parse number to pull out
--

arranging <- pollution %>%
  arrange(desc(amount)) %>%
  filter(amount > 20, city == "London") %>%
  select(amount, everything())

https://github.com/tidyverse/glue
jsonlite for JSON.
xml2 for XML.
httr for web APIs.
rvest for web scraping.
DBI for relational databases. To connect to a specific database, you’ll need to pair DBI with a specific backend like RSQLite, RPostgres, or odbc. Learn more at http://db.rstudio.com.
https://github.com/tidyverse/glue
#'Enter a glorious feature of the tidyverse: **the PIPE** `%>%`  
#'   
#'The "pipe" (shortcut is CTRL/CMD + SHIFT + M) allows you to chain together commands  
## OR
large_pollution <- pollution %>%
  filter(amount > 20 |
           size == "large")
## AND
large_pollution <- pollution %>%
  filter(amount > 20,
         size == "large")

### Dates have special status in r
jan_2019 <- events %>%
  filter(date < "2018-12-31")

