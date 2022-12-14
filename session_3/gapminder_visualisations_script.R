
## library calls here, if you don't have them installed, run install.packages("<my_package>") and then run the library() calls.

library(tidyverse)
#library(lubridate)
library(scales)
library(janitor)
library(gapminder)
library(plotly)


## print the top 10 rows of the data with head()
head(gapminder)

## print a summary of the data with summary()
summary(gapminder)

## print the structure of the data with str()
str(gapminder)


# Introducing ggplot
## Bar Charts
# There are two types of bar charts:
# - geom_bar()
# - geom_col()
# geom_bar() makes the height of the bar proportional to the number of cases in each group (..count..), (or the sum of the weights if the weight aesthetic is supplied).
# geom_col() instead has the heights of the bars representing the values in the data.


## plot a geom_col and a geom_bar to see the differences
ggp_bar <- ggplot(data = gapminder, aes(x=continent)) +
    geom_bar()

## what is 'count' in this graph?
ggp_bar

## geom_col
ggp_col <- ggplot(data = gapminder %>%
                      filter(continent == "Oceania", year == 2007), aes(x=country, y=pop)) + # can do dataframe manipulation within the data call with pipes.
           geom_col()
## here, y axis is the value for the variable you pass in the aesthetic.
ggp_col

## Now add in more of the layers to one of the plots above
ggp_col2 <- ggplot(data = gapminder %>%
                       filter(continent == "Oceania", year == 2007), aes(x=country, y=pop)) +
    geom_col(aes(fill = country)) + # notice it adds in a legend automatically
    scale_y_continuous(breaks = seq(0,21000000, 2000000)) + #try changing the breaks
    ggtitle("Population of Oceania by country in 2007") +
    labs(y = "Population", x = "Country", fill = "Country") +
    theme_bw()

ggp_col2


## Scatter plots using geom_point()
## plot a scatter plot with geom_point
## work through this a bit at a time to understand what each section does

ggp_scatter <- ggplot(data = gapminder, # data
                      aes(x = gdpPercap, y = lifeExp, colour = continent)) + #aesthetics
    geom_point(alpha = 0.5) + #geometries
    geom_smooth(method = NULL, se = T) +
    facet_wrap(~continent, scales = "free") + #facets
    labs(title = "Life expectancy at birth vs. Per capita GDP", x = "gdpPercap", y = "lifeExp", colour = "Continent") + #labels
    theme_light() + #themes
    theme(axis.text.x = element_text(angle = 45),
          axis.text = element_text(size = 7),
          legend.position = "bottom") +
    NULL #good to include a NULL because of the + convention.

ggp_scatter

## repeat these plots using different variables


## Histograms using geom_hist()
#Histograms are useful to show distributions.
## plot a histogram showing distribution of life expectancy
ggp_hist <- ggplot(data = gapminder, aes(x = lifeExp)) +
    geom_histogram(aes(y = ..density..), binwidth = 2, colour = "black", fill = "lightblue") + # change binwidth or substitute out for bins =
    geom_density(aes(colour = continent, fill = continent), alpha = 0.1) +
    labs(title = "Life Expectancy", x = "Life Expectancy", y = "Density") +
    theme_light() +
    NULL
## instead of having different density plots overlaying the same graph, try facet_wrap().
ggp_hist

# ggp_hist2 <- ggplot() +
#     geom_histogram() +
#     geom_density() +
#     NULL

#ggp_hist2
## make another histogram with different variables

# ggp_hist3 <- ggplot() +
#     geom_histogram() +
#     NULL

#ggp_hist3


## Box plots using geom_boxplot()
#Boxplots are useful for visualising summary statistics and identifying outliers in the data.

## plot a boxplot
ggp_box <- ggplot(data = gapminder, aes(x = fct_reorder(continent, lifeExp), y = lifeExp, fill = continent)) + # useful reordering function suppled to the x aesthetic. Remove it and see the effects.
    geom_boxplot(outlier.color = NA) + #removed outliers in this plot because we are layering on geom_point() of the data, try commenting out the geom_point() and removing the outlier.color = NA command to see how outliers are presented by default.
    geom_jitter(alpha = 0.2) + #geom_jitter is a variation on geom_point(). Swap out for geom_point() to see the effects.
    scale_y_continuous(breaks = round(seq(min(gapminder$lifeExp), max(gapminder$lifeExp), by = 10),0)) + # seq() is for sequence, change the by = 10 to a different value to see the effects.
    coord_flip() + # comment coord_flip() out to see the effects.
    labs(title = "Boxplot of life expectancy by continent", y = "Life Expectancy", x= "Continent") +
    theme_light() +
    theme(legend.position = "none") + # removed the legend as not visually necessary in this plot.
    NULL

ggp_box

## wrangle gapminder data to find top 5 countries in the year 2007 with the highest life expectancy and create a new boxplot.
top5 <- gapminder %>%
    filter() %>% #filter for year
    arrange() %>% #arrange by life expectancy
    head(5)

## Additional features and visualisations
#Add in additional columns to calculate life expectancy/ population and GDP per capita changes year on year using lag().
## wrangle some features
## calculate rate change from previous year per country
df_rate_change <- gapminder %>%
    janitor::clean_names() %>% # good package and function to make column names more coding friendly.
    group_by(country) %>%
    arrange(year) %>%
    mutate(pc_lifeexp_change = round(((life_exp/ lag(life_exp)) -1) * 100, 1)) %>% # here, rounding is done to 1 decimal place.
    mutate(pc_pop_change = round(((pop / lag(pop)) -1) * 100, 1)) %>%
    mutate(pc_gdp_cap_change = round(((gdp_percap / lag(gdp_percap)) -1) * 100, 1)) %>% #changes here are * 100 to make %
    arrange(country)

## add in any other additional features you would like to visualise with mutate()
head(df_rate_change)

#Here we will wrangle the dataframe we have just created (df_rate_change) to find the percent change in population for the country with the highest life expectancy and the country with the lowest life expectancy per continent using 2007 as an example year to filter on.
## plot a line graph showing the changes in life expectancy per year for 5 countries
## find the 5 countries with the lowest population in 2007 per continent
low_pop_2007 <- df_rate_change %>%
    filter(year == 2007) %>%
    group_by(continent) %>%
    arrange(life_exp) %>%
    slice(1) %>% # slice() takes the first row per group - here it is important that the previous steps are correct. head() will only take the 1st row of the dataframe.
    ungroup() %>%
    pull(country) #pull() will return a list of the countries, use class(low_pop_2007) to see the structure of the outcome.

high_pop_2007 <- df_rate_change %>%
    filter(year == 2007) %>%
    group_by(continent) %>%
    arrange(desc(life_exp)) %>% # nesting desc() within arrange() will arrange in descending order.
    slice(1) %>%
    ungroup() %>%
    pull(country)

countries_to_plot <- c(as.character(low_pop_2007), as.character(high_pop_2007)) # have to change to character type from factors. See what happens if you remove the as.character() calls.
countries_to_plot

ggp_pc_rate <- ggplot(data = df_rate_change %>%
                          filter(country %in% countries_to_plot), aes(x = year, colour = country)) +
    geom_point(aes(y = pc_gdp_cap_change)) +
    geom_line(aes(y = pc_gdp_cap_change), linetype = "dashed") + # difficult to add in the legend of linetypes when layering graphs like this.
    geom_point(aes(y = pc_pop_change)) +
    geom_line(aes(y = pc_pop_change)) +
    facet_grid(rows = vars(continent)) +
    scale_x_continuous(breaks = seq(min(df_rate_change$year), max(df_rate_change$year), by = 5)) +
    scale_y_continuous(breaks = seq(-50, 50, by = 25)) +
    coord_cartesian(xlim = c(1957, 2007), y = c(-50,50)) +
    labs(title = "Change in GDP per capita and population time", x = "Year", y = "Percent change (%)") +
    theme_light() +
    NULL

ggp_pc_rate

## ggplot loves long data. Let's wrangle the data to be in long format.
df_rate_change_pivot <- df_rate_change %>%
    filter(country %in% countries_to_plot) %>%
    select(country,
           continent,
           year,
           pc_pop_change,
           pc_gdp_cap_change) %>%
    pivot_longer(c(pc_pop_change, pc_gdp_cap_change),
                 names_to = "pc_change_type",
                 values_to = "pc_change")

## now make the graph
ggp_pc_rate_pivot <- ggplot(data = df_rate_change_pivot, aes(x = year, y = pc_change, colour = country)) +
    geom_point() +
    geom_line(aes(linetype = pc_change_type)) +
    facet_grid(rows = vars(continent)) +
    scale_x_continuous(breaks = seq(min(df_rate_change$year), max(df_rate_change$year), by = 5)) +
    scale_y_continuous(breaks = seq(-50, 50, by = 25)) +
    coord_cartesian(xlim = c(1957, 2007), y = c(-50,50)) +
    labs(title = "Change in GDP per capita and population time", x = "Year", y = "Percent change (%)", colour = "Country", linetype = "% Change Variable") +
    theme_light() +
    NULL

ggp_pc_rate_pivot


## Interactive graphs using {plotly}
#A ggplot object can be passed in to ggplotly().
ggp_for_plotly <- ggplot(data = df_rate_change %>%
                             filter(country %in% countries_to_plot), aes(x = year, y = life_exp, colour = country)) +
    geom_point(aes(text = paste0("Country: ",country,
                                 "<br>Year: ",year,
                                 "<br>Life Expectancy: ",life_exp,
                                 "<br>Life Expectancy (% change): ", pc_lifeexp_change))) +
    geom_line() +
    scale_x_continuous(breaks = seq(min(df_rate_change$year), max(df_rate_change$year), by = 5)) +
    labs(title = "Change in life expectancy over time", x = "Year", y = "Life expectancy (years)", colour = "Country") +
    theme_light() +
    NULL


interactive_graph <- plotly::ggplotly(ggp_for_plotly, tooltip = "text")
interactive_graph

