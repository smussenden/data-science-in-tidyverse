Transforming Data, Part B
================

load the packages we'll need

``` r
library(tidyverse) # we'll use the stringr package from tidyverse
```

    ## -- Attaching packages ------------------------------------------------------------------------------------------------------ tidyverse 1.2.1 --

    ## v ggplot2 3.1.0       v purrr   0.3.0  
    ## v tibble  2.0.1       v dplyr   0.8.0.1
    ## v tidyr   0.8.2       v stringr 1.4.0  
    ## v readr   1.3.1       v forcats 0.4.0

    ## -- Conflicts --------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
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

load in previous data of prez candidate campaign trips - we'll get back to this in a minute

``` r
events <- readRDS("events_saved.rds")
```

### String Functions - Using the `stringr` package

Each function starts with `str_`

-   `str_length()` figure out length of string
-   `str_c()` combine strings
-   `str_sub()` substitute string
-   `str_detect()` detect string in string
-   `str_match()` does string match
-   `str_count()` count strings
-   `str_split()` split strings
-   `str_to_upper()` convert string to upper case
-   `str_to_lower()` convert string to lower case
-   `str_to_title()` convert the first letter of each word to upper case
-   `str_trim()` eliminate trailing white space \#\# Let's load this data in

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
6.  Creating a new variable counting how many activities each person is engaged in
7.  Break activities into a set of useful dummy codes

**String length**
`str_length(string)` counts the number of characters in each element of a string or character vector.

``` r
x <- c("Bill", "Bob", "William")
str_length(x)
```

    ## [1] 4 3 7

**Combine strings**
`str_c(strings, sep="")`
It's like the equivalent of =concatenate in Excel.
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

You can pass the variable `collapse` to `str_c()` if you're turning an array of strings into one.

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

-   `str_to_upper(strings)` is upper case
-   `str_to_lower(strings)` is lower case
-   `str_to_title(strings)` is title case

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
`str_trim(strings)` remove white space at the beginning and end of string

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

**extract matches** using regular expressions

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

    ## # A tibble: 88 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2010-02-06 John          Delaney       Salt~ UT    event spe~
    ##  2 2019-01-31 Sherrod       Brown         Perry IA    meet and ~
    ##  3 2019-01-31 Marianne      Williamson    Des ~ IA    campaign ~
    ##  4 2019-01-31 Eric          Swalwell      Exet~ NH    meet and ~
    ##  5 2019-01-31 John          Hickenlooper  Wash~ DC    event spe~
    ##  6 2019-01-30 John          Delaney       Coun~ IA    campaign ~
    ##  7 2019-01-30 Sherrod       Brown         Clev~ OH    rally     
    ##  8 2019-01-30 Howard        Schultz       Tempe AZ    event spe~
    ##  9 2019-01-29 Beto          O'Rourke      El P~ TX    meet and ~
    ## 10 2019-01-29 Michael       Bloomberg     Manc~ NH    event spe~
    ## # ... with 78 more rows, and 1 more variable: description <chr>

now let's use string functions to standardize a few event types

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

Notice that in the example above, the search for comma comes first, not last

We can also use our string functions for filtering
Let's see what that might look like

``` r
events %>% 
  filter(str_detect(event_type, "event"))
```

    ## # A tibble: 50 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2010-02-06 John          Delaney       Salt~ UT    event spe~
    ##  2 2019-01-31 John          Hickenlooper  Wash~ DC    event spe~
    ##  3 2019-01-30 John          Delaney       Coun~ IA    campaign ~
    ##  4 2019-01-30 Howard        Schultz       Tempe AZ    event spe~
    ##  5 2019-01-29 Michael       Bloomberg     Manc~ NH    event spe~
    ##  6 2019-01-25 Kamala        Harris        Colu~ SC    event spe~
    ##  7 2019-01-25 Michael       Bloomberg     Wash~ DC    event spe~
    ##  8 2019-01-25 John          Delaney       Des ~ IA    event spe~
    ##  9 2019-01-24 Joe           Biden         Wash~ DC    event spe~
    ## 10 2019-01-24 Eric          Garcetti      Wash~ DC    event spe~
    ## # ... with 40 more rows, and 1 more variable: description <chr>

That's *kinda* helpful, but is there a column this could be even more useful for?

Examine the descriptions

``` r
events %>% 
  select(cand_restname, description) 
```

    ## # A tibble: 88 x 2
    ##    cand_restname description                                               
    ##    <chr>         <chr>                                                     
    ##  1 John          Delaney will speak at the Sorenson Winter Innovation Summ~
    ##  2 Sherrod       Roundtable with local farmers in Perry, IA and meet and g~
    ##  3 Marianne      Campaign announcement                                     
    ##  4 Eric          Meet and greet with Rockingham County Democrats           
    ##  5 John          Brookings institution Hamilton Project                    
    ##  6 John          Meet & greets and campaign office openings                
    ##  7 Sherrod       Dignity of Work tour                                      
    ##  8 Howard        Discussion with ASU students                              
    ##  9 Beto          meet and greet with UTEP students                         
    ## 10 Michael       Saint Anselm Institute of Politics, factory tour and hous~
    ## # ... with 78 more rows

What we we want to find descriptions mentioning students

``` r
events %>% 
  select(cand_restname, description) %>% 
  filter(str_detect(description, "student"))
```

    ## # A tibble: 6 x 2
    ##   cand_restname description                                                
    ##   <chr>         <chr>                                                      
    ## 1 Howard        Discussion with ASU students                               
    ## 2 Beto          meet and greet with UTEP students                          
    ## 3 Jay           League of Conservation Voters, speech to Dartmouth and Sai~
    ## 4 Bernie        SC NAACP MLK Day program, Conversation with students at Be~
    ## 5 Cory          InspireNOLA and Rep. Cedric Richmond’s “Project LIVE & Ach~
    ## 6 Beto          meet and greet with Pueblo Community College students

How about anything referencing the NAACP

``` r
events %>% 
  select(cand_restname, description) %>% 
  filter(str_detect(description, "NAACP"))
```

    ## # A tibble: 3 x 2
    ##   cand_restname description                                                
    ##   <chr>         <chr>                                                      
    ## 1 Bernie        SC NAACP MLK Day program, Conversation with students at Be~
    ## 2 Cory          SC NAACP MLK Day program                                   
    ## 3 Kamala        NAACP Women in Power town hall

Remember: R is *case-sensitive*.
Could an acronym like that possibly cause us trouble?

If so, how might we solve the issue of case sensitivity?

``` r
events %>% 
  select(cand_restname, description) %>% 
  filter(str_detect(str_to_lower(description), "naacp"))
```

    ## # A tibble: 3 x 2
    ##   cand_restname description                                                
    ##   <chr>         <chr>                                                      
    ## 1 Bernie        SC NAACP MLK Day program, Conversation with students at Be~
    ## 2 Cory          SC NAACP MLK Day program                                   
    ## 3 Kamala        NAACP Women in Power town hall

This method is a good strategy to use almost anytime you're searching in this way

Even when you don't think you'll need it, you never know.

Let's look at an example

``` r
events %>% 
  filter(str_detect(description, "border"))
```

    ## # A tibble: 0 x 7
    ## # ... with 7 variables: date <date>, cand_restname <chr>,
    ## #   cand_lastname <chr>, city <chr>, state <chr>, event_type <chr>,
    ## #   description <chr>

No results. Or are there?

``` r
events %>% 
  filter(str_detect(str_to_lower(description), "border"))
```

    ## # A tibble: 3 x 7
    ##   date       cand_restname cand_lastname city  state event_type description
    ##   <date>     <chr>         <chr>         <chr> <chr> <chr>      <chr>      
    ## 1 2018-12-23 Beto          O'Rourke      Torn~ TX    tour       Border vis~
    ## 2 2018-12-15 Jeff          Merkley       Torn~ TX    tour       Border vis~
    ## 3 2018-12-15 Beto          O'Rourke      Torn~ TX    tour       Border vis~

You can also do the reverse for the case, with the same goal.

``` r
events %>% 
  filter(str_detect(str_to_upper(description), "BORDER"))
```

    ## # A tibble: 3 x 7
    ##   date       cand_restname cand_lastname city  state event_type description
    ##   <date>     <chr>         <chr>         <chr> <chr> <chr>      <chr>      
    ## 1 2018-12-23 Beto          O'Rourke      Torn~ TX    tour       Border vis~
    ## 2 2018-12-15 Jeff          Merkley       Torn~ TX    tour       Border vis~
    ## 3 2018-12-15 Beto          O'Rourke      Torn~ TX    tour       Border vis~

### Joining Tables

One of the most powerful things about relational data being able to join tables together.

Let's take a look at how to do that with dpylr and the tidyverse.

First, let's bring in some new data:

``` r
key_house_results <- readRDS("key_house_results.rds") 
key_house_historical <- readRDS("key_house_historical.rds") 
```

What do we have here? Let's take a look and discuss.

``` r
key_house_results
```

    ## # A tibble: 104 x 7
    ##    house_dist keyrace_rating  flips dem_vote_pct gop_vote_pct winner margin
    ##    <chr>      <chr>           <chr>        <dbl>        <dbl> <chr>   <dbl>
    ##  1 AZ-01      lean democratic N             53.8         46.2 D         7.6
    ##  2 AZ-02      likely democra~ Y             54.7         45.3 D         9.4
    ##  3 AZ-06      likely republi~ N             44.8         55.2 R        10.4
    ##  4 AZ-08      likely republi~ N             44.5         55.5 R        11  
    ##  5 AZ-09      likely democra~ N             61.1         38.9 D        22.2
    ##  6 AR-02      lean republican N             45.8         52.1 R         6.3
    ##  7 CA-04      likely republi~ N             45.9         54.1 R         8.2
    ##  8 CA-10      tossup          Y             52.3         47.7 D         4.6
    ##  9 CA-21      likely republi~ Y             50.4         49.6 D         0.8
    ## 10 CA-25      tossup          Y             54.4         45.6 D         8.8
    ## # ... with 94 more rows

``` r
key_house_historical
```

    ## # A tibble: 104 x 9
    ##    house_dist former_party pct_college pct_college_abo~ median_income
    ##    <chr>      <chr>              <dbl> <chr>                    <dbl>
    ##  1 AZ-01      D                  23.6  BELOW                    48583
    ##  2 AZ-02      R                  33.0  ABOVE                    48125
    ##  3 AZ-06      R                  42.9  ABOVE                    64223
    ##  4 AZ-08      R                  28.3  BELOW                    60342
    ##  5 AZ-09      D                  36.7  ABOVE                    52245
    ##  6 AR-02      R                  28.4  BELOW                    48103
    ##  7 CA-04      R                  32.2  ABOVE                    69051
    ##  8 CA-10      R                  17.2  BELOW                    56256
    ##  9 CA-21      R                   8.13 BELOW                    38462
    ## 10 CA-25      R                  27.3  BELOW                    73819
    ## # ... with 94 more rows, and 4 more variables:
    ## #   median_income_abovebelow_natl <chr>, prez_winner_2016 <chr>,
    ## #   trump_vote_pct <dbl>, clinton_vote_pct <dbl>

``` r
#` This is a common thing to see - ables designed to be joined together based on a common key.
```

In this case, we have the house district itself as the common key between the two tables.

We'll use dplyr's `inner_join()` function to match the tables based on that column.
Let's see how that works

``` r
inner_join(key_house_results, key_house_historical)
```

    ## Joining, by = "house_dist"

    ## # A tibble: 104 x 15
    ##    house_dist keyrace_rating flips dem_vote_pct gop_vote_pct winner margin
    ##    <chr>      <chr>          <chr>        <dbl>        <dbl> <chr>   <dbl>
    ##  1 AZ-01      lean democrat~ N             53.8         46.2 D         7.6
    ##  2 AZ-02      likely democr~ Y             54.7         45.3 D         9.4
    ##  3 AZ-06      likely republ~ N             44.8         55.2 R        10.4
    ##  4 AZ-08      likely republ~ N             44.5         55.5 R        11  
    ##  5 AZ-09      likely democr~ N             61.1         38.9 D        22.2
    ##  6 AR-02      lean republic~ N             45.8         52.1 R         6.3
    ##  7 CA-04      likely republ~ N             45.9         54.1 R         8.2
    ##  8 CA-10      tossup         Y             52.3         47.7 D         4.6
    ##  9 CA-21      likely republ~ Y             50.4         49.6 D         0.8
    ## 10 CA-25      tossup         Y             54.4         45.6 D         8.8
    ## # ... with 94 more rows, and 8 more variables: former_party <chr>,
    ## #   pct_college <dbl>, pct_college_abovebelow_natl <chr>,
    ## #   median_income <dbl>, median_income_abovebelow_natl <chr>,
    ## #   prez_winner_2016 <chr>, trump_vote_pct <dbl>, clinton_vote_pct <dbl>

Wait, that's it? We haven't even told it what to join on.
That's because if the two tables share columns with the same name, it defaults to use them for the join.

If you need to specific which columns in each table to match together, you do it like this:

``` r
# inner_join(table1, table2, by = c("table1_columnname" = "table2_columnname"))
```

We can also use the pipe to write out a join. It depends on your preference.

``` r
key_house_results %>% 
  inner_join(key_house_historical)
```

    ## Joining, by = "house_dist"

    ## # A tibble: 104 x 15
    ##    house_dist keyrace_rating flips dem_vote_pct gop_vote_pct winner margin
    ##    <chr>      <chr>          <chr>        <dbl>        <dbl> <chr>   <dbl>
    ##  1 AZ-01      lean democrat~ N             53.8         46.2 D         7.6
    ##  2 AZ-02      likely democr~ Y             54.7         45.3 D         9.4
    ##  3 AZ-06      likely republ~ N             44.8         55.2 R        10.4
    ##  4 AZ-08      likely republ~ N             44.5         55.5 R        11  
    ##  5 AZ-09      likely democr~ N             61.1         38.9 D        22.2
    ##  6 AR-02      lean republic~ N             45.8         52.1 R         6.3
    ##  7 CA-04      likely republ~ N             45.9         54.1 R         8.2
    ##  8 CA-10      tossup         Y             52.3         47.7 D         4.6
    ##  9 CA-21      likely republ~ Y             50.4         49.6 D         0.8
    ## 10 CA-25      tossup         Y             54.4         45.6 D         8.8
    ## # ... with 94 more rows, and 8 more variables: former_party <chr>,
    ## #   pct_college <dbl>, pct_college_abovebelow_natl <chr>,
    ## #   median_income <dbl>, median_income_abovebelow_natl <chr>,
    ## #   prez_winner_2016 <chr>, trump_vote_pct <dbl>, clinton_vote_pct <dbl>

Now with an explicit mentioning of the column to join

``` r
key_house_results %>% 
  inner_join(key_house_historical, by = "house_dist")
```

    ## # A tibble: 104 x 15
    ##    house_dist keyrace_rating flips dem_vote_pct gop_vote_pct winner margin
    ##    <chr>      <chr>          <chr>        <dbl>        <dbl> <chr>   <dbl>
    ##  1 AZ-01      lean democrat~ N             53.8         46.2 D         7.6
    ##  2 AZ-02      likely democr~ Y             54.7         45.3 D         9.4
    ##  3 AZ-06      likely republ~ N             44.8         55.2 R        10.4
    ##  4 AZ-08      likely republ~ N             44.5         55.5 R        11  
    ##  5 AZ-09      likely democr~ N             61.1         38.9 D        22.2
    ##  6 AR-02      lean republic~ N             45.8         52.1 R         6.3
    ##  7 CA-04      likely republ~ N             45.9         54.1 R         8.2
    ##  8 CA-10      tossup         Y             52.3         47.7 D         4.6
    ##  9 CA-21      likely republ~ Y             50.4         49.6 D         0.8
    ## 10 CA-25      tossup         Y             54.4         45.6 D         8.8
    ## # ... with 94 more rows, and 8 more variables: former_party <chr>,
    ## #   pct_college <dbl>, pct_college_abovebelow_natl <chr>,
    ## #   median_income <dbl>, median_income_abovebelow_natl <chr>,
    ## #   prez_winner_2016 <chr>, trump_vote_pct <dbl>, clinton_vote_pct <dbl>

Remember, if we want to save the results, we need to create a new object

``` r
joined <- key_house_results %>% 
  inner_join(key_house_historical, by = "house_dist")
```

Let's explore our new joined table using what we've learned so far

``` r
glimpse(joined)
```

    ## Observations: 104
    ## Variables: 15
    ## $ house_dist                    <chr> "AZ-01", "AZ-02", "AZ-06", "AZ-0...
    ## $ keyrace_rating                <chr> "lean democratic", "likely democ...
    ## $ flips                         <chr> "N", "Y", "N", "N", "N", "N", "N...
    ## $ dem_vote_pct                  <dbl> 53.8, 54.7, 44.8, 44.5, 61.1, 45...
    ## $ gop_vote_pct                  <dbl> 46.2, 45.3, 55.2, 55.5, 38.9, 52...
    ## $ winner                        <chr> "D", "D", "R", "R", "D", "R", "R...
    ## $ margin                        <dbl> 7.6, 9.4, 10.4, 11.0, 22.2, 6.3,...
    ## $ former_party                  <chr> "D", "R", "R", "R", "D", "R", "R...
    ## $ pct_college                   <dbl> 23.640, 33.024, 42.851, 28.346, ...
    ## $ pct_college_abovebelow_natl   <chr> "BELOW", "ABOVE", "ABOVE", "BELO...
    ## $ median_income                 <dbl> 48583, 48125, 64223, 60342, 5224...
    ## $ median_income_abovebelow_natl <chr> "BELOW", "BELOW", "ABOVE", "ABOV...
    ## $ prez_winner_2016              <chr> "R", "D", "R", "R", "D", "R", "R...
    ## $ trump_vote_pct                <dbl> 47.0, 43.9, 51.6, 57.1, 37.6, 52...
    ## $ clinton_vote_pct              <dbl> 46.0, 48.7, 41.7, 36.4, 53.5, 41...
