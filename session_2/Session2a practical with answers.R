### exercises

# 1. Find the median lifeExp for Ecuador across years

gapminder %>% 
  filter(country=="Ecuador") %>% 
  summarise(median=median(lifeExp)) ## 39.1 years - OK

# 2. Display lifeExp by year for Ecuador

gapminder %>% 
  select(country, year, lifeExp) %>%
  filter(country=="Ecuador") 

# 3. display gapminder first and last four
# row for countries in Oceania
# in ascending and descending order of population

gapminder %>% 
  filter(continent=="Oceania") %>%
  arrange(pop) %>% 
  head(4)

gapminder %>% 
  filter(continent=="Oceania") %>%
  arrange(desc(pop)) %>% 
  head(4)

gapminder %>% 
  filter(continent=="Oceania") %>%
  arrange(pop) %>% 
  tail(4)

gapminder %>% 
  filter(continent=="Oceania") %>%
  arrange(desc(pop)) %>% 
  tail(4)


# 4.find the 5 countries with largest 
#  lifeExp in Europe in the 21st century

gapminder %>% 
  filter(year>1999, 
         continent=="Europe") %>%
  top_n(lifeExp, n=5)

# 5. Find the country and the year with 
# maximum lifeExp

  gapminder %>% 
  select(country, year, lifeExp) %>%
  filter(lifeExp==max(lifeExp))

# 6. Find the country and the year 
# with minimum lifeExp in Africa
  
    gapminder %>% 
      select(continent, country, year, lifeExp) %>%
      filter(lifeExp==min(lifeExp) & 
               continent=='Africa')

# 7. Generate a variable with the log10 of gdpPercap
#    and add it to gapminder tibble in the .GlobalEnv
    
    gapminder <- 
      gapminder %>% 
        mutate(log10_gdpPercap=log10(gdpPercap))
    
# 8. Create a tibble with median lifeExp by continent
    
median_lifeExp_continent<-
  gapminder %>% 
  select(continent, lifeExp) %>%
  group_by(continent) %>%
  summarise(lifeExp_median=median(lifeExp),
            .groups='drop')


# 9. Create a tibble with median lifeExp by country

median_lifeExp_country<-
  gapminder %>% 
  select(country, lifeExp) %>%
  group_by(country) %>%
  summarise(lifeExp_median=median(lifeExp),
            .groups='drop')


# 10. Compute the median lifeExp by country and 
# display the results by continent

gapminder %>%
select( country, continent, lifeExp) %>%
  group_by(continent, country) %>%
  summarise(lifeExp_median=median(lifeExp),
            .groups="drop")

# 11. Find the 8 countries with largest 
# population in 1967 in Asia and display them
# in descending order 
# hint: use top_n()

gapminder %>% 
  select(year,country, continent, pop) %>%
  filter(year==1967, 
         continent=="Asia") %>%
  top_n(pop, n=8) %>% 
  arrange(desc(pop))  

# 12. Use three forms of specifying variables in 
# select() - refer to continent, country, year, and pop
# hint: use start_with, position and variable (NOT variable name!)
# and find the 8 Asian countries with largest population
# in 1967, and display them in ascending order

gapminder %>%
  select(starts_with("co"), year, 5) %>% 
  filter(year==1967, 
         continent=="Asia") %>%
  top_n(pop, n=8) %>% 
  arrange(pop)


# In question 13 you'll need dplyr::lag(x,n), 
# which shifts a vector by the number of positions 
# specified in its argument n
# for example:

dplyr::lag(1:10, 1)  # 
# returns: [1] NA  1  2  3  4  5  6  7  8  9
# in this case using the :: notation to specify the 
# library is important because there are other functions
# called lag in other loaded libraries which don't do 
# what we need

# 13. compute yearly change in lifeExp by country

lifeExp_yearlyDiff <- 
  gapminder %>% 
  select(country, continent, year,  lifeExp) %>%
  group_by(country) %>% 
  mutate(lifeExp_yearlyDiff = 
           lifeExp - dplyr::lag(lifeExp,n=1))

lifeExp_yearlyDiff  %>% 
  head(4)  

# OK but we want yearly rates of change
# Note that displaying a tibble uses fewer 
# decimal positions that we may like


lifeExp_yearlyDiff <-
  lifeExp_yearlyDiff %>%
  group_by(country) %>%
  mutate(number_years = year - lag(year,n=1))
### OK now compute rate of change in lifeExp

lifeExp_yearlyDiff <-
  lifeExp_yearlyDiff %>%
  group_by(country) %>%
  mutate(number_years = year - lag(year,n=1),
         lifeExp_yearlyRate =  lifeExp_yearlyDiff/number_years)

dim(lifeExp_yearlyDiff) # 1704 x 7 variables
names(lifeExp_yearlyDiff)
#[1] "country"            "continent"         
#[3] "year"               "lifeExp"           
#[5] "lifeExp_yearlyDiff" "number_years"      
#[7] "lifeExp_yearlyRate"

### display a few variables to check
lifeExp_yearlyDiff %>%
  select(1,3,4,7) %>%  # country, year, lifeExp, lifeExp_yearlyRate
  head(4) ## OK

### this can be done in one sequence of pipes

lifeExp_yearlyDiff <- 
  gapminder %>% 
  select(country, continent, year, lifeExp) %>%
  group_by(country) %>% 
  mutate(lifeExp_yearlyDiff = 
           lifeExp - dplyr::lag(lifeExp,n=1),
         number_years = 
           year - dplyr::lag(year,n=1),
         lifeExp_yearlyRate = 
           lifeExp_yearlyDiff/number_years)






