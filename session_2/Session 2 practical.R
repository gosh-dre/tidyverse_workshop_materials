
# TIBBLE and PIPE ---------------------------------------------------------

# list three ways in which the tibble differs from the data frame
# provide code to illustrate the differences



# create a tibble of a family of four, giving position, name and age



# now create it as a tribble (enter a tibble row-wise)



# find the dimensions of gapminder using the pipe




# using the pipe draw a sample x of 100 random normal deviates with mean 100 and SD 15



# plot  lifeExp versus year in gapminder



# PIVOT_LONGER and PIVOT_WIDER --------------------------------------------

# show lifeExp by country and year by switching gapminder from long to wide format
# with years as separate columns



# convert your answer back to long format



# repeat the exercise with countries as separate columns



# calculate mean population in millions by continent using argument values_fn



# convert back to long format



# convert result to a named vector, using deframe or otherwise




# JOIN --------------------------------------------------------------------

# example tibble
y <- tibble(continent = 'Asia',
            country = 'Afghanistan',
            year = 1962:1967, # only some years relevant
            new = 'RED') # new column

# write code to exclude the rows in y from gapminder



# contrast this with using semi_join()



# how does the result of semi_join() differ from that of inner_join() ?



# how does the result of bind_rows() differ from that of full_join() ?



# construct tibbles x and y of different dimensions
# see how bind_rows and bind_cols handle them



# thinking of inner_join, left_join, right_join and full_join
# what is the relationship between the numbers of tibble rows returned by each function ?



