#'---
#'title: "Transforming Data, Part B"
#'author:
#'date:
#'output: github_document
#'---


#'load the packages we'll need
library(tidyverse) # we'll use the stringr package from tidyverse
library(lubridate)
library(janitor)

  
#'load in previous data of prez candidate campaign trips - we'll get back to this in a minute
events <- readRDS("events_saved.rds")

#'### String Functions - Using the `stringr` package

#' Each function starts with `str_`
#'
#'* `str_length()`  figure out length of string 
#'* `str_c()`  combine strings 
#'* `str_sub()`     substitute string 
#'* `str_detect()`     detect string in string 
#'* `str_match()`     does string match 
#'* `str_count()`     count strings 
#'* `str_split()`    split strings 
#'* `str_to_upper()`    convert string to upper case 
#'* `str_to_lower()`    convert string to lower case 
#'* `str_to_title()`    convert the first letter of each word to upper case 
#'* `str_trim()`    eliminate trailing white space 

 
#'## Let's load this data in
messy <- tibble(name=c("Bill Smith", "jane doe", "John Forest-William"),
      email=c("bsmith@themail.com", "jdoe@themail.com", "jfwilliams$geemail.com"),
      income=c("$90,000", "$140,000", "E8500"),
      phone=c("(203) 847-334", "207-999-1122", "2128487345"),
      activites=c("fishing, sailing, planting flowers", "reading, raising flowers, biking", "hiking, fishing"))

messy

#' What problems do you see?  
#' *Tasks*
#' 
#' 1. Split name into First name and Last name
#' 2. Convert names to title case
#' 3. Create a new variable identifying bad email addresses
#' 4. Convert income to a new number in US dollars
#' 5. Create a new variable containing area code
#' 6. Creating a new variable counting how many activities each person is engaged in
#' 7. Break activities into a set of useful dummy codes  
#'     

#'**String length**  
#' `str_length(string)` counts the number of characters in each element of a string or character vector.

x <- c("Bill", "Bob", "William")
str_length(x)


#' **Combine strings**  
#' `str_c(strings, sep="")`  
#' It's like the equivalent of =concatenate in Excel.  
#' But there are a couple of quirks

data <- tibble(place=c("HQ", "HQ", "HQ"),
              id=c("A", "B", "C"),
              number=c("001", "002", "003"))

data

#' We can add a string to each value in the *number* column this way:
data %>% 
  mutate(combined=str_c("Num: ", number))

#' You can pass the variable `collapse` to `str_c()` if you're turning an array of strings into one.
data %>% 
    group_by(place) %>% 
    summarize(ids_combined=str_c(number, collapse="-"))


#' **subset strings**  
#' `str_sub(strings, start, end)` extracts and replaces substrings
x <- "Dr. James"

str_sub(x, 1, 3)

str_sub(x, 1, 3) <- "Mr."
x

#' Negative numbers count from the right.
x <- "baby"
str_sub(x, -3, -1)

str_sub(x, -1, -1) <- "ies"
x


#' **change case**  
#' 
#'* `str_to_upper(strings)` is upper case
#'* `str_to_lower(strings)` is lower case
#'* `str_to_title(strings)` is title case
x <- c("john smith", "Mary Todd", "BILL HOLLIS")

str_to_upper(x)
str_to_lower(x)
str_to_title(x)


#'**trim strings**  
#' `str_trim(strings)` remove white space at the beginning and end of string
x <- c(" Assault", "Burglary ", " Kidnapping ")

str_trim(x)


#'**detect matches**   
#' `str_detect(strings, pattern)` returns T/F
x <- c("Bill", "Bob", "David.Williams")
x

str_detect(x, "il")


#'**count matches**  
#' `str_count(strings, pattern)` count number of matches in a string
x <- c("Assault/Robbery/Kidnapping")
x

str_count(x, "/")

#' How many offenses
str_count(x, "/") + 1


#'**extract matches** using regular expressions
x <- c("bsmith@microsoft.com", "jdoe@google.com", "jfwilliams@google.com")

str_extract(x, "@.+\\.com$")


#'**split strings**  
#' `str_split(string, pattern)` split a string into pieces
x <- c("john smith", "mary todd", "bill holis")

str_split(x, " ", simplify=TRUE)

first <- str_split(x, " ", simplify=TRUE)[,1]
last  <- str_split(x, " ", simplify=TRUE)[,2]


#'**replace a pattern**  
#' `str_replace(strings, pattern, replacement)`   
#' replace a pattern in a string with another string
x <- c("john smith", "mary todd", "bill holis")

str_replace(x, "[aeiou]", "-")

str_replace_all(x, "[aeiou]", "-")


#'### Back to our campaign data 

events

#' now let's use string functions to standardize a few event types
events %>%
  select(event_type) %>% 
  mutate(new_type = case_when(
    str_detect(event_type, "speech") ~ "speech")
  ) 


#' could there be a problem here?  
#' multiples?
events %>%
  select(event_type) %>% 
  mutate(new_type = case_when(
    str_detect(event_type, ",") ~ "multiple",
    str_detect(event_type, "speech") ~ "speech",
    str_detect(event_type, "event") ~ "unspecified event",
    str_detect(event_type, "forum") ~ "town hall",
    str_detect(event_type, "town hall") ~ "town hall"
    )
  ) 

#' notice that in the example above, the search for comma comes first, not last
#'         

#'### Joining Tables 





