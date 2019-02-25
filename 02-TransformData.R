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

# just events in January 2019
events %>% 
  filter(year(date) == 2019,
         month(date) == 1)

# events earlier than Dec 2018
events %>% 
  filter(year(date) == 2018,
         month(date) < 12)

# also allows us to do things like, hmm, I only want to see events the first week of every month 
events %>% 
  filter(day(date) <= 7)

# now who's visiting Iowa the first week of a month 
events %>% 
  filter(day(date) <= 7,
         state == "IA")


# This is helpful but let's say you're doing this all the time
# It may be easier to create new columns to hold these values
# Brings us to another key function of dpylr/tidyverse - **MUTATE**

#### ADDING COLUMNS WITH MUTATE ####

# to add a column, you give it a name, then a single equal sign (=), then define what's in it. Test example:
events %>% 
  mutate(mycolumn = "hi there")

events %>% 
  mutate(electioncycle = 2020)

# now let's try adding our date-related columns.  First we'll try year.
events %>% 
  mutate(year = year(date))

# we can add multiple columns as part of one mutate call. Let's do year, month and day in one swoop.
events %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))

# this is a good time to remind ourselves that if we want to save our new columns, need to create new object or overwrite
events <- events %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))

# now we can use our new columns to filter
events %>% 
  filter(year == 2019,
         month == 1)

# show me just Kamala's events in January
events %>% 
  filter(year == 2019,
         month == 1,
         cand_lastname == "Harris")


#### GROUPING AND AGGREGATING ####

# able to aggregate our campaign trips would be helpful at this point, right?
# let's get into how to do it using the tidyverse and dplyr's group_by() and summarise() functions

# have you all grouped before in other languages? In base R itself?  Let's discuss.

# grouping to see how many trips each candidate have been on in our data
# getting used to n()
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n())

# now let's add arrange to see who has the most trips
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n()) %>% 
  arrange(n)

# hmm - what's going on here? Look closely and see what the generated count column is called
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n()) %>% 
  arrange("n()")

# that doesn't work either.  What about this.
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n()) %>% 
  arrange()

# Ah - so that sort of works? But not really, how do we get desc
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n()) %>% 
  arrange(desc)

# Oy - this is getting frustrating. How do we solve?
# By doing this: giving the new column a name of our own. Check it out:
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n = n()) 

# Now we can do:
events %>% 
  group_by(cand_fullname) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))

# Bingo
# We can call the new columnn anything we want. "n" is a common thing for counts, but can be anything
events %>% 
  group_by(cand_fullname) %>% 
  summarise(numtrips = n()) %>% 
  arrange(desc(numtrips))

# Now for the magic
# Because this counting is such a common operation, and because the n() becomes a pain to deal with...
# ...there is a special shortcut that we can use that collapses everything into one function
events %>% 
  count(cand_fullname)

events %>% 
  count(cand_fullname) %>% 
  arrange(desc(n))

# top states visited
events %>% 
  count(state) %>% 
  arrange(desc(n))

# top months
events %>% 
  count(month) %>% 
  arrange(desc(n))

# top single day for most trips
events %>% 
  count(date) %>% 
  arrange(desc(n))

# we can also group by **more than one** variable
# which candidates have gone to which states?
events %>% 
  count(cand_fullname, state) %>% 
  arrange(state, desc(n))

# what about the most frequent types of events
events %>% 
  count(event_type) %>% 
  arrange(desc(n))

# here we're seeing some potentially dirty data that needs cleaning.
# the event types seem to be inconsistently entered.
# how might we standardize them? let's take a look.

# A function that returns a vector the same length as the input is called **vectorized**.
# * ifelse()

# let's see ifelse() in action
events %>% 
  mutate(new_type = ifelse(event_type == "event speech", "TEST", event_type)) %>% 
  View()

# ok now let's clean a few columns for real
events %>% 
  mutate(new_type = ifelse(event_type == "campaign event", "event", event_type),
         new_type = ifelse(event_type == "campaign events", "event", new_type),
         new_type = ifelse(event_type == "event speech", "speech", new_type)) %>% 
  View()

# this can start to get a little tedious though...  so enter **case_when()**
events %>%
  mutate(new_type = case_when(
            event_type == "campaign event" ~ "event",
            event_type == "campaign events" ~ "event",
            event_type == "event speech" ~ "speech",
            event_type == TRUE ~ "other"
      ))







# Are there questions you're curious about? Let's discuss.










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


