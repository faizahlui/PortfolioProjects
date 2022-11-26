####################################### ###
# Step 1: install packages and library ###
####################################### ###

install.packages("tidyverse") # for data import and wrangling
install.packages("lubridate") #helps to wrangle date attributes
install.packages("ggplot2") # for data visualization // Note : ggplot no longer can be used in this version
#therefore latest version is ggplot2 
install.packages("maps") # for drawing basic geographical maps

#loading library
library(tidyverse)
library(lubridate)
library(ggplot2)
library(maps)

options(scipen = 999)   # Modify global options in R to not use scientific notation such as 1e+100



####################################### ###
# Step 2: Import data                   ###
####################################### ###


#check directory paths, make sure that the file 
#path is correct using getwd() / setwd()
#in this case my working directory is already correct 
# & will proceed to import the datas
#getwd() --> get working directory 
#setwd()--> set working directory 
getwd()
setwd("/Users/faten/OneDrive/Documents/COURSERA/Google Data Analysis Certificate/Case Study/CASE STUDY 1/DATA")


#import data in csv files
data <- read.csv("New_df4.csv")


##########################################################
# Step 2: Exploratory Data Analysis                  ####
##########################################################

# Let's do some exploratory data analysis. 

# Business goal: 

head(data)
ncol(data)
nrow(data)
str(data)
glimpse(data)


unique(data$ride_id)
unique(data$rideable_type)
unique(data$member_casual)
unique(data$duration_min)
unique(data$year)

summary(data$ride_length)
summary(data$duration_min)

#descriptive analysis for numerical data type
summary(data$ride_length) # show Min, 1st Qu,Median,Mean,3rd Qu,Max, for numerical dataset, 
summary(data$duration) # duration for days 
summary(data$duration_min)






#create histogram for ride_length 
# bin default set to 30 
ggplot(data = data) + 
  geom_histogram(mapping=aes(x=ride_length), fill="#69b3a2", color="purple") 


# create boxplot for ride_length,  checking outliers

ggplot(data=data) +
  geom_boxplot(mapping= aes(y=ride_length)) # or use "boxplot(data$ride_length)" for numerical data only 



# explore the data by bike category 

#box plot for different category of the rideable type. 
ggplot(data=data) +
  geom_boxplot(mapping= aes(x=rideable_type, y=ride_length)) # or use "boxplot(data$ride_length)" for numerical data only 
   

#seems like there is too much outlier for this ride_length data. However, we also cannot conclude this 
#noise that distort the visualization. There may be customers who did rent the bike for 37 days. 
# I dont want to remove the outliers. So let's zoom in by setting the limit for the y axis 
ggplot(data=data) +
  geom_boxplot(mapping= aes(x=rideable_type, y=ride_length)) +
  ylim(0,3000)



# bar chart for membership count 
ggplot(data=data) +
  geom_bar(mapping= aes( x=member_casual)) 

#bar chart for membership vs ride duration
ggplot(data=data) +
  geom_col(mapping = aes(x=member_casual, y=ride_length ))
                                                                   
                                                                   
                                                                   
ggplot(data=data) + 
    geom_col(mapping= aes(x=member_casual, y=ride_length)) +
  facet_wrap(~rideable_type) + 
  labs(title = "Ride Length based on bike type",
       caption = "example",
       x = "" ,
       y = "Ride Length" )


ggplot(data=data)+
  geom_boxplot(mapping= aes(y=duration))



data %>%
  group_by(rideable_type, member_casual) %>%  
  summarise(number_of_rides = n()							
            ,average_duration = mean(ride_length)) %>% 	
  arrange(rideable_type,member_casual)	%>%
  ggplot(aes(x = rideable_type, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  theme(axis.text.x = element_text( color="#993333", angle=12))

data %>%
  group_by(rideable_type, member_casual) %>%  
  summarise(total_length = sum(ride_length)					
            ,average_duration = mean(ride_length)) %>% 	
  arrange(member_casual)	%>%
  ggplot(aes(x = rideable_type, y = total_length, fill = member_casual)) +
  geom_col(position = "dodge") +
  theme(axis.text.x = element_text( color="#993333", angle=12))


# boxplot for the number of rides for bike category

data %>%
  group_by(rideable_type)%>% 
  summarise(total_rides = n()) %>%
  ggplot(aes (x=rideable_type, y=total_rides))+
  geom_boxplot()+
  theme(axis.text.x = element_text( color="#993333", angle=12))

# daily trend - total rides 
data %>% 
  group_by(day_of_week, member_casual) %>%
  summarise(total_rides=n())%>%
  arrange(day_of_week)%>%
  ggplot(aes(x=day_of_week, y= total_rides, fill= member_casual))+ 
  geom_col(position = "dodge")

#daily trend - ride length 

data %>% 
  group_by(day_of_week, member_casual) %>%
  summarise(total_length = sum(ride_length))%>%
  arrange(day_of_week)%>%
  ggplot(aes(x=day_of_week, y= total_length, fill= member_casual))+ 
  geom_col(position = "dodge") + 
  theme(axis.text.x = element_text( angle=12))


# ride length by month

data %>% 
  mutate(Month= month(month,label=TRUE))%>%
  group_by(Month , member_casual) %>%
  summarise(total_length = sum(ride_length)) %>%
  ggplot(aes(x=Month, y = total_length, group= member_casual, colour =member_casual))+ 
  geom_line() + 
  geom_point()


# let's explore the data location longitude & latitude
# start location 
ggplot(data = data, aes(x = start_lng, y = start_lat)) + 
  geom_point() 

#end location
ggplot(data = data, aes(x = end_lng, y = end_lat)) + 
  geom_point()


# let's merge both the start & end location point. 
ggplot(data=data) +
  geom_point(mapping= aes(x = start_lng, y = start_lat)) + 
  geom_point(mapping= aes(x = end_lng, y = end_lat))

  
  
  
# let's see the starting point popularity
data%>% 
  group_by(start_lng, start_lat) %>%
  summarise(total_station=n()) %>%
  arrange(-total_station)

# end_point popularity 
data%>% 
  group_by(end_lng, end_lat) %>%
  summarise(total_station=n()) %>%
  arrange(-total_station)

#let's plot some basic map of this dataset:- 
#Note : my computer just shuts down on it's own when I compute below code & it took really long to compute 
#I will use Power BI as an alternative to visualize the data location. 
ggplot(data=data) +
  geom_polygon( aes(x = start_lng, y =start_lat)) +
  theme_bw()


# plot graph trend based on the time combo chart, average & also total ride 
data %>% 
  group_by(start_hour, member_casual) %>%
  summarise(total_ride = n()) %>%
  ggplot(aes(x=start_hour, y= total_ride, group=member_casual, colour=member_casual))+ 
  geom_line()+
  geom_point()

 ###################################################################
# additional codes used:-
# categorical proportion of numerical data for the each member type and also the percentage. 
data %>% 
  group_by(member_casual, rideable_type) %>%
  summarise(total= n(), percentage = total / nrow(data) * 100)

# let's plot some graph 
data %>% 
  group_by(member_casual, rideable_type) %>%
  summarise(total= n(), percentage = total / nrow(data) * 100) %>%
  ggplot(aes(x=rideable_type, y=total, group = member_casual, fill= member_casual ))+ 
  geom_col()

#
data%>%
  group_by(rideable_type)%>%
  summarise(mean=aggregate)

