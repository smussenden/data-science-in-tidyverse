#**** TRANSFORMING DATA ****#

# Takeaways we'll discuss today
  
# * Filter rows basedon certain criteria with `filter()`  
# * Make new variables, with `mutate()`  
# * Make tables of summaries with `summarise()`  
# * Do groupwise operations with `group_by()`
# * Connect operations with `%>%`  
# * Join tables together using 'inner_join()' and 'left_join()'  


#load the packages we'll need
library(tidyverse)
library(lubridate)
  
  
# Toy dataset to use created manually with tribble function (for creating tibbles)
pollution <- tribble(
       ~city,   ~size, ~amount, 
  "New York", "large",      23,
  "New York", "small",      14,
    "London", "large",      22,
    "London", "small",      16,
   "Beijing", "large",      121,
   "Beijing", "small",      56
)

#What are "tibbles"...?
#They're dataframes, with some additional tidyverse-infused features
#Returns more readable output in the console

#let's see the data we just created, you'll see how a tibble view differs in the console
pollution

#since there are only a handful of rows, a bit harder to see - let's try the built-in IRIS data
iris
#can limit rows with head()
head(iris)
#let's see how tibbles differ in their output
as_tibble(iris)



### FILTERING AND SORTING ####

#the tidyverse's dplyr provides intuitive functions for exploring and analyzing dataframes

#let's go back to our little pollution dataset
pollution

#show me only the ones with a "large" size
filter(pollution, size == "large")

#show me only the ones where the city is London
filter(pollution, city == "London")

#for numeric values, you can use boolean operators 
filter(pollution, amount > 20)
filter(pollution, amount <= 22)

#now, let's try filtering based on two different variables
filter(pollution, amount > 20, size == "large") #note the comma separating the filtering terms

#this can still get a little confusing once you wind up with larger amounts of steps to string together.

#enter a glorious feature of the tidyverse: the PIPE %>% 
#the "pipe" - %>% - (shortcut is CTRL/CMD + SHIFT + M) allows you to chain together commands

#watch this, and see how much easier it becomes for a human to think through (and read later!)
pollution %>% 
  filter(size == "large")

#Voila! So what just happened there?
#Think of %>% as the equivalent of "and then do this"...
#It takes the result and then applies something new to it, in sequential order

#This becomes easy to see when we add new functions - let's talk about sorting with arrange()
pollution %>% 
  arrange(amount)

#to sort by highest value, add desc()
pollution %>% 
  arrange(desc(amount))

#now let's go back to our filtering and add arranging too
pollution %>% 
  filter(size == "large") %>% 
  arrange(desc(amount))

#add another filter criteria
pollution %>% 
  filter(size == "large", amount < 100) %>% 
  arrange(desc(amount))

#this can be formatted this way as well, if it's even easier for you to read
#add another filter criteria
pollution %>% 
  filter(size == "large", 
         amount < 100) %>% 
  arrange(desc(amount))

#think about what we just did here -- you can read the code and it intuitively makes sense 
#each step sequentially listed and executes in order




#### PRESIDENTIAL CANDIDATE TRIPS ####

# let's take a look at some more intersting data now and try out some of these methods

# load in data of prez candidate campaign trips between midterms and end of Jan
events <- readRDS("events_saved.rds")

# let's take a look at what we've got
events

# even easier to see a dataset with View()
# click on its name under the environment tab in upper right, or 
View(events)
# can also pipe the results of a chain if we wanted to
events %>% 
  view()
# can you think of when we might find ourselves wanting to do that? (hint: think big)

# Now let's try out some of our filtering and arranging techniques

# show all events in Iowa
events %>% 
  filter(state == "IA")

# Has Kamala Harris been to Iowa?
events %>% 
  filter(state == "IA",
         cand_lastname == "Harris")

# What about another candidate
events %>% 
  filter(state == "IA",
         cand_lastname == "Gillibrand")

# let's talk about **DATE-specific** stuff ####
# if I have a properly formatted date in a dataframe, can I sort by it? Yes.
events %>% 
  filter(state == "IA") %>% 
  arrange(desc(date))

# what if I want to pull out only certain ranges of dates? Several approaches.

# specifiying a specific date using as.Date()
events %>% 
  filter(date < as.Date("2018-12-31"))

# take advantage of the LUBRIDATE package - a tidyverse package specifically for dates
# note: lubridate needs to be called separately at the top with library(lubridate) - it doesn't yet load with library(tidyverse)

# now watch what we can do...
events %>% 
  filter(year(date) == 2018)

#just events in January 2019
events %>% 
  filter(year(date) == 2019,
         month(date) == 1)

#events earlier than Dec 2018
events %>% 
  filter(year(date) == 2018,
         month(date) < 12)






month(events$date)





# Are there questions you're curious about? Let's discuss.











## Quiz 

A function that returns a vector the same length as the input is called **vectorized**.

Which of the following functions are vectorized?

  * `ifelse()`
  * `diff()`
  * `sum()`

You might try these:
```{r}
gapminder %>% 
  mutate(size = ifelse(pop < 10e06, "small", "large"))
```

```{r, error = TRUE}
gapminder %>% 
  mutate(diff_pop = diff(pop))
```

```{r}
gapminder %>% 
  mutate(total_pop = sum(as.numeric(pop)))
```

## Your Turn 5

Alter the code to add a `prev_lifeExp` column that contains the life expectancy from the previous record.

(Hint: use cheatsheet, you want to offset elements by one)

**Challenge**: Why isn't this quite the 'life expectency five years ago'?

```{r}
gapminder %>%
  mutate()
```

## Your Turn 6

Use summarise() to compute three statistics about the data:

* The first (minimum) year in the dataset
* The last (maximum) year in the dataset
* The number of countries represented in the data (Hint: use cheatsheet)

```{r}
gapminder 
```

## Your Turn 7

Extract the rows where `continent == "Africa"` and `year == 2007`. 

Then use summarise() and summary functions to find:

1. The number of unique countries
2. The median life expectancy

```{r}
gapminder 
```

## Your Turn 8

Find the median life expectancy by continent in 2007.

```{r}
gapminder %>%
  filter(year == 2007)
```

## Your Turn 9

Brainstorm with your neighbor the sequence of operations to find the country with biggest jump in life expectancy (between any two consecutive records) for each continent.

## Your Turn 10

Find the country with biggest jump in life expectancy (between any two consecutive records) for each continent.

```{r}


```

## Your Turn 11

Use `left_join()` to add the country codes in `country_codes` to the gapminder data.

```{r}
country_codes
```

**Challenge**: Which codes in country_codes have no matches in gapminder?

```{r}

```


***


