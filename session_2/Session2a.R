### MCB, 24.11.22

library(tidyverse)
library(gapminder)

# We have seen how the tidyverse pipe operator 
# %>% concatenates functions and how to 
# generate tibbles with long and wide formats. 
# We'll now explore some verbs designed to
# manage tibbles. These verbs are part of the
# library dplyr; note that as it's part of the 
# tidyverse it is loaded when we say
# library(tidyverse)
 
search() 
# Shows all libraries loaded in this session
# ordered as they were called

# [1] ".GlobalEnv"        "package:gapminder"
# [3] "package:forcats"   "package:stringr"  
# [5] "package:dplyr"     "package:purrr"    
# [7] "package:readr"     "package:tidyr"    
# [9] "package:tibble"    "package:ggplot2"  
# [11] "package:tidyverse" "tools:rstudio"    
# [13] "package:stats"     "package:graphics" 
# [15] "package:grDevices" "package:utils"    
# [17] "package:datasets"  "package:devtools" 
# [19] "package:usethis"   "package:methods"  
# [21] "Autoloads"         "org:r-lib"        
# [23] "package:base" 

# In this session we'll show how to use 
# the five basic verbs defined in library dplyr:

#      select, filter, arrange,
#      mutate, summarise

# We'll also look at the most important 
# grouping verb in dplyr:

#      group_by

# We'll show how they fit in this architecture
# and will demonstrate their use in data management.  

# Let's look at the gapminder tibble
class(gapminder)
# [1] "tbl_df"     "tbl"        "data.frame"

names(gapminder)
# "country"   "continent" "year"      "lifeExp"  
# "pop"       "gdpPercap"


### filter, select, mutate, summarise, group_by,
### rename, ungroup, 
### pull, arrange, desc, 
### slice_min, slice - pick up rows
### order_by??
### arguments of tidy select: 
### starts_with, end_with, contains...

####### dplyr::select ####

# Selects variables in a tibble
# Useful to avoid printing all variables
# and to use only a subset of variables in pipes

# Examples

gapminder ### doesn't print all variables

gapminder %>% select(country, year, lifeExp)
### variables selected by name

gapminder %>% select(1,3,4)
### variables selected by position

gapminder %>% select(country:year)
### variables selected as a range
gapminder %>% select( 1:3)
### same result

gapminder %>% select(starts_with("c"))
gapminder %>% select(ends_with("p"))
# select using patterns in variables' names
# - useful when there are lots of variables
#   with names appearing in clusters


####### dplyr::filter ####

# Selects rows (usually representing individuals)
# in a tibble
# Useful to subset datasets in order to:
# print only some columns and to use only 
# a subset of variables in pipes and analysis

# Examples

gapminder %>% filter(country=="Ethiopia")
# simple selection

gapminder %>% filter(country=="Ethiopia" &
                     year >= 2000)
# combine two variables in the selection

gapminder %>% filter(str_detect(
                    country,("Z")))
# searches for individuals whose values 
# within a variable (e.g country)
# contain a string (e.g. "Z")
# 
# includes, e.g. New Zealand, Zambia, Zimbabwe...
# to look for cases corresponding to countries
# whose names starts with "Z", or "Zi":

gapminder %>% filter(str_detect(
                     country,("^Z")))

gapminder %>% filter(str_detect(
                     country,("Zi")))

# two more examples, with numerical variables
gapminder %>% filter(lifeExp>82)
# 
gapminder %>% filter(lifeExp==max(lifeExp))

gapminder %>% filter(lifeExp>=40 & lifeExp<=50)


####### dplyr::arrange ####

# Orders the rows of a tibble 
# by the values of selected columns;
# it also reorder columns of a tibble
# Useful to examine parts of a tibble

# Examples

gapminder %>% arrange(lifeExp)
# lowest to highest

gapminder %>% arrange(desc(lifeExp))
# desc() specifies descending order

gapminder %>% arrange(-lifeExp)
# same as previous example
# note that the values of lifeExp remain unchanged

# ordering can be defined by two or more variables
gapminder %>% arrange(continent, lifeExp) %>%
              head(4)
# orders by lifeExp within country

gapminder %>% arrange(lifeExp, continent) %>% 
              head(4)
# note how the order of the variables matters

# combine descending and ascending
gapminder %>% 
  arrange(continent, country, desc(lifeExp)) %>%
  tail(6)

# use acros() to specify subsets of names

gapminder %>%
  arrange(across(starts_with("c")))

gapminder %>%
  arrange(across(contains("p"))) %>%
  select(c("country", contains("p"))) %>%
  head(5)

gapminder %>%
  arrange(across(contains("p"))) %>%
  select(c(country, contains("p"))) %>%
  head(5)

gapminder %>%
  arrange(across(contains("p"))) %>%
  select(country, lifeExp, pop, gdpPercap) %>%
  head(5)

# The three results are equal, note the difference
# between the variables' names (e.g. "country")
# and the variable itself (e.g. country)


####### dplyr::mutate ####

# Generates new variables,add them to the tibble
# and preserves existing ones
# transmute() adds new variables 
# and drops existing ones. 
# New variables overwrite existing variables 
# of the same name. 



# Examples

gapminder <- 
  gapminder %>% mutate(log10_gdpPercap=log10(gdpPercap))
# Generates a new variable logging gdpPercap
# If we don't assign the outcome of 
# mutate() to gapminder we would simply get a printout
# of the tibble
# We could also assign such outcome 
# to another (possibly new) tibble

# Note that there are two  tibbles named "gapminder"
# in our session: the original one (with 6 variables)
# and the new one (with 7 variables).
# The former is in the environment defined by the library
# gapminder - that is, in position 2 of the search() list
# the latter is in the .GlobalEnvironment, i.e. in position 1
# of search()

dim(gapminder::gapminder) ### gapminder in library(gapminder)
# [1] 1704 6
dim(gapminder) ### accessing gapminder in .GlobalEnv
# [1] 1704 7

gapminder %>% summary() ### like summary in base R

gapminder_gdp <- 
  gapminder %>% 
  select(country, pop, gdpPercap) %>%
  transmute(country=country,
            log10_gdpPercap=log10(gdpPercap),
            gdp=pop * gdpPercap) 
## more than one new ones in a new tibble

### transmute() returns only the newly created variables

gapminder_gdpVars <- 
  gapminder %>% 
  transmute(log10_gdpPercap=log10(gdpPercap),
         gdp=pop * gdpPercap) ## more than one new ones

####### dplyr::summarise and group_by ####

# Condenses a variable's values into summary statistics 
# If no groups are identified these summaries 
# apply to the whole set of values

# Examples

gapminder %>% summarise(mean(pop)) ## meaningless?

gapminder %>% summarise(range(year)) 
## returns a vector of length 2

gapminder %>% summarise(summary(gdp)) 
# returns five-numbers summary (min, Q1, Med, Q3, max )

gapminder %>% summarise(n=n(),
                        mean_pop=mean(pop),
                        var_pop=var(pop),
                        min_pop=min(pop),
                        max_pop=max(pop),
                        overdisp_pop=var_pop/mean_pop)
### returns a (named) vector of length 6
### n() has no arguments and counts elements
### note the use of previously defined summaries 
### within summarise() (in overdisp_pop)

gapminder %>%
    summarise(quant_pop=quantile(pop, c(0.25, 0.75)),
              prob=c(0.25, 0.75))
# Note that we're passing a vector of probabilities
# as the second argument to quantile()
# and the long format produced with new variable "prob"

# summarise() is most useful when used with the
# grouping verb group_by() which allows us to
# apply functions across subsets

gapminder %>% 
  group_by(continent) %>%
  summarise(mean_lifeExp=mean(lifeExp))
### returns  tibble with five rows and one column

gapminder %>% 
  group_by(continent) %>%
  summarise(mean_lifeExp=mean(lifeExp),
            min_lifeExp=max(lifeExp),
            max_lifeExp=min(lifeExp),
            mean_pop=mean(pop),
            .groups='drop')
# Four variables across continents.  The argument
# .groups='drop' drop all levels of grouping
###
# Note that the functions used above (mean, min, max)
# return only one number
# If functions returning more than one number are used
# they are vectorised

gapminder %>% 
  group_by(continent) %>%
  summarise(mean_lifeExp=mean(lifeExp),
            range_lifeExp=range(lifeExp),
            mean_pop=mean(pop), 
            .groups='drop')

# Use more than one grouping variable

gapminder %>% 
  group_by(continent, year) %>%
  summarise(median_lifeExp=median(lifeExp)) %>%
  head(4)
# condenses lifeExp using medians across countries
# within continents, for each year

# Use more than one grouping variable

gapminder %>% 
  group_by(year, continent) %>%
  summarise(median_lifeExp=median(lifeExp)) %>%
  head(4)

gapminder %>% 
  group_by(year, continent) %>%
  summarise(median_lifeExp=median(lifeExp)) %>%
  head(4)

###### combining verbs ####

# The pipe architecture allows huge flexibility 

gapminder %>% 
  select(continent, country, gdpPercap, year) %>%
  filter(continent=='Americas' & year>=2000) %>% 
  group_by(country) %>%
  mutate(relative_gdpPC=gdpPercap/max(gdpPercap)) %>%
  head(4)
  
  
  
  
  
  




############### hasta aqui ####

gapminder %>% 
  select(continent, country, lifeExp) %>%
  group_by(continent) %>% 
  top_n(n=2) %>% 
  arrange(desc(-lifeExp))

gapminder %>% 
  select(continent, country, year, lifeExp) %>%
  group_by(continent, country) %>%
  dplyr::slice_max(lifeExp,n=3) %>%
  dplyr::arrange(desc(lifeExp))
              
### contrast with 

gapminder %>% 
  select(continent, country, year, lifeExp) %>%
  group_by(continent) %>%
  dplyr::slice_max(lifeExp,n=3) %>%
  dplyr::arrange(desc(lifeExp))


### ideas for exercises

### 0. SIMPLER examples of mutate etc
gapminder_copy<- gapminder

last_year_data <-
gapminder %>% 
   filter(year==max(year))

last_year_data <-
  gapminder %>% 
  filter(year==max(year) & continent=='Africa')

gapminder <- 
  gapminder %>% mutate(log10_gdpPercap=log10(gdpPercap))

gapminder %>% select(country, log10_gdpPercap)

gapminder %>% summary() ### like summary in base R
###

2 %>% `+` (log(1:5)) ### ok


### build up the pipe's size, first focus on individual verbs
### 1. compute median lifeExp by country over the years

###start with something simpler!

median_lifeExp<-
gapminder %>% ### add filter?
  select(country, year, continent, lifeExp) %>%
  group_by(country, continent) %>%
  summarise(lifeExp_median=median(lifeExp),
            .groups="drop") 

gapminder %>% ### order in select matters
  select(year, country, continent, lifeExp) %>%
  group_by(country, continent) %>%
  summarise(lifeExp_median=median(lifeExp),
            .groups="drop") 
  
gapminder %>% ### order in group_by matters
  select(year, country, continent, lifeExp) %>%
  group_by(continent, country) %>%
  summarise(lifeExp_median=median(lifeExp),
            .groups="drop") 


test<-
gapminder %>% 
  transmute(log10(pop))### select and rename
### direct description
names(`test`)

gapminder %>% 
  transmute(log10pop=log10(pop))### select and rename
### direct description



gapminder %>% 
  select(popnew=pop) %>%
  mutate(log10(popnew))### select and rename


### check
head(median_lifeExp,2) ### lists first two rows

gapminder %>% 
  filter(country=="Afghanistan") %>% 
  summarise(median=median(lifeExp)) ## 39.1 years - OK

### median of medians by continent
median_lifeExp %>% 
  group_by(continent) %>%
  summarise(median=median(lifeExp_median))

### 2. compute yearly change in lifeExp by country

dim(gapminder) ### 1704 x 6

test <- 
  gapminder %>%
  select(country, year, lifeExp) %>%
  mutate(lifeExp_yearlyDiff=diff(lifeExp))

### doesn't work!

### use function dplyr::lag, which shifts a vector by
### the number of positions specified in its argument n


lifeExp_yearlyDiff <- 
  gapminder %>% 
  select(country, continent, year,  lifeExp) %>%
  group_by(country) %>% 
  mutate(lifeExp_yearlyDiff = 
           lifeExp - lag(lifeExp,n=1))

lifeExp_yearlyDiff    
### OK but we would like yearly rates of change

lifeExp_yearlyDiff <-
  lifeExp_yearlyDiff %>%
  group_by(country) %>%
  mutate(number_years = year - lag(year,n=1))
### OK now compute rate of change in lifeExp

lifeExp_yearlyDiff <-
  lifeExp_yearlyDiff %>%
  group_by(country) %>%
  mutate(lifeExp_yearlyRate = 
           lifeExp_yearlyDiff/number_years)

lifeExp_yearlyDiff ## OK

### this can be done in one sequence of pipes

lifeExp_yearlyDiff <- 
  gapminder %>% 
  select(country, continent, year, lifeExp) %>%
  group_by(country) %>% 
  mutate(lifeExp_yearlyDiff = 
           lifeExp - (lifeExp,n=1),
         number_years = 
           year - (year,n=1),
         lifeExp_yearlyRate = 
           lifeExp_yearlyDiff/number_years)

lifeExp_yearlyDiff %>% 
  select(country, continent,
         year, lifeExp, lifeExp_yearlyRate) %>%
  group_by(continent, country) %>% ## note order
  slice_min(lifeExp_yearlyRate,n=1) %>%
  arrange(desc(lifeExp_yearlyRate))
### use slice only but mention its flavours
### put this into ONE pipe



  gapminder %>% 
    filter(continent=="Asia") %>%
    pull(pop) %>% 
    quantile()
  
  
  gapminder %>% 
    filter(continent=="Asia") %>%
    arrange(desc(pop))
  
  gapminder %>% 
    filter(continent=="Asia") %>%
    arrange(-pop)

 
  
  
  ### find the 5 countries with largest 
  ### lifeExp in Europe in the 21st century
  
  gapminder %>% 
     filter(year>1999, 
            continent=="Europe") %>%
     slice_max(lifeExp, n=5)
  
  ### find the 8 countries with smallest 
  ### population in 1967 in Asia
  
  gapminder %>% 
    select(year, continent, pop) %>%
    filter(year==1967, 
           continent=="Asia") %>%
    slice_min(pop, n=8) %>% 
    arrange(pop)
  
  gapminder %>%
    select(c(1:3,5)) %>% ## by position
    filter(year==1967, 
           continent=="Asia") %>%
    slice_min(pop, n=8) %>% 
    arrange(pop)
  
  gapminder %>%
    select(starts_with("co"), 5, year) %>% 
    filter(year==1967, 
           continent=="Asia") %>%
    slice_min(pop, n=8) %>% 
    arrange(pop)
 
  
  
  