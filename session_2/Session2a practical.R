### exercises

# 1. Find the median lifeExp for Ecuador across years

# 2. Display lifeExp by year for Ecuador

# 3. display gapminder first and last four
# row for countries in Oceania
# in ascending and descending order of population

# 4.find the 5 countries with largest 
#  lifeExp in Europe in the 21st century


# 5. Find the country and the year with 
# maximum lifeExp

# 6. Find the country and the year 
# with minimum lifeExp in Africa


# 7. Generate a variable with the log10 of gdpPercap
#    and add it to gapminder tibble in the .GlobalEnv

# 8. Create a tibble with median lifeExp by continent

# 9. Create a tibble with median lifeExp by country

# 10. Compute the median lifeExp by country and 
# display the results by continent

# 11. Find the 8 countries with largest 
# population in 1967 in Asia and display them
# in descending order; hint: use top_n()


# 12. Use three forms of specifying variables in 
# select() - refer to continent, country, year, and pop
# hint: use start_with, position and variable (NOT variable name!)
# and find the 8 Asian countries with largest population
# in 1967, and display them in ascending order

# In question 13 you'll need dplyr::lag(x,n), 
# which shifts a vector by the number of positions 
# specified in its argument n
# for example:

# dplyr::lag(1:10, 1)  # 
# returns: [1] NA  1  2  3  4  5  6  7  8  9
# in this case using the :: notation to specify the 
# library is important because there are other functions
# called lag in other loaded libraries which don't do 
# what we need

# 13. compute yearly change in lifeExp by country
