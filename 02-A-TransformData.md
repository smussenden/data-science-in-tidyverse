Transforming Data, Part A
================

load the packages we’ll
    need

``` r
library(tidyverse)
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

Toy dataset to use, created manually with
tibbles

``` r
pollution <- tibble(city=c("New York", "New York", "London", "London", "Beijing", "Beijing"),
               size=c("large", "small", "large", "small", "large", "small"),
               amount=c(23, 14, 22, 16, 121, 56))
```

What are “tibbles”…?  
They’re dataframes, with some additional tidyverse-infused features  
Returns more readable output in the console  
let’s see the data we just created, you’ll see how a tibble view differs
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

since there are only a handful of rows, a bit harder to see - let’s try
the built-in IRIS data

``` r
iris
```

    ##     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
    ## 1            5.1         3.5          1.4         0.2     setosa
    ## 2            4.9         3.0          1.4         0.2     setosa
    ## 3            4.7         3.2          1.3         0.2     setosa
    ## 4            4.6         3.1          1.5         0.2     setosa
    ## 5            5.0         3.6          1.4         0.2     setosa
    ## 6            5.4         3.9          1.7         0.4     setosa
    ## 7            4.6         3.4          1.4         0.3     setosa
    ## 8            5.0         3.4          1.5         0.2     setosa
    ## 9            4.4         2.9          1.4         0.2     setosa
    ## 10           4.9         3.1          1.5         0.1     setosa
    ## 11           5.4         3.7          1.5         0.2     setosa
    ## 12           4.8         3.4          1.6         0.2     setosa
    ## 13           4.8         3.0          1.4         0.1     setosa
    ## 14           4.3         3.0          1.1         0.1     setosa
    ## 15           5.8         4.0          1.2         0.2     setosa
    ## 16           5.7         4.4          1.5         0.4     setosa
    ## 17           5.4         3.9          1.3         0.4     setosa
    ## 18           5.1         3.5          1.4         0.3     setosa
    ## 19           5.7         3.8          1.7         0.3     setosa
    ## 20           5.1         3.8          1.5         0.3     setosa
    ## 21           5.4         3.4          1.7         0.2     setosa
    ## 22           5.1         3.7          1.5         0.4     setosa
    ## 23           4.6         3.6          1.0         0.2     setosa
    ## 24           5.1         3.3          1.7         0.5     setosa
    ## 25           4.8         3.4          1.9         0.2     setosa
    ## 26           5.0         3.0          1.6         0.2     setosa
    ## 27           5.0         3.4          1.6         0.4     setosa
    ## 28           5.2         3.5          1.5         0.2     setosa
    ## 29           5.2         3.4          1.4         0.2     setosa
    ## 30           4.7         3.2          1.6         0.2     setosa
    ## 31           4.8         3.1          1.6         0.2     setosa
    ## 32           5.4         3.4          1.5         0.4     setosa
    ## 33           5.2         4.1          1.5         0.1     setosa
    ## 34           5.5         4.2          1.4         0.2     setosa
    ## 35           4.9         3.1          1.5         0.2     setosa
    ## 36           5.0         3.2          1.2         0.2     setosa
    ## 37           5.5         3.5          1.3         0.2     setosa
    ## 38           4.9         3.6          1.4         0.1     setosa
    ## 39           4.4         3.0          1.3         0.2     setosa
    ## 40           5.1         3.4          1.5         0.2     setosa
    ## 41           5.0         3.5          1.3         0.3     setosa
    ## 42           4.5         2.3          1.3         0.3     setosa
    ## 43           4.4         3.2          1.3         0.2     setosa
    ## 44           5.0         3.5          1.6         0.6     setosa
    ## 45           5.1         3.8          1.9         0.4     setosa
    ## 46           4.8         3.0          1.4         0.3     setosa
    ## 47           5.1         3.8          1.6         0.2     setosa
    ## 48           4.6         3.2          1.4         0.2     setosa
    ## 49           5.3         3.7          1.5         0.2     setosa
    ## 50           5.0         3.3          1.4         0.2     setosa
    ## 51           7.0         3.2          4.7         1.4 versicolor
    ## 52           6.4         3.2          4.5         1.5 versicolor
    ## 53           6.9         3.1          4.9         1.5 versicolor
    ## 54           5.5         2.3          4.0         1.3 versicolor
    ## 55           6.5         2.8          4.6         1.5 versicolor
    ## 56           5.7         2.8          4.5         1.3 versicolor
    ## 57           6.3         3.3          4.7         1.6 versicolor
    ## 58           4.9         2.4          3.3         1.0 versicolor
    ## 59           6.6         2.9          4.6         1.3 versicolor
    ## 60           5.2         2.7          3.9         1.4 versicolor
    ## 61           5.0         2.0          3.5         1.0 versicolor
    ## 62           5.9         3.0          4.2         1.5 versicolor
    ## 63           6.0         2.2          4.0         1.0 versicolor
    ## 64           6.1         2.9          4.7         1.4 versicolor
    ## 65           5.6         2.9          3.6         1.3 versicolor
    ## 66           6.7         3.1          4.4         1.4 versicolor
    ## 67           5.6         3.0          4.5         1.5 versicolor
    ## 68           5.8         2.7          4.1         1.0 versicolor
    ## 69           6.2         2.2          4.5         1.5 versicolor
    ## 70           5.6         2.5          3.9         1.1 versicolor
    ## 71           5.9         3.2          4.8         1.8 versicolor
    ## 72           6.1         2.8          4.0         1.3 versicolor
    ## 73           6.3         2.5          4.9         1.5 versicolor
    ## 74           6.1         2.8          4.7         1.2 versicolor
    ## 75           6.4         2.9          4.3         1.3 versicolor
    ## 76           6.6         3.0          4.4         1.4 versicolor
    ## 77           6.8         2.8          4.8         1.4 versicolor
    ## 78           6.7         3.0          5.0         1.7 versicolor
    ## 79           6.0         2.9          4.5         1.5 versicolor
    ## 80           5.7         2.6          3.5         1.0 versicolor
    ## 81           5.5         2.4          3.8         1.1 versicolor
    ## 82           5.5         2.4          3.7         1.0 versicolor
    ## 83           5.8         2.7          3.9         1.2 versicolor
    ## 84           6.0         2.7          5.1         1.6 versicolor
    ## 85           5.4         3.0          4.5         1.5 versicolor
    ## 86           6.0         3.4          4.5         1.6 versicolor
    ## 87           6.7         3.1          4.7         1.5 versicolor
    ## 88           6.3         2.3          4.4         1.3 versicolor
    ## 89           5.6         3.0          4.1         1.3 versicolor
    ## 90           5.5         2.5          4.0         1.3 versicolor
    ## 91           5.5         2.6          4.4         1.2 versicolor
    ## 92           6.1         3.0          4.6         1.4 versicolor
    ## 93           5.8         2.6          4.0         1.2 versicolor
    ## 94           5.0         2.3          3.3         1.0 versicolor
    ## 95           5.6         2.7          4.2         1.3 versicolor
    ## 96           5.7         3.0          4.2         1.2 versicolor
    ## 97           5.7         2.9          4.2         1.3 versicolor
    ## 98           6.2         2.9          4.3         1.3 versicolor
    ## 99           5.1         2.5          3.0         1.1 versicolor
    ## 100          5.7         2.8          4.1         1.3 versicolor
    ## 101          6.3         3.3          6.0         2.5  virginica
    ## 102          5.8         2.7          5.1         1.9  virginica
    ## 103          7.1         3.0          5.9         2.1  virginica
    ## 104          6.3         2.9          5.6         1.8  virginica
    ## 105          6.5         3.0          5.8         2.2  virginica
    ## 106          7.6         3.0          6.6         2.1  virginica
    ## 107          4.9         2.5          4.5         1.7  virginica
    ## 108          7.3         2.9          6.3         1.8  virginica
    ## 109          6.7         2.5          5.8         1.8  virginica
    ## 110          7.2         3.6          6.1         2.5  virginica
    ## 111          6.5         3.2          5.1         2.0  virginica
    ## 112          6.4         2.7          5.3         1.9  virginica
    ## 113          6.8         3.0          5.5         2.1  virginica
    ## 114          5.7         2.5          5.0         2.0  virginica
    ## 115          5.8         2.8          5.1         2.4  virginica
    ## 116          6.4         3.2          5.3         2.3  virginica
    ## 117          6.5         3.0          5.5         1.8  virginica
    ## 118          7.7         3.8          6.7         2.2  virginica
    ## 119          7.7         2.6          6.9         2.3  virginica
    ## 120          6.0         2.2          5.0         1.5  virginica
    ## 121          6.9         3.2          5.7         2.3  virginica
    ## 122          5.6         2.8          4.9         2.0  virginica
    ## 123          7.7         2.8          6.7         2.0  virginica
    ## 124          6.3         2.7          4.9         1.8  virginica
    ## 125          6.7         3.3          5.7         2.1  virginica
    ## 126          7.2         3.2          6.0         1.8  virginica
    ## 127          6.2         2.8          4.8         1.8  virginica
    ## 128          6.1         3.0          4.9         1.8  virginica
    ## 129          6.4         2.8          5.6         2.1  virginica
    ## 130          7.2         3.0          5.8         1.6  virginica
    ## 131          7.4         2.8          6.1         1.9  virginica
    ## 132          7.9         3.8          6.4         2.0  virginica
    ## 133          6.4         2.8          5.6         2.2  virginica
    ## 134          6.3         2.8          5.1         1.5  virginica
    ## 135          6.1         2.6          5.6         1.4  virginica
    ## 136          7.7         3.0          6.1         2.3  virginica
    ## 137          6.3         3.4          5.6         2.4  virginica
    ## 138          6.4         3.1          5.5         1.8  virginica
    ## 139          6.0         3.0          4.8         1.8  virginica
    ## 140          6.9         3.1          5.4         2.1  virginica
    ## 141          6.7         3.1          5.6         2.4  virginica
    ## 142          6.9         3.1          5.1         2.3  virginica
    ## 143          5.8         2.7          5.1         1.9  virginica
    ## 144          6.8         3.2          5.9         2.3  virginica
    ## 145          6.7         3.3          5.7         2.5  virginica
    ## 146          6.7         3.0          5.2         2.3  virginica
    ## 147          6.3         2.5          5.0         1.9  virginica
    ## 148          6.5         3.0          5.2         2.0  virginica
    ## 149          6.2         3.4          5.4         2.3  virginica
    ## 150          5.9         3.0          5.1         1.8  virginica

that was a lot of output\! can limit rows with head()

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

but let’s see how tibbles differ in their output

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

the tidyverse’s dplyr provides intuitive functions for exploring and
analyzing dataframes

let’s go back to our little pollution dataset

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

show me only the ones with a “large” size

``` r
filter(pollution, size == "large")
```

    ## # A tibble: 3 x 3
    ##   city     size  amount
    ##   <chr>    <chr>  <dbl>
    ## 1 New York large     23
    ## 2 London   large     22
    ## 3 Beijing  large    121

show me only the ones where the city is London

``` r
filter(pollution, city == "London")
```

    ## # A tibble: 2 x 3
    ##   city   size  amount
    ##   <chr>  <chr>  <dbl>
    ## 1 London large     22
    ## 2 London small     16

for numeric values, you can use boolean operators

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

now, let’s try filtering based on two different
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

this can still get a little confusing once you wind up with larger
amounts of steps to string together.

enter a glorious feature of the tidyverse: **the PIPE** `%>%`

the “pipe” (shortcut is CTRL/CMD + SHIFT + M) allows you to chain
together commands

watch this, and see how much easier it becomes for a human to think
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
This becomes easy to see when we add new functions - let’s talk about
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

to sort by highest value, add desc()

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

now let’s go back to our filtering and add arranging too

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

add another filter criteria

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

this can be formatted this way as well, if it’s even easier for you to
read  
add another filter criteria

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

think about what we just did here – you can read the code and it
intuitively makes sense  
each step sequentially listed and executes in order

### PRESIDENTIAL CANDIDATE TRIPS

let’s take a look at some more intersting data now and try out some of
these methods

load in data of prez candidate campaign trips between midterms and end
of Jan

``` r
events <- readRDS("events_saved.rds")
```

let’s take a look at what we’ve got

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

even easier to see a dataset with `View()`  
click on its name under the environment tab in upper right, or

``` r
View(events)
```

can also pipe the results of a chain if we wanted to

``` r
events %>% 
  view()
```

can you think of when we might find ourselves wanting to do that? (hint:
think big)

Now let’s try out some of our filtering and arranging techniques

show all events in Iowa

``` r
events %>% 
  filter(state == "IA")
```

    ## # A tibble: 21 x 10
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2019-01-31 Sherrod       Brown         Sherrod Brown Perry Cresco, Mas~
    ##  2 2019-01-31 Marianne      Williamson    Marianne Wil~ Des ~ <NA>        
    ##  3 2019-01-30 John          Delaney       John Delaney  Coun~ Sioux City,~
    ##  4 2019-01-28 Kamala        Harris        Kamala Harris Des ~ <NA>        
    ##  5 2019-01-27 Eric          Swalwell      Eric Swalwell Mari~ <NA>        
    ##  6 2019-01-27 John          Hickenlooper  John Hickenl~ Des ~ <NA>        
    ##  7 2019-01-25 John          Delaney       John Delaney  Des ~ <NA>        
    ##  8 2019-01-18 Kirsten       Gillibrand    Kirsten Gill~ Siou~ Des Moines  
    ##  9 2019-01-11 John          Delaney       John Delaney  Des ~ Cedar Rapid~
    ## 10 2019-01-09 Tom           Steyer        Tom Steyer    Des ~ <NA>        
    ## # ... with 11 more rows, and 4 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>

Has Kamala Harris been to Iowa?

``` r
events %>% 
  filter(state == "IA",
         cand_lastname == "Harris")
```

    ## # A tibble: 1 x 10
    ##   date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##   <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ## 1 2019-01-28 Kamala        Harris        Kamala Harris Des ~ <NA>        
    ## # ... with 4 more variables: state <chr>, event_type <chr>, sponsor <chr>,
    ## #   description <chr>

What about another candidate

``` r
events %>% 
  filter(state == "IA",
         cand_lastname == "Gillibrand")
```

    ## # A tibble: 1 x 10
    ##   date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##   <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ## 1 2019-01-18 Kirsten       Gillibrand    Kirsten Gill~ Siou~ Des Moines  
    ## # ... with 4 more variables: state <chr>, event_type <chr>, sponsor <chr>,
    ## #   description <chr>

let’s talk about **DATE-specific** stuff  
if I have a properly formatted date in a dataframe, can I sort by it?
*Yes.*

``` r
events %>% 
  filter(state == "IA") %>% 
  arrange(desc(date))
```

    ## # A tibble: 21 x 10
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2019-01-31 Sherrod       Brown         Sherrod Brown Perry Cresco, Mas~
    ##  2 2019-01-31 Marianne      Williamson    Marianne Wil~ Des ~ <NA>        
    ##  3 2019-01-30 John          Delaney       John Delaney  Coun~ Sioux City,~
    ##  4 2019-01-28 Kamala        Harris        Kamala Harris Des ~ <NA>        
    ##  5 2019-01-27 Eric          Swalwell      Eric Swalwell Mari~ <NA>        
    ##  6 2019-01-27 John          Hickenlooper  John Hickenl~ Des ~ <NA>        
    ##  7 2019-01-25 John          Delaney       John Delaney  Des ~ <NA>        
    ##  8 2019-01-18 Kirsten       Gillibrand    Kirsten Gill~ Siou~ Des Moines  
    ##  9 2019-01-11 John          Delaney       John Delaney  Des ~ Cedar Rapid~
    ## 10 2019-01-09 Tom           Steyer        Tom Steyer    Des ~ <NA>        
    ## # ... with 11 more rows, and 4 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>

what if I want to pull out only certain ranges of dates? *Several
approaches.* specifiying a specific date using as.Date()

``` r
events %>% 
  filter(date < as.Date("2018-12-31"))
```

    ## # A tibble: 27 x 10
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2010-02-06 John          Delaney       John Delaney  Salt~ <NA>        
    ##  2 2018-12-23 Beto          O'Rourke      Beto O'Rourke Torn~ <NA>        
    ##  3 2018-12-20 Pete          Buttigieg     Pete Buttigi~ Des ~ <NA>        
    ##  4 2018-12-20 Jeff          Merkley       Jeff Merkley  Des ~ <NA>        
    ##  5 2018-12-20 Eric          Swalwell      Eric Swalwell Des ~ <NA>        
    ##  6 2018-12-20 Andrew        Yang          Andrew Yang   Des ~ <NA>        
    ##  7 2018-12-15 Jeff          Merkley       Jeff Merkley  Torn~ <NA>        
    ##  8 2018-12-15 Beto          O'Rourke      Beto O'Rourke Torn~ <NA>        
    ##  9 2018-12-14 Elizabeth     Warren        Elizabeth Wa~ Balt~ <NA>        
    ## 10 2018-12-14 Eric          Swalwell      Eric Swalwell Manc~ <NA>        
    ## # ... with 17 more rows, and 4 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>

take advantage of the LUBRIDATE package - a tidyverse package
specifically for dates  
note: lubridate needs to be called separately at the top with
library(lubridate) - it doesn’t yet load with library(tidyverse)

now watch what we can do…

``` r
events %>% 
  filter(year(date) == 2018)
```

    ## # A tibble: 26 x 10
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2018-12-23 Beto          O'Rourke      Beto O'Rourke Torn~ <NA>        
    ##  2 2018-12-20 Pete          Buttigieg     Pete Buttigi~ Des ~ <NA>        
    ##  3 2018-12-20 Jeff          Merkley       Jeff Merkley  Des ~ <NA>        
    ##  4 2018-12-20 Eric          Swalwell      Eric Swalwell Des ~ <NA>        
    ##  5 2018-12-20 Andrew        Yang          Andrew Yang   Des ~ <NA>        
    ##  6 2018-12-15 Jeff          Merkley       Jeff Merkley  Torn~ <NA>        
    ##  7 2018-12-15 Beto          O'Rourke      Beto O'Rourke Torn~ <NA>        
    ##  8 2018-12-14 Elizabeth     Warren        Elizabeth Wa~ Balt~ <NA>        
    ##  9 2018-12-14 Eric          Swalwell      Eric Swalwell Manc~ <NA>        
    ## 10 2018-12-13 Tom           Steyer        Tom Steyer    Fres~ <NA>        
    ## # ... with 16 more rows, and 4 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>

just events in January 2019

``` r
events %>% 
  filter(year(date) == 2019,
         month(date) == 1)
```

    ## # A tibble: 61 x 10
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2019-01-31 Sherrod       Brown         Sherrod Brown Perry Cresco, Mas~
    ##  2 2019-01-31 Marianne      Williamson    Marianne Wil~ Des ~ <NA>        
    ##  3 2019-01-31 Eric          Swalwell      Eric Swalwell Exet~ <NA>        
    ##  4 2019-01-31 John          Hickenlooper  John Hickenl~ Wash~ <NA>        
    ##  5 2019-01-30 John          Delaney       John Delaney  Coun~ Sioux City,~
    ##  6 2019-01-30 Sherrod       Brown         Sherrod Brown Clev~ <NA>        
    ##  7 2019-01-30 Howard        Schultz       Howard Schul~ Tempe <NA>        
    ##  8 2019-01-29 Beto          O'Rourke      Beto O'Rourke El P~ <NA>        
    ##  9 2019-01-29 Michael       Bloomberg     Michael Bloo~ Manc~ Concord, Na~
    ## 10 2019-01-28 Howard        Schultz       Howard Schul~ New ~ <NA>        
    ## # ... with 51 more rows, and 4 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>

events earlier than Dec 2018

``` r
events %>% 
  filter(year(date) == 2018,
         month(date) < 12)
```

    ## # A tibble: 6 x 10
    ##   date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##   <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ## 1 2018-11-29 Elizabeth     Warren        Elizabeth Wa~ Wash~ <NA>        
    ## 2 2018-11-28 Bernie        Sanders       Bernie Sande~ Wash~ <NA>        
    ## 3 2018-11-17 Kamala        Harris        Kamala Harris Jack~ <NA>        
    ## 4 2018-11-16 Andrew        Yang          Andrew Yang   Iowa~ <NA>        
    ## 5 2018-11-16 Deval         Patrick       Deval Patrick Char~ <NA>        
    ## 6 2018-11-10 Eric          Swalwell      Eric Swalwell Des ~ <NA>        
    ## # ... with 4 more variables: state <chr>, event_type <chr>, sponsor <chr>,
    ## #   description <chr>

also allows us to do things like, hmm, I only want to see events the
first week of every month

``` r
events %>% 
  filter(day(date) <= 7)
```

    ## # A tibble: 10 x 10
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2010-02-06 John          Delaney       John Delaney  Salt~ <NA>        
    ##  2 2019-01-07 Julian        Castro        Julian Castro Ceda~ Iowa City, ~
    ##  3 2019-01-04 Elizabeth     Warren        Elizabeth Wa~ Des ~ Council Blu~
    ##  4 2019-01-03 John          Delaney       John Delaney  Dill~ <NA>        
    ##  5 2018-12-04 Tom           Steyer        Tom Steyer    Char~ <NA>        
    ##  6 2018-12-04 Michael       Bloomberg     Michael Bloo~ Des ~ <NA>        
    ##  7 2018-12-03 Bernie        Sanders       Bernie Sande~ Wash~ <NA>        
    ##  8 2018-12-02 Tulsi         Gabbard       Tulsi Gabbard Exet~ Concord     
    ##  9 2018-12-02 John          Delaney       John Delaney  Siou~ <NA>        
    ## 10 2018-12-01 Amy           Klobuchar     Amy Klobuchar Perry <NA>        
    ## # ... with 4 more variables: state <chr>, event_type <chr>, sponsor <chr>,
    ## #   description <chr>

now who’s visiting Iowa the first week of a month

``` r
events %>% 
  filter(day(date) <= 7,
         state == "IA")
```

    ## # A tibble: 5 x 10
    ##   date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##   <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ## 1 2019-01-07 Julian        Castro        Julian Castro Ceda~ Iowa City, ~
    ## 2 2019-01-04 Elizabeth     Warren        Elizabeth Wa~ Des ~ Council Blu~
    ## 3 2018-12-04 Michael       Bloomberg     Michael Bloo~ Des ~ <NA>        
    ## 4 2018-12-02 John          Delaney       John Delaney  Siou~ <NA>        
    ## 5 2018-12-01 Amy           Klobuchar     Amy Klobuchar Perry <NA>        
    ## # ... with 4 more variables: state <chr>, event_type <chr>, sponsor <chr>,
    ## #   description <chr>

This is helpful but let’s say you’re doing this all the time  
It may be easier to create new columns to hold these values  
Brings us to another key function of dpylr/tidyverse - **MUTATE**

### ADDING COLUMNS WITH MUTATE

to add a column, you give it a name, then a single equal sign (=), then
define what’s in it. Test example:

``` r
events %>% 
  mutate(mycolumn = "hi there")
```

    ## # A tibble: 88 x 11
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
    ## # ... with 78 more rows, and 5 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, mycolumn <chr>

``` r
events %>% 
  mutate(electioncycle = 2020)
```

    ## # A tibble: 88 x 11
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
    ## # ... with 78 more rows, and 5 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>,
    ## #   electioncycle <dbl>

now let’s try adding our date-related columns. First we’ll try year.

``` r
events %>% 
  mutate(year = year(date))
```

    ## # A tibble: 88 x 11
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
    ## # ... with 78 more rows, and 5 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, year <dbl>

we can add multiple columns as part of one mutate call. Let’s do year,
month and day in one swoop.

``` r
events %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))
```

    ## # A tibble: 88 x 13
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
    ## # ... with 78 more rows, and 7 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, year <dbl>,
    ## #   month <dbl>, day <int>

this is a good time to remind ourselves that if we want to save our new
columns, need to create new object or overwrite

``` r
events <- events %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))
```

now we can use our new columns to filter

``` r
events %>% 
  filter(year == 2019,
         month == 1)
```

    ## # A tibble: 61 x 13
    ##    date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##    <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ##  1 2019-01-31 Sherrod       Brown         Sherrod Brown Perry Cresco, Mas~
    ##  2 2019-01-31 Marianne      Williamson    Marianne Wil~ Des ~ <NA>        
    ##  3 2019-01-31 Eric          Swalwell      Eric Swalwell Exet~ <NA>        
    ##  4 2019-01-31 John          Hickenlooper  John Hickenl~ Wash~ <NA>        
    ##  5 2019-01-30 John          Delaney       John Delaney  Coun~ Sioux City,~
    ##  6 2019-01-30 Sherrod       Brown         Sherrod Brown Clev~ <NA>        
    ##  7 2019-01-30 Howard        Schultz       Howard Schul~ Tempe <NA>        
    ##  8 2019-01-29 Beto          O'Rourke      Beto O'Rourke El P~ <NA>        
    ##  9 2019-01-29 Michael       Bloomberg     Michael Bloo~ Manc~ Concord, Na~
    ## 10 2019-01-28 Howard        Schultz       Howard Schul~ New ~ <NA>        
    ## # ... with 51 more rows, and 7 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, year <dbl>,
    ## #   month <dbl>, day <int>

show me just Kamala’s events in January

``` r
events %>% 
  filter(year == 2019,
         month == 1,
         cand_lastname == "Harris")
```

    ## # A tibble: 5 x 13
    ##   date       cand_restname cand_lastname cand_fullname city  addtl_cities
    ##   <date>     <chr>         <chr>         <chr>         <chr> <chr>       
    ## 1 2019-01-28 Kamala        Harris        Kamala Harris Des ~ <NA>        
    ## 2 2019-01-27 Kamala        Harris        Kamala Harris Oakl~ <NA>        
    ## 3 2019-01-25 Kamala        Harris        Kamala Harris Colu~ <NA>        
    ## 4 2019-01-24 Kamala        Harris        Kamala Harris New ~ <NA>        
    ## 5 2019-01-15 Kamala        Harris        Kamala Harris Wash~ <NA>        
    ## # ... with 7 more variables: state <chr>, event_type <chr>, sponsor <chr>,
    ## #   description <chr>, year <dbl>, month <dbl>, day <int>

### GROUPING AND AGGREGATING

able to aggregate our campaign trips would be helpful at this point,
right?  
let’s get into how to do it using the tidyverse and dplyr’s `group_by()`
and `summarise()` functions

have you all grouped before in other languages? In base R itself? Let’s
discuss.

grouping to see how many trips each candidate have been on in our data  
getting used to `n()`

``` r
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n())
```

    ## # A tibble: 24 x 2
    ##    cand_fullname    `n()`
    ##    <chr>            <int>
    ##  1 Amy Klobuchar        1
    ##  2 Andrew Yang          2
    ##  3 Bernie Sanders       3
    ##  4 Beto O'Rourke        4
    ##  5 Cory Booker          6
    ##  6 Deval Patrick        1
    ##  7 Elizabeth Warren     7
    ##  8 Eric Garcetti        1
    ##  9 Eric Swalwell        7
    ## 10 Howard Schultz       2
    ## # ... with 14 more rows

now let’s add arrange to see who has the most trips

``` r
# events %>% 
#   group_by(cand_fullname) %>% 
#   summarise(n()) %>% 
#   arrange(n)
```

hmm - what’s going on here? Look closely and see what the generated
count column is called

``` r
# events %>% 
#   group_by(cand_fullname) %>% 
#   summarise(n()) %>% 
#   arrange("n()")
```

that doesn’t work either. What about this.

``` r
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n()) %>% 
  arrange()
```

    ## # A tibble: 24 x 2
    ##    cand_fullname    `n()`
    ##    <chr>            <int>
    ##  1 Amy Klobuchar        1
    ##  2 Andrew Yang          2
    ##  3 Bernie Sanders       3
    ##  4 Beto O'Rourke        4
    ##  5 Cory Booker          6
    ##  6 Deval Patrick        1
    ##  7 Elizabeth Warren     7
    ##  8 Eric Garcetti        1
    ##  9 Eric Swalwell        7
    ## 10 Howard Schultz       2
    ## # ... with 14 more rows

Ah - so that sort of works? But not really, how do we get desc

``` r
# events %>% 
#   group_by(cand_fullname) %>% 
#   summarise(n()) %>% 
#   arrange(desc)
```

Oy - this is getting frustrating. How do we solve?  
By doing this: giving the new column a name of our own.  
Check it out:

``` r
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n = n()) 
```

    ## # A tibble: 24 x 2
    ##    cand_fullname        n
    ##    <chr>            <int>
    ##  1 Amy Klobuchar        1
    ##  2 Andrew Yang          2
    ##  3 Bernie Sanders       3
    ##  4 Beto O'Rourke        4
    ##  5 Cory Booker          6
    ##  6 Deval Patrick        1
    ##  7 Elizabeth Warren     7
    ##  8 Eric Garcetti        1
    ##  9 Eric Swalwell        7
    ## 10 Howard Schultz       2
    ## # ... with 14 more rows

Now we can do:

``` r
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
```

    ## # A tibble: 24 x 2
    ##    cand_fullname         n
    ##    <chr>             <int>
    ##  1 John Delaney          8
    ##  2 Elizabeth Warren      7
    ##  3 Eric Swalwell         7
    ##  4 Kamala Harris         7
    ##  5 Cory Booker           6
    ##  6 Joe Biden             6
    ##  7 Julian Castro         6
    ##  8 Michael Bloomberg     6
    ##  9 Beto O'Rourke         4
    ## 10 John Hickenlooper     4
    ## # ... with 14 more rows

Bingo  
We can call the new columnn anything we want. “n” is a common thing for
counts,  
but can be anything

``` r
events %>% 
  group_by(cand_fullname) %>% 
  summarise(numtrips = n()) %>% 
  arrange(desc(numtrips))
```

    ## # A tibble: 24 x 2
    ##    cand_fullname     numtrips
    ##    <chr>                <int>
    ##  1 John Delaney             8
    ##  2 Elizabeth Warren         7
    ##  3 Eric Swalwell            7
    ##  4 Kamala Harris            7
    ##  5 Cory Booker              6
    ##  6 Joe Biden                6
    ##  7 Julian Castro            6
    ##  8 Michael Bloomberg        6
    ##  9 Beto O'Rourke            4
    ## 10 John Hickenlooper        4
    ## # ... with 14 more rows

Now for the magic  
Because this counting is such a common operation, and because the `n()`
becomes a pain to deal with…  
…there is a special shortcut that we can use that collapses everything
into one function

``` r
events %>% 
  count(cand_fullname)
```

    ## # A tibble: 24 x 2
    ##    cand_fullname        n
    ##    <chr>            <int>
    ##  1 Amy Klobuchar        1
    ##  2 Andrew Yang          2
    ##  3 Bernie Sanders       3
    ##  4 Beto O'Rourke        4
    ##  5 Cory Booker          6
    ##  6 Deval Patrick        1
    ##  7 Elizabeth Warren     7
    ##  8 Eric Garcetti        1
    ##  9 Eric Swalwell        7
    ## 10 Howard Schultz       2
    ## # ... with 14 more rows

``` r
events %>% 
  count(cand_fullname) %>% 
  arrange(desc(n))
```

    ## # A tibble: 24 x 2
    ##    cand_fullname         n
    ##    <chr>             <int>
    ##  1 John Delaney          8
    ##  2 Elizabeth Warren      7
    ##  3 Eric Swalwell         7
    ##  4 Kamala Harris         7
    ##  5 Cory Booker           6
    ##  6 Joe Biden             6
    ##  7 Julian Castro         6
    ##  8 Michael Bloomberg     6
    ##  9 Beto O'Rourke         4
    ## 10 John Hickenlooper     4
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
  count(cand_fullname, state) %>% 
  arrange(state, desc(n))
```

    ## # A tibble: 72 x 3
    ##    cand_fullname     state     n
    ##    <chr>             <chr> <int>
    ##  1 Howard Schultz    AZ        1
    ##  2 John Hickenlooper CA        1
    ##  3 Kamala Harris     CA        1
    ##  4 Tom Steyer        CA        1
    ##  5 Beto O'Rourke     CO        1
    ##  6 Joe Biden         DC        3
    ##  7 Bernie Sanders    DC        2
    ##  8 John Hickenlooper DC        2
    ##  9 Kamala Harris     DC        2
    ## 10 Michael Bloomberg DC        2
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

    ## # A tibble: 88 x 14
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
    ## # ... with 78 more rows, and 8 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, year <dbl>,
    ## #   month <dbl>, day <int>, new_type <chr>

ok now let’s clean a few columns for real

``` r
events %>% 
  mutate(new_type = ifelse(event_type == "campaign event", "event", event_type),
         new_type = ifelse(event_type == "campaign events", "event", new_type),
         new_type = ifelse(event_type == "event speech", "speech", new_type)
         ) 
```

    ## # A tibble: 88 x 14
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
    ## # ... with 78 more rows, and 8 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, year <dbl>,
    ## #   month <dbl>, day <int>, new_type <chr>

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

    ## # A tibble: 88 x 14
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
    ## # ... with 78 more rows, and 8 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, year <dbl>,
    ## #   month <dbl>, day <int>, new_type <chr>

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

    ## # A tibble: 88 x 14
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
    ## # ... with 78 more rows, and 8 more variables: state <chr>,
    ## #   event_type <chr>, sponsor <chr>, description <chr>, year <dbl>,
    ## #   month <dbl>, day <int>, new_type <chr>

We’ll take a closer look at string functions now using the stringr
package.

First, are there questions? Let’s discuss.
