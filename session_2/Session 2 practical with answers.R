# TIBBLE and PIPE
# load libraries
library(tidyverse)
library(gapminder)

# list three ways in which the tibble differs from the data frame
# provide code to illustrate the differences

# characters not coerced to factors, list-columns ok, column names unmodified,
# columns can refer to previous columns

# create a tibble of a family of four, giving position, name and age
tibble(position = c('father', 'mother', 'son', 'daughter'),
       name = c('fred', 'sally', 'mario', 'lucy'),
       age = c(30, 32, 6, 4))

# now create it as a tribble (enter a tibble row-wise)
tribble(
  ~position, ~name, ~age,
  'father', 'fred', 30,
  'mother', 'sally', 32,
  'son', 'mario', 6,
  'daughter', 'lucy', 4
)

# find the dimensions of gapminder using the pipe
gapminder %>%
  dim()

# using the pipe draw a sample x of 100 random normal deviates with mean 100 and SD 15
x <- 100 %>%
  rnorm(mean = 100, sd = 15)

# plot  lifeExp versus year in gapminder
gapminder %>%
  plot(lifeExp ~ year, data = .)

# PIVOT_LONGER and PIVOT_WIDER

# show lifeExp by country and year by switching gapminder from long to wide format
# with years as separate columns
wide2 <- gapminder %>%
  select(c(country, year, lifeExp)) %>%
  pivot_wider(names_from = year, values_from = lifeExp)

# convert your answer back to long format
wide2 %>%
  pivot_longer(-country, names_to = 'year', values_to = 'lifeExp')

# repeat the exercise with countries as separate columns
gapminder %>%
  select(c(country, year, lifeExp)) %>%
  pivot_wider(names_from = country, values_from = lifeExp)

# calculate mean population in millions by continent using argument values_fn
wide3 <- gapminder %>%
  mutate(pop = pop / 1e6) %>%
  select(name = continent, value = pop) %>%
  pivot_wider(values_fn = mean)

# convert back to long format
long3 <- wide3 %>%
  pivot_longer(everything(), names_to = 'continent', values_to = 'pop')

# convert result to a named vector, using deframe or otherwise
long3 %>%
  deframe()

# JOIN

# example tibble
y <- tibble(continent = 'Asia',
            country = 'Afghanistan',
            year = 1962:1967, # only some years relevant
            new = 'RED') # new column

# write code to exclude the rows in y from gapminder
gapminder %>%
  anti_join(y)

# contrast this with using semi_join()
gapminder %>%
  semi_join(y)

# how does the result of semi_join() differ from that of inner_join() ?
gapminder %>%
  inner_join(y)
# inner_join adds the new column, semi_join doesn't

# how does the result of bind_rows() differ from that of full_join() ?
gapminder %>%
  full_join(y)
gapminder %>%
  bind_rows(y)
# bind_rows has extra rows and doesn't match columns

# construct tibbles x and y of different dimensions
# see how bind_rows and bind_cols handle them
# bind_rows is not fussy, bind_cols requires nrows to be equal

# thinking of inner_join, left_join, right_join and full_join
# what is the relationship between the numbers of tibble rows returned by each function ?
# full_join = left_join + right+join - inner_join
# 1708 = 1704 + 6 - 2

