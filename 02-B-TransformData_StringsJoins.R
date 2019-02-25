#**** TRANSFORMING DATA - PART B****#
#**** String functions and joining tables

#load the packages we'll need
library(tidyverse) # we'll use the stringr package from tidyverse
library(lubridate)
library(janitor)
  
# load in previous data of prez candidate campaign trips - we'll get back to this in a minute
events <- readRDS("events_saved.rds")

#### STRING FUNCTIONS USING THE STRINGR PACKAGE ####

# Each function starts with `str_`
# 
#    `str_length()`  figure out length of string 
#    `str_c()`  combine strings 
#    `str_sub()`     substitute string 
#    `str_detect()`     detect string in string 
#    `str_match()`     does string match 
#    `str_count()`     count strings 
#    `str_split()`    split strings 
#    `str_to_upper()`    convert string to upper case 
#    `str_to_lower()`    convert string to lower case 
#    `str_to_title()`    convert the first letter of each word to upper case 
#    `str_trim()`    eliminate trailing white space 


# Let's load this data in:


messy <- data.frame(name=c("Bill Smith", "jane doe", "John Forest-William"),
                    email=c("bsmith@themail.com", "jdoe@themail.com", "jfwilliams$geemail.com"),
                    income=c("$90,000", "$140,000", "E8500"),
                    phone=c("(203) 847-334", "207-999-1122", "2128487345"),
                    activites=c("fishing, sailing, planting flowers", "reading, raising flowers, biking", "hiking, fishing"))

messy

# What problems do you see?

# **Tasks**
# 
# 1. Split name into First name and Last name
# 2. Convert names to title case
# 3. Create a new variable identifying bad email addresses
# 4. Convert income to a new number in US dollars
# 5. Create a new variable containing area code
# 6. Creating a new variable counting how many activities each person is engaged in
# 7. Break activities into a set of useful dummy codes

## String length
# `str_length(string)` counts the number of characters in each element of a string or character vector.

x <- c("Bill", "Bob", "William")
str_length(x)


## Combine strings
# `str_c(strings, sep="")`

# It's like the equivalent of =concatenate in Excel.
# But there are a couple of quirks

data <- data.frame(place=c("HQ", "HQ", "HQ"),
                   id=c("A", "B", "C"),
                   number=c("001", "002", "003"))

data

# We can add a string to each value in the *number* column this way:
data %>% 
  mutate(combined=str_c("Num: ", number))

# You can pass the variable `collapse` to `str_c()` if you're turning an array of strings into one.
data %>% 
    group_by(place) %>% 
    summarize(ids_combined=str_c(number, collapse="-"))


## subset strings
# `str_sub(strings, start, end)` extracts and replaces substrings

x <- "Dr. James"

str_sub(x, 1, 3)

str_sub(x, 1, 3) <- "Mr."
x


Negative numbers count from the right.

```{r str_sub3}
x <- "baby"
str_sub(x, -3, -1)
str_sub(x, -1, -1) <- "ies"
```


## detect matches

`str_detect(strings, pattern)` returns T/F

```{r str_detect1}
x <- c("Bill", "Bob", "David.Williams")
x
str_detect(x, "il")
```

## count matches

`str_count(strings, pattern)` count number of matches in a string

```{r str_count}
x <- c("Assault/Robbery/Kidnapping")
x
str_count(x, "/")

# How many offenses
str_count(x, "/") + 1
```

## extract matches

```{r str_extract}
x <- c("bsmith@microsoft.com", "jdoe@google.com", "jfwilliams@google.com")
str_extract(x, "@.+\\.com$")
```

## split strings

`str_split(string, pattern)` split a string into pieces

```{r str_split}
x <- c("john smith", "mary todd", "bill holis")

str_split(x, " ", simplify=TRUE)

first <- str_split(x, " ", simplify=TRUE)[,1]
last  <- str_split(x, " ", simplify=TRUE)[,2]
```


## replace a pattern

`str_replace(strings, pattern, replacement)` replace a pattern in a string with another string

```{r str_replace}
x <- c("john smith", "mary todd", "bill holis")
str_replace(x, "[aeiou]", "-")

str_replace_all(x, "[aeiou]", "-")
```

## change case

`str_to_upper(strings)` is upper case
`str_to_lower(strings)` is lower case
`str_to_title(strings)` is title case

```{r x_case}
x <- c("john smith", "Mary Todd", "BILL HOLLIS")

str_to_upper(x)
str_to_lower(x)
str_to_title(x)
```

## trim strings

`str_trim(strings)` remove white space at the beginning and end of string

```{r str_trim}
x <- c(" Assault", "Burglary ", " Kidnapping ")
str_trim(x)
```































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


