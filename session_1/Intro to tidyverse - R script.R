# Introduction to tidyverse ####

# Welcome to PPP's first workshop on tidyverse 
# 24 November 2022
# 9.30am to 12.30/1.00pm

# Timetable:
# 9:30 - 10.00am: Recap of base R with Eirini Koutoumanou
# 10.00 - 10.45am: Data management in tidyverse - part I 
# 	with Tim Cole and Mario Cortina Borja
# 10.45 - 11.00am (ish): Coffee break
# 11.00 - 12.00pm: Data management in tidyverse - part II 
# 	with Tim Cole and Mario Cortina Borja
# 12.00 - 1.00pm: Data  wrangling and visualisations using 
# 	ggplot and plotly with Lydia Briggs

# Before we start, please ensure you have installed the 
# 	following packages...

install.packages('gapminder')
install.packages('tidyverse')
install.packages('plotly')
install.packages('ggforce')
library(gapminder)
library(tidyverse)
library(plotly)
library(ggforce)

# Session 1.1: recap of base-R, introduction to R ####

# R and RStudio are free
# RStudio is a user-friendly editor of R
# a fast and very efficient programming language 
# capable of performing a long list of statistical tasks 
# (and more!)

# Anything that starts with the # symbol is a comment.
# If a comment ends with #### or ==== or ----, it is 
# bookmarked and can be located from a drop-down list of 
# bookmarks at the bottom of the script window.

# Vocabulary of R contains objects and functions.
# Objects = variables/datasets/tables, etc.
# Functions = verbs, actions, tasks to complete.

# Symbols:
# All types of brackets are used: () [] {}  
# () : Used for functions and other calculations
# [] : Used for filtering objects such as data frames
# {} : Loops, for, if, own function/package
# ? : Used to access help pages, example ?read.csv
# # (hash) : Used for comments 
# Define a new object with: = or <- , e.g. 
variable.1 <- c(45,23,6,4,-0.95)
# Delete an object:
rm(variable.1)

# Basic rules:
# R is case sensitive
# R can act as a calculator, i.e. recognises all known 
# mathematical actions it is text based, i.e. requires
# programming/written code. 

# Create a dataframe from scratch:
data.frame(a=2:3,
           b=(2:3)*4,
           c=letters[2:3],
           d=LETTERS[(2:3)*4])
# or 
a=2:3
data.frame(a,b=a*4,c=letters[a],d=LETTERS[a])

# Session 1.2: Recap of base-R, introduction to the gapminder dataset #### 
# gapminder is a dataframe (dataset) that is stored in the 
# gapminder package we already installed and loaded. 

gapminder
class(gapminder)
head(gapminder)
tail(gapminder)
dim(gapminder)
names(gapminder)
# "country"   "continent" "year"      "lifeExp"   "pop"       "gdpPercap"
summary(gapminder)
View(gapminder)

# Filtering columns, e.g. all data for the Country 
# variable:
gapminder$country 
# or, all data from the 1st column
gapminder[,1]
# or 
gapminder['country']
gapminder[,'country']

# Filtering rows
gapminder[57,] # all data from 57th row

# Filtering by specific conditions
gapminder[gapminder$country=='Argentina',]
summary(gapminder[gapminder$country=='Argentina' & 
                    gapminder$lifeExp>=40,])

# Enter new ID variable
gapminder$ID <- 1:dim(gapminder)[1]
dim(gapminder)


# Factor variables ====
gapminder$country
class(gapminder$country)
summary(gapminder$country)
# Or 
table(gapminder$country)
cbind(table(gapminder$country))
cbind(round(prop.table(table(gapminder$country))*100,2))
addmargins(table(gapminder$country))

gapminder$continent
class(gapminder$continent)
summary(gapminder$continent)
# Or 
table(gapminder$continent)
round(prop.table(table(gapminder$continent))*100,2)
addmargins(table(gapminder$continent))

# Numerical variables ====
gapminder$year
summary(gapminder$year)
mean(gapminder$year); median(gapminder$year);
sd(gapminder$year); range(gapminder$year);
IQR(gapminder$year); quantile(gapminder$year, 0.25)
table(gapminder$year)

gapminder$lifeExp
summary(gapminder$lifeExp)
hist(gapminder$lifeExp)

# Numerical variables split by categorical variables
cbind(tapply(gapminder$lifeExp,gapminder$country,mean))
round(cbind(sort(tapply(gapminder$lifeExp,gapminder$country,mean))),1)
tapply(gapminder$lifeExp,gapminder$country,summary)

lapply(gapminder,mean)
round(sapply(gapminder,mean),1)
round(sapply(gapminder,median),1)
