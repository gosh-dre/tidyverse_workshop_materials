# The tidyverse is an opinionated collection of R packages designed for data science.
# All packages share an underlying design philosophy, grammar, and data structures.

# Install the tidyverse with:

  # install.packages("tidyverse") # required first time
  library(tidyverse)

# fundamental principle - tidy data - measurements in columns, occasions in rows

  # example of gapminder data - 6 columns, 1704 rows - rectangular layout
  library(gapminder)

  # country
  # continent
  # year
  # lifeExp - life expectancy at birth
  # pop - total population
  # gdpPercap - per-capita GDP (gross domestic product in dollars)

  gapminder

  # gapminder is a form of data frame
  is.data.frame(gapminder)

  # let's force it to be a data frame
  as.data.frame(gapminder)

  # whoops! - problem with big data frames - too much data
  # needs care to work round it
  class(gapminder)

  # data science involves working with data frames
  # tidyverse (being opinionated) uses improved data frames called "tibbles"

  # tibbles display the data on screen along with extra information
  gapminder

  # tibbles also allow columns of lists - powerful for nested analyses
  nest(gapminder, data = -continent)

  # tibbles recognise earlier columns
  tibble(a = 2:3,
         b = a * 4,
         c = letters[a],
         d = LETTERS[b],
         e = list(a, b))

  # note that column names are useful though not essential
  tibble(a = 2:3,
         b = a * 4,
         letters[a],
         LETTERS[b],
         list(a, b))

  # data management (wrangling) involves repeat operations on the data frame
  # but they can get complicated

  # example of multiple functions as one line of code - complicated and obscure
  unique(diff(sqrt((cumsum(rep(1, 9)))^2)))

  # enter THE PIPE - an operator that splits the sequence into its constituent parts

  # it takes the object on the left side and passes (pipes) it to the right side
  # as the first argument of the function
  # lhs %>% rhs

  # the following are equivalent
  #   function(x)       and   x %>% function()
  #   function(x, y)    and   x %>% function(y)
  #   function(x, y, z) and   x %>% function(y, z)

  print('hello world')
  'hello world' %>%
    print()

  rep(1, 9)
  1 %>%
    rep(9)

  seq(2, 8, 4)
  2 %>%
    seq(8, 4)

  # in dplyr (i.e. tidyverse) the pipe operator is %>%
  # - from the magrittr package (Ceci n'est pas une pipe)

  # in base R the pipe is |> (only recently introduced in R 4.1)
  # 'base R pipe' |>
  #   print()

  # learn to type it as the keyboard shortcut ctrl-shift-M or cmd-shift-M (MacOS)
  # set the pipe type ( %>% or |> ) in RStudio code preferences

  # example
  unique(diff(sqrt((cumsum(rep(1, 9)))^2)))

  # with pipe - can see individual elements and work through in sequence
  # good practice to type one function per line

  1 %>%
    rep(9) %>%
    cumsum() %>%
    `^`(2) %>%
    sqrt() %>%
    diff() %>%
    unique()

  # can comment out steps or rearrange them

  # main value of pipe - passing a tibble through a sequence of operations

  # save the result in the usual way from right to left
  top <- gapminder %>%
    head()
  top

  # or more intuitively from left to right
  gapminder %>%
    head() ->
    top
  top

  # by default left side becomes first argument on right side
  # but it can be inserted elsewhere on right side as .
  # contrast
  1:10 %>% plot(y = 11:20)
  # and
  1:10 %>% plot(x = 11:20, y = .)
  # # or with base R pipe use _ not .
  # 1:10 |> plot(x = 11:20, y = _)

  # here are some pipe examples
  # note how the pipe and tibble work together
  # all tibble columns are available in dplyr_verb environment
  gapminder %>%
    nest(data = -continent)

  gapminder %>%
    filter(year == 1967, pop > 1e8) %>%
    mutate(gdp = gdpPercap * pop / 1e6)

  # mean population by continent and year
  gapminder %>%
    group_by(continent, year) %>%
    summarise(mean_pop = mean(pop) / 1e6, .groups = 'drop') %>%
    pivot_wider(names_from = year, values_from = mean_pop)

  # Now over to Mario to tell you about dplyr


  # pivot_wider and pivot_longer

  # consider the 'shape' of a tibble
  # tidy data are rectangular data
  # a tibble where variables are columns and rows are measurements

  # 'wide' format for doing calculations in parallel
  # e.g. relating pop and gdpPercap to get gdp in $billions
  gapminder %>%
    mutate(gdp = gdpPercap * pop / 1e9)

  # 'long' format needed for regression or visualisation (e.g. ggplot)
  # different variables or categories 'stacked' in one column
  # e.g. year
  gapminder

  # use pivot_wider to change year from 'long' to 'wide' format
  # e.g. mean population in millions tabulated by continent and year
  wide1 <- gapminder %>%
    group_by(continent, year) %>%
    summarise(pop = mean(pop) / 1e6, .groups = 'drop')
  wide1

  wide1 <- wide1 %>%
    pivot_wider(names_from = year, values_from = pop)
  wide1

  # reverse the process using pivot_longer to revert from 'wide' to 'long'
  # specify -continent as first argument to exclude it from pivot
  wide1 %>%
    pivot_longer(-continent, names_to = 'year', values_to = 'pop')

  # 'long' format needed for regression or visualisation (e.g. ggplot)
  # combine three numerical variables in one column
  # using default names 'name' and 'value'
  gapminder
  wide2 <- gapminder %>%
    pivot_longer(c(lifeExp, pop, gdpPercap))
  wide2

  # reverse the process with pivot_wider (uses default names)
  wide2 %>%
    pivot_wider()

  # pivot_wider has arguments names_from and values_from - wider FROM
  # pivot_longer has arguments names_to and values_to - longer TO

  # mnemonic - FROM wider TO longer

  # column names need quoting for TO but not for FROM

  # use args() to remember which way round they are
  args(pivot_wider)

  # lots of other arguments make pivot_*() very powerful and flexible
  # but also hard to get to work properly!

  # extreme example - convert tibble to a single row and back again
  widex <- gapminder %>%
    select(c(year, country, lifeExp)) %>%
    pivot_wider(names_from = c(year, country), values_from = lifeExp)
  widex

  # note format of column names of widex
  names(widex)[1]

  widex %>%
    pivot_longer(everything(), names_to = c('year', 'country'), values_to = 'lifeExp',
                 names_sep = '_')

  # BIND

  # simplest way to combine tibbles
  # bind_rows(x, y) # by rows
  # bind_cols(x, y) # by columns (n of rows in x and y need to match)

  # JOIN

  # ways to combine tibbles by rows matched by column(s)
  # included rows have columns from both x and y

  # general form: *_join(x, y)
  # where x and y are tibbles

  # draw Venn diagram (ignore code)
  library(ggforce)
  ggplot(tibble(x = c(-2, 2), y = 0, r = 3, label = c('x', 'y'))) +
    theme_void() +
    coord_fixed() +
    geom_circle(aes(x0 = x, y0 = y, r = r), data = . %>% slice(1)) +
    geom_circle(aes(x0 = x, y0 = y, r = r), data = . %>% slice(2)) +
    geom_text(aes(x, y, label = label), size = 30)

  # inner_join(): includes all rows that are in both x and y
  # left_join(): includes all rows in x
  # right_join(): includes all rows in y
  # full_join(): includes all rows in x or y

  # also
  # semi_join() and anti_join() to exclude rows

  x <- gapminder
  y <- tibble(continent = 'Asia',
               country = 'Afghanistan',
               year = 1962:1967, # only 2 years relevant
               new = 'NEW') # new column

  # rows common to both x and y with columns combined
  gapminder %>%
    inner_join(y)

  # detects common columns for matching - can control with 'by' argument

  # rows in x with y columns added
  gapminder %>%
    left_join(y)

  # rows in y with x columns added
  gapminder %>%
    right_join(y)

  # all rows in x or y with columns combined
  gapminder %>%
    full_join(y)

  # keep just y rows in x
  gapminder %>%
    semi_join(y)

