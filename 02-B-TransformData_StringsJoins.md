Transforming Data, Part B
================

load the packages we’ll
    need

``` r
library(tidyverse) # we'll use the stringr package from tidyverse
```

    ## -- Attaching packages ------------------------------------------------------ tidyverse 1.2.1 --

    ## v ggplot2 3.1.0       v purrr   0.3.0  
    ## v tibble  2.0.1       v dplyr   0.8.0.1
    ## v tidyr   0.8.2       v stringr 1.4.0  
    ## v readr   1.3.1       v forcats 0.4.0

    ## -- Conflicts --------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
library(janitor)
```

load in previous data of prez candidate campaign trips - we’ll get back
to this in a minute

``` r
events <- readRDS("events_saved.rds")
```

### String Functions - Using the `stringr` package

Each function starts with `str_`

  - `str_length()` figure out length of string
  - `str_c()` combine strings
  - `str_sub()` substitute string
  - `str_detect()` detect string in string
  - `str_match()` does string match
  - `str_count()` count strings
  - `str_split()` split strings
  - `str_to_upper()` convert string to upper case
  - `str_to_lower()` convert string to lower case
  - `str_to_title()` convert the first letter of each word to upper case
  - `str_trim()` eliminate trailing white space \#\# Let’s load this
    data in

<!-- end list -->

``` r
messy <- tibble(name=c("Bill Smith", "jane doe", "John Forest-William"),
      email=c("bsmith@themail.com", "jdoe@themail.com", "jfwilliams$geemail.com"),
      income=c("$90,000", "$140,000", "E8500"),
      phone=c("(203) 847-334", "207-999-1122", "2128487345"),
      activites=c("fishing, sailing, planting flowers", "reading, raising flowers, biking", "hiking, fishing"))

messy
```

    ## # A tibble: 3 x 5
    ##   name           email            income  phone     activites              
    ##   <chr>          <chr>            <chr>   <chr>     <chr>                  
    ## 1 Bill Smith     bsmith@themail.~ $90,000 (203) 84~ fishing, sailing, plan~
    ## 2 jane doe       jdoe@themail.com $140,0~ 207-999-~ reading, raising flowe~
    ## 3 John Forest-W~ jfwilliams$geem~ E8500   21284873~ hiking, fishing

What problems do you see?  
*Tasks*

1.  Split name into First name and Last name
2.  Convert names to title case
3.  Create a new variable identifying bad email addresses
4.  Convert income to a new number in US dollars
5.  Create a new variable containing area code
6.  Creating a new variable counting how many activities each person is
    engaged in
7.  Break activities into a set of useful dummy codes

**String length**  
`str_length(string)` counts the number of characters in each element of
a string or character vector.

``` r
x <- c("Bill", "Bob", "William")
str_length(x)
```

    ## [1] 4 3 7

**Combine strings**  
`str_c(strings, sep="")`  
It’s like the equivalent of =concatenate in Excel.  
But there are a couple of quirks

``` r
data <- tibble(place=c("HQ", "HQ", "HQ"),
              id=c("A", "B", "C"),
              number=c("001", "002", "003"))

data
```

    ## # A tibble: 3 x 3
    ##   place id    number
    ##   <chr> <chr> <chr> 
    ## 1 HQ    A     001   
    ## 2 HQ    B     002   
    ## 3 HQ    C     003

We can add a string to each value in the *number* column this way:

``` r
data %>% 
  mutate(combined=str_c("Num: ", number))
```

    ## # A tibble: 3 x 4
    ##   place id    number combined
    ##   <chr> <chr> <chr>  <chr>   
    ## 1 HQ    A     001    Num: 001
    ## 2 HQ    B     002    Num: 002
    ## 3 HQ    C     003    Num: 003

You can pass the variable `collapse` to `str_c()` if you’re turning an
array of strings into one.

``` r
data %>% 
    group_by(place) %>% 
    summarize(ids_combined=str_c(number, collapse="-"))
```

    ## # A tibble: 1 x 2
    ##   place ids_combined
    ##   <chr> <chr>       
    ## 1 HQ    001-002-003

**subset strings**  
`str_sub(strings, start, end)` extracts and replaces substrings

``` r
x <- "Dr. James"

str_sub(x, 1, 3)
```

    ## [1] "Dr."

``` r
str_sub(x, 1, 3) <- "Mr."
x
```

    ## [1] "Mr. James"

Negative numbers count from the right.

``` r
x <- "baby"
str_sub(x, -3, -1)
```

    ## [1] "aby"

``` r
str_sub(x, -1, -1) <- "ies"
x
```

    ## [1] "babies"

**change case**

  - `str_to_upper(strings)` is upper case
  - `str_to_lower(strings)` is lower case
  - `str_to_title(strings)` is title case

<!-- end list -->

``` r
x <- c("john smith", "Mary Todd", "BILL HOLLIS")

str_to_upper(x)
```

    ## [1] "JOHN SMITH"  "MARY TODD"   "BILL HOLLIS"

``` r
str_to_lower(x)
```

    ## [1] "john smith"  "mary todd"   "bill hollis"

``` r
str_to_title(x)
```

    ## [1] "John Smith"  "Mary Todd"   "Bill Hollis"

**trim strings**  
`str_trim(strings)` remove white space at the beginning and end of
string

``` r
x <- c(" Assault", "Burglary ", " Kidnapping ")

str_trim(x)
```

    ## [1] "Assault"    "Burglary"   "Kidnapping"

**detect matches**  
`str_detect(strings, pattern)` returns T/F

``` r
x <- c("Bill", "Bob", "David.Williams")
x
```

    ## [1] "Bill"           "Bob"            "David.Williams"

``` r
str_detect(x, "il")
```

    ## [1]  TRUE FALSE  TRUE

**count matches**  
`str_count(strings, pattern)` count number of matches in a string

``` r
x <- c("Assault/Robbery/Kidnapping")
x
```

    ## [1] "Assault/Robbery/Kidnapping"

``` r
str_count(x, "/")
```

    ## [1] 2

How many offenses

``` r
str_count(x, "/") + 1
```

    ## [1] 3

**extract matches** using regular
expressions

``` r
x <- c("bsmith@microsoft.com", "jdoe@google.com", "jfwilliams@google.com")

str_extract(x, "@.+\\.com$")
```

    ## [1] "@microsoft.com" "@google.com"    "@google.com"

**split strings**  
`str_split(string, pattern)` split a string into pieces

``` r
x <- c("john smith", "mary todd", "bill holis")

str_split(x, " ", simplify=TRUE)
```

    ##      [,1]   [,2]   
    ## [1,] "john" "smith"
    ## [2,] "mary" "todd" 
    ## [3,] "bill" "holis"

``` r
first <- str_split(x, " ", simplify=TRUE)[,1]
last  <- str_split(x, " ", simplify=TRUE)[,2]
```

**replace a pattern**  
`str_replace(strings, pattern, replacement)`  
replace a pattern in a string with another string

``` r
x <- c("john smith", "mary todd", "bill holis")

str_replace(x, "[aeiou]", "-")
```

    ## [1] "j-hn smith" "m-ry todd"  "b-ll holis"

``` r
str_replace_all(x, "[aeiou]", "-")
```

    ## [1] "j-hn sm-th" "m-ry t-dd"  "b-ll h-l-s"

### Back to our campaign data

``` r
events
```

    ## # A tibble: 88 x 10
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2010-02-06 John          Delaney       John Delaney  Salt~ <NA>        
    ##  2 2019-01-31 Sherrod       Brown         Sherrod Brown Perry Cresco, Mas~
    ##  3 2019-01-31 Marianne      Williamson    Marianne Wil~ Des ~ <NA>        
    ##  4 2019-01-31 Eric          Swalwell      Eric Swalwell Exet~ <NA>        
    ##  5 2019-01-31 John          Hickenlooper  John Hickenl~ Wash~ <NA>        
    ##  6 2019-01-30 John          Delaney       John Delaney  Coun~ Sioux City,~
    ##  7 2019-01-30 Sherrod       Brown         Sherrod Brown Clev~ <NA>        
    ##  8 2019-01-30 Howard        Schultz       Howard Schul~ Tempe <NA>        
    ##  9 2019-01-29 Beto          O'Rourke      Beto O'Rourke El P~ <NA>        
    ## 10 2019-01-29 Michael       Bloomberg     Michael Bloo~ Manc~ Concord, Na~
    ## # ... with 78 more rows, and 4 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>

now let’s use string functions to standardize a few event types

``` r
events %>%
  select(event_type) %>% 
  mutate(new_type = case_when(
    str_detect(event_type, "speech") ~ "speech")
  ) 
```

    ## # A tibble: 88 x 2
    ##    event_type                   new_type
    ##    <chr>                        <chr>   
    ##  1 event speech                 speech  
    ##  2 meet and greet               <NA>    
    ##  3 campaign announcement        <NA>    
    ##  4 meet and greet               <NA>    
    ##  5 event speech                 speech  
    ##  6 campaign events              <NA>    
    ##  7 rally                        <NA>    
    ##  8 event speech                 speech  
    ##  9 meet and greet               <NA>    
    ## 10 event speech, meet and greet speech  
    ## # ... with 78 more rows

could there be a problem here?  
multiples?

``` r
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
```

    ## # A tibble: 88 x 2
    ##    event_type                   new_type         
    ##    <chr>                        <chr>            
    ##  1 event speech                 speech           
    ##  2 meet and greet               <NA>             
    ##  3 campaign announcement        <NA>             
    ##  4 meet and greet               <NA>             
    ##  5 event speech                 speech           
    ##  6 campaign events              unspecified event
    ##  7 rally                        <NA>             
    ##  8 event speech                 speech           
    ##  9 meet and greet               <NA>             
    ## 10 event speech, meet and greet multiple         
    ## # ... with 78 more rows

notice that in the example above, the search for comma comes first, not
last  
\#\#\# Joining Tables
