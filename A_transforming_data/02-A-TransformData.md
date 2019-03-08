Transforming Data, Part A
================
Aaron Kessler
(March 9, 2019 - NICAR Conference, Newport Beach, CA)

Load the packages we’ll
    need

``` r
library(tidyverse)
```

    ## -- Attaching packages ------------------------------------------------------------- tidyverse 1.2.1 --

    ## v ggplot2 3.1.0       v purrr   0.3.0  
    ## v tibble  2.0.1       v dplyr   0.8.0.1
    ## v tidyr   0.8.2       v stringr 1.4.0  
    ## v readr   1.3.1       v forcats 0.4.0

    ## -- Conflicts ---------------------------------------------------------------- tidyverse_conflicts() --
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

Toy dataset to use, created manually with a
tibble

``` r
pollution <- tibble(city=c("New York", "New York", "London", "London", "Beijing", "Beijing"),
               size=c("large", "small", "large", "small", "large", "small"),
               amount=c(23, 14, 22, 16, 121, 56))
```

*What are “tibbles”…?*

They’re dataframes, with some additional tidyverse-infused features.
Returns more readable output in the console.

Let’s see the data we just created, you’ll see how a tibble view differs
in the console

``` r
pollution
```

    ## # A tibble: 6 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 New York small     14
    ## 3 London   large     22
    ## 4 London   small     16
    ## 5 Beijing  large    121
    ## 6 Beijing  small     56

Since there are only a handful of rows, a bit harder to see - let’s try
the built-in “iris” data

``` r
#(not run)
#iris
```

That was a lot of output\! Can limit rows with head()

``` r
head(iris)
```

    ##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ## 1          5.1         3.5          1.4         0.2  setosa
    ## 2          4.9         3.0          1.4         0.2  setosa
    ## 3          4.7         3.2          1.3         0.2  setosa
    ## 4          4.6         3.1          1.5         0.2  setosa
    ## 5          5.0         3.6          1.4         0.2  setosa
    ## 6          5.4         3.9          1.7         0.4  setosa

But let’s see how tibbles differ in their output

``` r
as_tibble(iris)
```

    ## # A tibble: 150 x 5
    ##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
    ##  1          5.1         3.5          1.4         0.2 setosa 
    ##  2          4.9         3            1.4         0.2 setosa 
    ##  3          4.7         3.2          1.3         0.2 setosa 
    ##  4          4.6         3.1          1.5         0.2 setosa 
    ##  5          5           3.6          1.4         0.2 setosa 
    ##  6          5.4         3.9          1.7         0.4 setosa 
    ##  7          4.6         3.4          1.4         0.3 setosa 
    ##  8          5           3.4          1.5         0.2 setosa 
    ##  9          4.4         2.9          1.4         0.2 setosa 
    ## 10          4.9         3.1          1.5         0.1 setosa 
    ## # ... with 140 more rows

### FILTERING AND SORTING

The tidyverse’s *dplyr* provides intuitive functions for exploring and
analyzing dataframes

Let’s go back to our little pollution dataset

``` r
pollution
```

    ## # A tibble: 6 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 New York small     14
    ## 3 London   large     22
    ## 4 London   small     16
    ## 5 Beijing  large    121
    ## 6 Beijing  small     56

Show me only the ones with a “large” size

``` r
filter(pollution, size == "large")
```

    ## # A tibble: 3 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 London   large     22
    ## 3 Beijing  large    121

Show me only the ones where the city is London

``` r
filter(pollution, city == "London")
```

    ## # A tibble: 2 x 3
    ##   city   size  amount
    ##   <chr>  <chr>  <dbl>
    ## 1 London large     22
    ## 2 London small     16

For numeric values, you can use boolean operators

``` r
filter(pollution, amount > 20)
```

    ## # A tibble: 4 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 London   large     22
    ## 3 Beijing  large    121
    ## 4 Beijing  small     56

``` r
filter(pollution, amount <= 22)
```

    ## # A tibble: 3 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York small     14
    ## 2 London   large     22
    ## 3 London   small     16

Now, let’s try filtering based on two different
variables

``` r
filter(pollution, amount > 20, size == "large") #'note the comma separating the filtering terms
```

    ## # A tibble: 3 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 London   large     22
    ## 3 Beijing  large    121

This can still get a little confusing once you wind up with larger
amounts of steps to string together.

Enter a glorious feature of the tidyverse: **the PIPE** `%>%`

The “pipe” (shortcut is CTRL/CMD + SHIFT + M) allows you to chain
together commands

Watch this, and see how much easier it becomes for a human to think
through (and read later\!)

``` r
pollution %>% 
  filter(size == "large")
```

    ## # A tibble: 3 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 London   large     22
    ## 3 Beijing  large    121

Voila\! So what just happened there?

Think of %\>% as the equivalent of “and then do this”…  
It takes the result and then applies something new to it, in sequential
order

This becomes easy to see when we add new functions - so let’s talk about
sorting with arrange()

``` r
pollution %>% 
  arrange(amount)
```

    ## # A tibble: 6 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York small     14
    ## 2 London   small     16
    ## 3 London   large     22
    ## 4 New York large     23
    ## 5 Beijing  small     56
    ## 6 Beijing  large    121

To sort by highest value, add desc()

``` r
pollution %>% 
  arrange(desc(amount))
```

    ## # A tibble: 6 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 Beijing  large    121
    ## 2 Beijing  small     56
    ## 3 New York large     23
    ## 4 London   large     22
    ## 5 London   small     16
    ## 6 New York small     14

Now let’s go back to our filtering and add arranging, too

``` r
pollution %>% 
  filter(size == "large") %>% 
  arrange(desc(amount))
```

    ## # A tibble: 3 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 Beijing  large    121
    ## 2 New York large     23
    ## 3 London   large     22

Add another filter criteria

``` r
pollution %>% 
  filter(size == "large", amount < 100) %>% 
  arrange(desc(amount))
```

    ## # A tibble: 2 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 London   large     22

This can be formatted this way as well, if it’s even easier for you to
read  
Let’s add another filter criteria

``` r
pollution %>% 
  filter(size == "large", 
         amount < 100) %>% 
  arrange(desc(amount))
```

    ## # A tibble: 2 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 London   large     22

Think about what we just did here.

You can read the code and it intuitively makes sense. Each step
sequentially listed and executes in order.

One more thing - what if we don’t want all the columns? Just some.  
This happens all the time.

Dplyr makes this easy using **select()\`**

``` r
pollution %>% 
  select(city, amount)
```

    ## # A tibble: 6 x 2
    ##   city     amount
    ##   <chr>     <dbl>
    ## 1 New York     23
    ## 2 New York     14
    ## 3 London       22
    ## 4 London       16
    ## 5 Beijing     121
    ## 6 Beijing      56

You can pull out just certain variables as well  
This results in the same thing as above

``` r
pollution %>% 
  select(-size)
```

    ## # A tibble: 6 x 2
    ##   city     amount
    ##   <chr>     <dbl>
    ## 1 New York     23
    ## 2 New York     14
    ## 3 London       22
    ## 4 London       16
    ## 5 Beijing     121
    ## 6 Beijing      56

### PRESIDENTIAL CANDIDATE TRIPS

Let’s take a look at some more intersting data now and try out some of
these methods

Load in data of prez candidate campaign trips between midterms and end
of Jan

``` r
events <- readRDS("events_saved.rds")
```

Let’s take a look at what we’ve got

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

Even easier to see a dataset with `View()`  
Click on its name under the environment tab in upper right, or:

``` r
View(events)
```

Can also pipe the results of a chain if we wanted to

``` r
events %>% 
  view()
```

Can you think of when we might find ourselves wanting to do that? (hint:
think big)

Now let’s try out some of our filtering and arranging techniques.

Show all events in Iowa:

``` r
events %>% 
  filter(state == "IA")
```

    ## # A tibble: 21 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2019-01-31 Sherrod       Brown         Perry IA    meet and ~
    ##  2 2019-01-31 Marianne      Williamson    Des ~ IA    campaign ~
    ##  3 2019-01-30 John          Delaney       Coun~ IA    campaign ~
    ##  4 2019-01-28 Kamala        Harris        Des ~ IA    town hall 
    ##  5 2019-01-27 Eric          Swalwell      Mari~ IA    meet and ~
    ##  6 2019-01-27 John          Hickenlooper  Des ~ IA    house par~
    ##  7 2019-01-25 John          Delaney       Des ~ IA    event spe~
    ##  8 2019-01-18 Kirsten       Gillibrand    Siou~ IA    organizin~
    ##  9 2019-01-11 John          Delaney       Des ~ IA    organizin~
    ## 10 2019-01-09 Tom           Steyer        Des ~ IA    meet and ~
    ## # ... with 11 more rows, and 1 more variable: description <chr>

Has Kamala Harris been to Iowa?

``` r
events %>% 
  filter(state == "IA",
         cand_lastname == "Harris")
```

    ## # A tibble: 1 x 7
    ##   date       cand_restname cand_lastname city  state event_type description
    ##   <date>     <chr>         <chr>         <chr> <chr> <chr>      <chr>      
    ## 1 2019-01-28 Kamala        Harris        Des ~ IA    town hall  CNN Town H~

What about another candidate

``` r
events %>% 
  filter(state == "IA",
         cand_lastname == "Gillibrand")
```

    ## # A tibble: 1 x 7
    ##   date       cand_restname cand_lastname city  state event_type description
    ##   <date>     <chr>         <chr>         <chr> <chr> <chr>      <chr>      
    ## 1 2019-01-18 Kirsten       Gillibrand    Siou~ IA    organizin~ Organizing~

Let’s talk about **date-specific** stuff.  
If I have a properly formatted date in a dataframe, can I sort by it?
*Yes.*

``` r
events %>% 
  filter(state == "IA") %>% 
  arrange(desc(date))
```

    ## # A tibble: 21 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2019-01-31 Sherrod       Brown         Perry IA    meet and ~
    ##  2 2019-01-31 Marianne      Williamson    Des ~ IA    campaign ~
    ##  3 2019-01-30 John          Delaney       Coun~ IA    campaign ~
    ##  4 2019-01-28 Kamala        Harris        Des ~ IA    town hall 
    ##  5 2019-01-27 Eric          Swalwell      Mari~ IA    meet and ~
    ##  6 2019-01-27 John          Hickenlooper  Des ~ IA    house par~
    ##  7 2019-01-25 John          Delaney       Des ~ IA    event spe~
    ##  8 2019-01-18 Kirsten       Gillibrand    Siou~ IA    organizin~
    ##  9 2019-01-11 John          Delaney       Des ~ IA    organizin~
    ## 10 2019-01-09 Tom           Steyer        Des ~ IA    meet and ~
    ## # ... with 11 more rows, and 1 more variable: description <chr>

What if I want to pull out only certain ranges of dates? *Several
approaches.*  
Specifiying a specific date using as.Date()

``` r
events %>% 
  filter(date < as.Date("2018-12-31"))
```

    ## # A tibble: 27 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2010-02-06 John          Delaney       Salt~ UT    event spe~
    ##  2 2018-12-23 Beto          O'Rourke      Torn~ TX    tour      
    ##  3 2018-12-20 Pete          Buttigieg     Des ~ IA    event spe~
    ##  4 2018-12-20 Jeff          Merkley       Des ~ IA    event spe~
    ##  5 2018-12-20 Eric          Swalwell      Des ~ IA    event spe~
    ##  6 2018-12-20 Andrew        Yang          Des ~ IA    event spe~
    ##  7 2018-12-15 Jeff          Merkley       Torn~ TX    tour      
    ##  8 2018-12-15 Beto          O'Rourke      Torn~ TX    tour      
    ##  9 2018-12-14 Elizabeth     Warren        Balt~ MD    event spe~
    ## 10 2018-12-14 Eric          Swalwell      Manc~ NH    event spe~
    ## # ... with 17 more rows, and 1 more variable: description <chr>

Take advantage of the LUBRIDATE package - a tidyverse package
specifically for dates  
*Note: lubridate needs to be called separately at the top with
library(lubridate) - it doesn’t yet load with library(tidyverse)*

Now watch what we can do:

``` r
events %>% 
  filter(year(date) == 2018)
```

    ## # A tibble: 26 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2018-12-23 Beto          O'Rourke      Torn~ TX    tour      
    ##  2 2018-12-20 Pete          Buttigieg     Des ~ IA    event spe~
    ##  3 2018-12-20 Jeff          Merkley       Des ~ IA    event spe~
    ##  4 2018-12-20 Eric          Swalwell      Des ~ IA    event spe~
    ##  5 2018-12-20 Andrew        Yang          Des ~ IA    event spe~
    ##  6 2018-12-15 Jeff          Merkley       Torn~ TX    tour      
    ##  7 2018-12-15 Beto          O'Rourke      Torn~ TX    tour      
    ##  8 2018-12-14 Elizabeth     Warren        Balt~ MD    event spe~
    ##  9 2018-12-14 Eric          Swalwell      Manc~ NH    event spe~
    ## 10 2018-12-13 Tom           Steyer        Fres~ CA    event spe~
    ## # ... with 16 more rows, and 1 more variable: description <chr>

Just events in January 2019

``` r
events %>% 
  filter(year(date) == 2019,
         month(date) == 1)
```

    ## # A tibble: 61 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2019-01-31 Sherrod       Brown         Perry IA    meet and ~
    ##  2 2019-01-31 Marianne      Williamson    Des ~ IA    campaign ~
    ##  3 2019-01-31 Eric          Swalwell      Exet~ NH    meet and ~
    ##  4 2019-01-31 John          Hickenlooper  Wash~ DC    event spe~
    ##  5 2019-01-30 John          Delaney       Coun~ IA    campaign ~
    ##  6 2019-01-30 Sherrod       Brown         Clev~ OH    rally     
    ##  7 2019-01-30 Howard        Schultz       Tempe AZ    event spe~
    ##  8 2019-01-29 Beto          O'Rourke      El P~ TX    meet and ~
    ##  9 2019-01-29 Michael       Bloomberg     Manc~ NH    event spe~
    ## 10 2019-01-28 Howard        Schultz       New ~ NY    book tour 
    ## # ... with 51 more rows, and 1 more variable: description <chr>

Events earlier than Dec 2018

``` r
events %>% 
  filter(year(date) == 2018,
         month(date) < 12)
```

    ## # A tibble: 6 x 7
    ##   date       cand_restname cand_lastname city  state event_type description
    ##   <date>     <chr>         <chr>         <chr> <chr> <chr>      <chr>      
    ## 1 2018-11-29 Elizabeth     Warren        Wash~ DC    event spe~ Foreign Po~
    ## 2 2018-11-28 Bernie        Sanders       Wash~ DC    event spe~ “Where We ~
    ## 3 2018-11-17 Kamala        Harris        Jack~ MS    campaign ~ Campaign w~
    ## 4 2018-11-16 Andrew        Yang          Iowa~ IA    event spe~ Event at U~
    ## 5 2018-11-16 Deval         Patrick       Char~ SC    event spe~ keynote at~
    ## 6 2018-11-10 Eric          Swalwell      Des ~ IA    event spe~ Spoke with~

Also allows us to do things like, “I only want to see events the *first
week of every month*”

``` r
events %>% 
  filter(day(date) <= 7)
```

    ## # A tibble: 10 x 7
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2010-02-06 John          Delaney       Salt~ UT    event spe~
    ##  2 2019-01-07 Julian        Castro        Ceda~ IA    meet and ~
    ##  3 2019-01-04 Elizabeth     Warren        Des ~ IA    <NA>      
    ##  4 2019-01-03 John          Delaney       Dill~ TX    meet and ~
    ##  5 2018-12-04 Tom           Steyer        Char~ SC    event spe~
    ##  6 2018-12-04 Michael       Bloomberg     Des ~ IA    forum     
    ##  7 2018-12-03 Bernie        Sanders       Wash~ DC    town hall 
    ##  8 2018-12-02 Tulsi         Gabbard       Exet~ NH    meet and ~
    ##  9 2018-12-02 John          Delaney       Siou~ IA    meet and ~
    ## 10 2018-12-01 Amy           Klobuchar     Perry IA    event spe~
    ## # ... with 1 more variable: description <chr>

Who’s visiting Iowa the first week of a month?

``` r
events %>% 
  filter(day(date) <= 7,
         state == "IA")
```

    ## # A tibble: 5 x 7
    ##   date       cand_restname cand_lastname city  state event_type description
    ##   <date>     <chr>         <chr>         <chr> <chr> <chr>      <chr>      
    ## 1 2019-01-07 Julian        Castro        Ceda~ IA    meet and ~ Meetings w~
    ## 2 2019-01-04 Elizabeth     Warren        Des ~ IA    <NA>       Campaign e~
    ## 3 2018-12-04 Michael       Bloomberg     Des ~ IA    forum      "\"Paris t~
    ## 4 2018-12-02 John          Delaney       Siou~ IA    meet and ~ Meet and g~
    ## 5 2018-12-01 Amy           Klobuchar     Perry IA    event spe~ Iowa Farme~

This is helpful but let’s say you’re doing this all the time.  
It may be easier to create new columns to hold these values.

Brings us to another key function of dpylr/tidyverse - **MUTATE**

### ADDING COLUMNS WITH MUTATE

To add a column, you give it a name, then a single equal sign (=), then
define what’s in it.  
Test example:

``` r
events %>% 
  mutate(mycolumn = "hi there")
```

    ## # A tibble: 88 x 8
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
    ## # ... with 78 more rows, and 2 more variables: description <chr>,
    ## #   mycolumn <chr>

``` r
events %>% 
  mutate(electioncycle = 2020)
```

    ## # A tibble: 88 x 8
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
    ## # ... with 78 more rows, and 2 more variables: description <chr>,
    ## #   electioncycle <dbl>

Now let’s try adding our date-related columns. First we’ll try year.

``` r
events %>% 
  mutate(year = year(date))
```

    ## # A tibble: 88 x 8
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
    ## # ... with 78 more rows, and 2 more variables: description <chr>,
    ## #   year <dbl>

We can add multiple columns as part of one mutate call. Let’s do year,
month and day in one swoop.

``` r
events %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))
```

    ## # A tibble: 88 x 10
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
    ## # ... with 78 more rows, and 4 more variables: description <chr>,
    ## #   year <dbl>, month <dbl>, day <int>

This is a good time to remind ourselves that if we want to save our new
columns, need to *create new object* or *overwrite*

``` r
events <- events %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))
```

Now we can use our new columns to filter

``` r
events %>% 
  filter(year == 2019,
         month == 1)
```

    ## # A tibble: 61 x 10
    ##    date       cand_restname cand_lastname city  state event_type
    ##    <date>     <chr>         <chr>         <chr> <chr> <chr>     
    ##  1 2019-01-31 Sherrod       Brown         Perry IA    meet and ~
    ##  2 2019-01-31 Marianne      Williamson    Des ~ IA    campaign ~
    ##  3 2019-01-31 Eric          Swalwell      Exet~ NH    meet and ~
    ##  4 2019-01-31 John          Hickenlooper  Wash~ DC    event spe~
    ##  5 2019-01-30 John          Delaney       Coun~ IA    campaign ~
    ##  6 2019-01-30 Sherrod       Brown         Clev~ OH    rally     
    ##  7 2019-01-30 Howard        Schultz       Tempe AZ    event spe~
    ##  8 2019-01-29 Beto          O'Rourke      El P~ TX    meet and ~
    ##  9 2019-01-29 Michael       Bloomberg     Manc~ NH    event spe~
    ## 10 2019-01-28 Howard        Schultz       New ~ NY    book tour 
    ## # ... with 51 more rows, and 4 more variables: description <chr>,
    ## #   year <dbl>, month <dbl>, day <int>

Show me just Kamala’s events in January

``` r
events %>% 
  filter(year == 2019,
         month == 1,
         cand_lastname == "Harris")
```

    ## # A tibble: 5 x 10
    ##   date       cand_restname cand_lastname city  state event_type description
    ##   <date>     <chr>         <chr>         <chr> <chr> <chr>      <chr>      
    ## 1 2019-01-28 Kamala        Harris        Des ~ IA    town hall  CNN Town H~
    ## 2 2019-01-27 Kamala        Harris        Oakl~ CA    rally      Campaign K~
    ## 3 2019-01-25 Kamala        Harris        Colu~ SC    event spe~ Pink Ice G~
    ## 4 2019-01-24 Kamala        Harris        New ~ NY    talk show  The Daily ~
    ## 5 2019-01-15 Kamala        Harris        Wash~ DC    town hall  NAACP Wome~
    ## # ... with 3 more variables: year <dbl>, month <dbl>, day <int>

### GROUPING AND AGGREGATING

Able to aggregate our campaign trips would be helpful at this point,
right?  
Let’s get into how to do it using the tidyverse and dplyr’s `group_by()`
and `summarise()`

Have you all grouped before in other languages? In base R itself? Let’s
discuss.

Grouping to see how many trips each candidate have been on in our data  
Getting used to `n()`

``` r
events %>% 
  group_by(cand_lastname) %>% 
  summarise(n())
```

    ## # A tibble: 24 x 2
    ##    cand_lastname `n()`
    ##    <chr>         <int>
    ##  1 Biden             6
    ##  2 Bloomberg         6
    ##  3 Booker            6
    ##  4 Brown             2
    ##  5 Buttigieg         2
    ##  6 Castro            6
    ##  7 Delaney           8
    ##  8 Gabbard           1
    ##  9 Garcetti          1
    ## 10 Gillibrand        2
    ## # ... with 14 more rows

now let’s add arrange to see who has the most trips

``` r
# (not run)  
# events %>% 
#   group_by(cand_lastname) %>% 
#   summarise(n()) %>% 
#   arrange(n)
```

hmm - what’s going on here? Look closely and see what the generated
count column is called

``` r
# events %>% 
#   group_by(cand_lastname) %>% 
#   summarise(n()) %>% 
#   arrange("n()")
```

that doesn’t work either. What about this.

``` r
events %>% 
  group_by(cand_lastname) %>% 
  summarise(n()) %>% 
  arrange()
```

    ## # A tibble: 24 x 2
    ##    cand_lastname `n()`
    ##    <chr>         <int>
    ##  1 Biden             6
    ##  2 Bloomberg         6
    ##  3 Booker            6
    ##  4 Brown             2
    ##  5 Buttigieg         2
    ##  6 Castro            6
    ##  7 Delaney           8
    ##  8 Gabbard           1
    ##  9 Garcetti          1
    ## 10 Gillibrand        2
    ## # ... with 14 more rows

Ah - so that sort of works? But not really, how do we get desc

``` r
# events %>% 
#   group_by(cand_lastname) %>% 
#   summarise(n()) %>% 
#   arrange(desc)
```

Oy - this is getting frustrating. How do we solve?  
By doing this: giving the new column a name of our own.  
Check it out:

``` r
events %>% 
  group_by(cand_lastname) %>% 
  summarise(n = n()) 
```

    ## # A tibble: 24 x 2
    ##    cand_lastname     n
    ##    <chr>         <int>
    ##  1 Biden             6
    ##  2 Bloomberg         6
    ##  3 Booker            6
    ##  4 Brown             2
    ##  5 Buttigieg         2
    ##  6 Castro            6
    ##  7 Delaney           8
    ##  8 Gabbard           1
    ##  9 Garcetti          1
    ## 10 Gillibrand        2
    ## # ... with 14 more rows

Now we can do:

``` r
events %>% 
  group_by(cand_lastname) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
```

    ## # A tibble: 24 x 2
    ##    cand_lastname     n
    ##    <chr>         <int>
    ##  1 Delaney           8
    ##  2 Harris            7
    ##  3 Swalwell          7
    ##  4 Warren            7
    ##  5 Biden             6
    ##  6 Bloomberg         6
    ##  7 Booker            6
    ##  8 Castro            6
    ##  9 Hickenlooper      4
    ## 10 O'Rourke          4
    ## # ... with 14 more rows

Bingo  
We can call the new columnn anything we want. “n” is a common thing for
counts,  
but can be anything

``` r
events %>% 
  group_by(cand_lastname) %>% 
  summarise(numtrips = n()) %>% 
  arrange(desc(numtrips))
```

    ## # A tibble: 24 x 2
    ##    cand_lastname numtrips
    ##    <chr>            <int>
    ##  1 Delaney              8
    ##  2 Harris               7
    ##  3 Swalwell             7
    ##  4 Warren               7
    ##  5 Biden                6
    ##  6 Bloomberg            6
    ##  7 Booker               6
    ##  8 Castro               6
    ##  9 Hickenlooper         4
    ## 10 O'Rourke             4
    ## # ... with 14 more rows

Now for the magic  
Because this counting is such a common operation, and because the `n()`
becomes a pain to deal with…  
…there is a special shortcut that we can use that collapses everything
into one function

``` r
events %>% 
  count(cand_lastname)
```

    ## # A tibble: 24 x 2
    ##    cand_lastname     n
    ##    <chr>         <int>
    ##  1 Biden             6
    ##  2 Bloomberg         6
    ##  3 Booker            6
    ##  4 Brown             2
    ##  5 Buttigieg         2
    ##  6 Castro            6
    ##  7 Delaney           8
    ##  8 Gabbard           1
    ##  9 Garcetti          1
    ## 10 Gillibrand        2
    ## # ... with 14 more rows

``` r
events %>% 
  count(cand_lastname) %>% 
  arrange(desc(n))
```

    ## # A tibble: 24 x 2
    ##    cand_lastname     n
    ##    <chr>         <int>
    ##  1 Delaney           8
    ##  2 Harris            7
    ##  3 Swalwell          7
    ##  4 Warren            7
    ##  5 Biden             6
    ##  6 Bloomberg         6
    ##  7 Booker            6
    ##  8 Castro            6
    ##  9 Hickenlooper      4
    ## 10 O'Rourke          4
    ## # ... with 14 more rows

top states visited

``` r
events %>% 
  count(state) %>% 
  arrange(desc(n))
```

    ## # A tibble: 20 x 2
    ##    state     n
    ##    <chr> <int>
    ##  1 IA       21
    ##  2 DC       17
    ##  3 NH       11
    ##  4 TX        8
    ##  5 SC        7
    ##  6 NY        4
    ##  7 CA        3
    ##  8 GA        2
    ##  9 MD        2
    ## 10 NV        2
    ## 11 PR        2
    ## 12 AZ        1
    ## 13 CO        1
    ## 14 FL        1
    ## 15 LA        1
    ## 16 MI        1
    ## 17 MS        1
    ## 18 OH        1
    ## 19 UT        1
    ## 20 VT        1

top months

``` r
events %>% 
  count(month) %>% 
  arrange(desc(n))
```

    ## # A tibble: 4 x 2
    ##   month     n
    ##   <dbl> <int>
    ## 1     1    61
    ## 2    12    20
    ## 3    11     6
    ## 4     2     1

top single day for most trips

``` r
events %>% 
  count(date) %>% 
  arrange(desc(n))
```

    ## # A tibble: 43 x 2
    ##    date           n
    ##    <date>     <int>
    ##  1 2019-01-21     8
    ##  2 2019-01-24     8
    ##  3 2018-12-20     4
    ##  4 2019-01-18     4
    ##  5 2019-01-22     4
    ##  6 2019-01-31     4
    ##  7 2019-01-25     3
    ##  8 2019-01-27     3
    ##  9 2019-01-28     3
    ## 10 2019-01-30     3
    ## # ... with 33 more rows

we can also group by **more than one** variable  
which candidates have gone to which states?

``` r
events %>% 
  count(cand_lastname, state) %>% 
  arrange(state, desc(n))
```

    ## # A tibble: 72 x 3
    ##    cand_lastname state     n
    ##    <chr>         <chr> <int>
    ##  1 Schultz       AZ        1
    ##  2 Harris        CA        1
    ##  3 Hickenlooper  CA        1
    ##  4 Steyer        CA        1
    ##  5 O'Rourke      CO        1
    ##  6 Biden         DC        3
    ##  7 Bloomberg     DC        2
    ##  8 Harris        DC        2
    ##  9 Hickenlooper  DC        2
    ## 10 Sanders       DC        2
    ## # ... with 62 more rows

what about the most frequent types of events

``` r
events %>% 
  count(event_type) %>% 
  arrange(desc(n))
```

    ## # A tibble: 20 x 2
    ##    event_type                                   n
    ##    <chr>                                    <int>
    ##  1 event speech                                37
    ##  2 meet and greet                              16
    ##  3 book tour                                    4
    ##  4 event speech, meet and greet                 4
    ##  5 organizing event                             4
    ##  6 town hall                                    4
    ##  7 tour                                         3
    ##  8 forum                                        2
    ##  9 forum, meet and greet                        2
    ## 10 rally                                        2
    ## 11 <NA>                                         1
    ## 12 campaign announcement                        1
    ## 13 campaign event                               1
    ## 14 campaign events                              1
    ## 15 event speech, town hall                      1
    ## 16 event speech, town hall, meet and greets     1
    ## 17 fundraiser                                   1
    ## 18 house party                                  1
    ## 19 organizing event, house party                1
    ## 20 talk show                                    1

here we’re seeing some potentially dirty data that needs cleaning.  
the event types seem to be inconsistently entered.  
how might we standardize them? let’s take a look.

A function that returns a vector the same length as the input is called
**vectorized**.  
\* `ifelse()`

let’s see `ifelse()` in action

``` r
events %>% 
  mutate(new_type = ifelse(event_type == "event speech", "TEST", event_type)) 
```

    ## # A tibble: 88 x 11
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
    ## # ... with 78 more rows, and 5 more variables: description <chr>,
    ## #   year <dbl>, month <dbl>, day <int>, new_type <chr>

ok now let’s clean a few columns for real

``` r
events %>% 
  mutate(new_type = ifelse(event_type == "campaign event", "event", event_type),
         new_type = ifelse(event_type == "campaign events", "event", new_type),
         new_type = ifelse(event_type == "event speech", "speech", new_type)
         ) 
```

    ## # A tibble: 88 x 11
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
    ## # ... with 78 more rows, and 5 more variables: description <chr>,
    ## #   year <dbl>, month <dbl>, day <int>, new_type <chr>

this can start to get a little tedious though. enter `case_when`

``` r
events %>%
  mutate(new_type = case_when(
            event_type == "campaign event" ~ "event",
            event_type == "campaign events" ~ "event",
            event_type == "event speech" ~ "speech",
            event_type == TRUE ~ "other"
      ))
```

    ## # A tibble: 88 x 11
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
    ## # ... with 78 more rows, and 5 more variables: description <chr>,
    ## #   year <dbl>, month <dbl>, day <int>, new_type <chr>

Of course, you may be asking: wouldn’t it be nice if we could
standardize…  
…based on certain keywords or patterns? Instead of spelling out every
variation.

The answer is yes. Thanks to “string functions”…\!

We’ll show a quick example of what that looks like, and then start from
the beginning in the next module.

``` r
events %>%
  mutate(new_type = case_when(
    str_detect(event_type, "event") ~ "event")
  )
```

    ## # A tibble: 88 x 11
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
    ## # ... with 78 more rows, and 5 more variables: description <chr>,
    ## #   year <dbl>, month <dbl>, day <int>, new_type <chr>

We’ll take a closer look at string functions now using the stringr
package.

First, are there questions? Let’s discuss.
