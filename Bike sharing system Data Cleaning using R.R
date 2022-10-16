## Load packages

#Load/ install  all relevant packages 
install.packages("tidyverse") # for data import and wrangling
install.packages("lubridate") #helps to wrangle date attributes
install.packages("ggplot2") # for data visualization 
install.packages("maps") # for drawing basic geographical maps


#loading library
library(tidyverse)
library(lubridate)
library(ggplot2)
library(maps)

options(scipen = 999)   # Modify global options in R to not use scientific notation such as 1e+100


##Import data

#check directory paths, make sure that the file path is correct using getwd() / setwd()
#in this case my working directory is already correct & will proceed to import the datas
#getwd() --> get working directory 
#setwd()--> set working directory 
getwd()
setwd("/Users/faten/OneDrive/Documents/COURSERA/Google Data Analysis Certificate/Case Study/CASE STUDY 1/DATA/ORIGINAL DATA")

#import data in csv files

df1 <- read.csv("202105-cyclistic-tripdata.csv")
df2 <- read.csv("202106-cyclistic-tripdata.csv")
df3 <- read.csv("202107-cyclistic-tripdata.csv")
df4 <- read.csv("202108-cyclistic-tripdata.csv")
df5 <- read.csv("202109-cyclistic-tripdata.csv")
df6 <- read.csv("202110-cyclistic-tripdata.csv")
df7 <- read.csv("202111-cyclistic-tripdata.csv")
df8 <- read.csv("202112-cyclistic-tripdata.csv")
df9 <- read.csv("202201-cyclistic-tripdata.csv")
df10 <- read.csv("202202-cyclistic-tripdata.csv")
df11 <- read.csv("202203-cyclistic-tripdata.csv")
df12 <- read.csv("202204-cyclistic-tripdata.csv")


## Inspect, clean & add data 

#reviewing the data files, & check if the columns are consistent before compliling Here I am using a few options and show some ways the data can be reviewed

#using head() returns the columns and first 5  rows of data including the header
head(df1)
head(df2)
head(df3)
head(df4)
head(df5)
head(df6)
head(df7)
head(df8)
head(df9)
head(df10)
head(df11)
head(df12)

#using the `str()` function, displaying the internal structure of the data frame
str(df1)
str(df2)
str(df3)
str(df4)
str(df5)
str(df6)
str(df7)
str(df8)
str(df9)
str(df10)
str(df11)
str(df12)

#using colnames () to find out the columns in the dataframe. Findings shown that the columns are not consistent. 
colnames(df1)
colnames(df2)
colnames(df3)
colnames(df4)
colnames(df5)
colnames(df6)
colnames(df7)
colnames(df8)
colnames(df9)
colnames(df10)
colnames(df11)
colnames(df12)

#checking total columns each data frames has using ncol(df), 
#based on the data shown that the total column is not consistent but the name is consistent
# 15 cols : df2, df3, df10, 
ncol(df1)
ncol(df2)
ncol(df3)
ncol(df4)
ncol(df5)
ncol(df6)
ncol(df7)
ncol(df8)
ncol(df9)
ncol(df10)
ncol(df11)
ncol(df12)

#remove columns name 
#editing existing dataframe, by eliminating the relevant columns using select(funtion)
# Dplyr remove multiple columns by name:
#select(starwars, -c(name, height, mass))
df2_new <- select(df2, -c(ride_length,day_of_week))
df3_new <- select(df3, -c(ride_length,day_of_week))
df10_new <- select(df10, -c(ride_length,day_of_week.))

# since all columns now have the same name, can proceed to merge using rbind function

new_df <- rbind(df1,df2_new,df3_new,df4,df5,df6,df7,df8,df9,df10_new,df11,df12)


##CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS

#Extract Unique Values in R (3 Examples)using distinct() or duplicated() or  unique()

#using unique() to check if the values in certain columns are all entered correctly, 
#to also ensure that there is no typos in the columns
unique(new_df$rideable_type) # check values in rideable_type 
unique(new_df$member_casual) #check user type list in member_casual

#Result from above codes shown that all data are clean, no typos and blank / NA columns 

#Now we proceed to remove duplicates using distinct 
new_df %>% distinct()

#Notice that the data for started_at and ended_at contains both time  and date which are too granular 
#Let's segregate it into additional data such as day, date, month and year , that will give us more opportunity
#to analyze the data from different perspective
# We will use as.Date() function

#create new table called "date"
new_df$start_date <- as.Date(new_df$started_at) #The default format is yyyy-mm-dd

#change column/variable  name

#create new table called "end_date"
new_df$ended_date <- as.Date(new_df$ended_at) #The default format is yyyy-mm-dd
new_df$duration <- new_df$ended_date-new_df$start_date # determine days of the duration 
new_df$month <- format(as.Date(new_df$start_date), "%m") #numerical month  (00-12)
new_df$day <- format(as.Date(new_df$start_date), "%d") # day as Number (1-31)
new_df$year <- format(as.Date(new_df$start_date), "%Y") #4 digit year
new_df$day_of_week <- format(as.Date(new_df$start_date), "%A") #unabbreviated weekday (Monday)
new_df$start_hour <- format(as.POSIXct(new_df$started_at), format = "%H") #retrieve start time hour 
new_df$end_hour <- format(as.POSIXct(new_df$ended_at), format = "%H") #retrieve start time hour 

#R read columns started_at & ended_at as character class. Below we will convert the class from char to date 
#df1 <- df %>% 
#mutate(x = dmy_hms(x))
new_df <- new_df %>% mutate(started_at = ymd_hms(started_at)) 
new_df <- new_df %>% mutate(ended_at = ymd_hms(ended_at)) 
new_df$ride_length <- difftime(new_df$ended_at,new_df$started_at) # Add a "ride_length" calculation to all_trips (in seconds)

#remove bad data based on below criterion:-
# 1. ride_length = -ve 
# 2. started_at = NA 

# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality or ride_length was negative or data are NA
# We will create a new version of the dataframe (v2) sice data is being removed
new_df_clean <- new_df[!(new_df$start_station_name == "HQ QR" | new_df$ride_length<0 | new_df$ride_length =="NA"),]

#df1_complete = na.omit(df1) --- remove NA using omit function in the entire data frame
new_df4 <- na.omit(new_df_clean) 

#remove -ve value in ride_length variables 
#filter(dataf, Mean != 99 & Correct != 99)
new_df4<- filter (new_df, ride_length > 0 )
new_df4$duration_min <- seconds_to_period(new_df4$ride_length)


#Descriptive analysis on duration   (days)
unique(new_df4$duration) # unique value of the duration column
mean(new_df4$duration) #average of the duration
median(new_df4$duration) #midpoint number in the ascending array of duration 
max(new_df4$duration) #longest duration
min(new_df4$duration) #shortest duration


# Descriptive analysis on ride_length (all figures in seconds)
mean(new_df4$ride_length) #straight average (total ride length / rides)
median(new_df4$ride_length) #midpoint number in the ascending array of ride lengths
max(new_df4$ride_length) #longest ride
min(new_df4$ride_length) #shortest ride


# You can condense the four lines above to one line using summary() on the specific attribute
summary(new_df4$duration)
summary(new_df4$ride_length)

# Compare members and casual users
aggregate(new_df4$ride_length ~ new_df4$member_casual, FUN = mean)
aggregate(new_df4$ride_length ~ new_df4$member_casual, FUN = median)
aggregate(new_df4$ride_length ~ new_df4$member_casual, FUN = max)
aggregate(new_df4$ride_length ~ new_df4$member_casual, FUN = min)


# See the average ride time by each day for members vs casual users
aggregate(new_df4$ride_length ~ new_df4$member_casual + new_df4$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
new_df4$day_of_week <- ordered(new_df4$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(new_df4$ride_length ~ new_df4$member_casual + new_df4$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
new_df4%>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)	


# Let's visualize the number of rides by rider type
new_df4 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
new_df4 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

# plot histogram for the duration distribution 
ggplot(data = new_df4)  +
  geom_histogram(mapping=aes(x=duration), fill= "red", bins=10)


##################################################################################################################################################
#-- From this point onwards my computer keeps crashing, and I have saved and created new csv file using the merged file "new_df4" using write.csv. 
#--so below codes has been omited as they are repetitive and stored in a separate file in my computer. 
##################################################################################################################################################


#import data in csv files once again
data <- read.csv("New_df4.csv")


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


#descriptive analysis for numerical data type
summary(data$ride_length) # show Min, 1st Qu,Median,Mean,3rd Qu,Max, for numerical dataset, 
summary(data$duration) # duration for days 
summary(data$duration_min)


#create histogram for ride_length 
#bin default set to 30 
ggplot(data = data) + 
  geom_histogram(mapping=aes(x=ride_length), fill="#69b3a2", color="purple") 


# create boxplot for ride_length,  checking outliers
ggplot(data=data) +
  geom_boxplot(mapping= aes(y=ride_length)) # or use "boxplot(data$ride_length)" for numerical data only 



# explore the data by bike category 

#box plot for different category of the rideable type. 
ggplot(data=data) +
  geom_boxplot(mapping= aes(x=rideable_type, y=ride_length)) # or use "boxplot(data$ride_length)" for numerical data only 
   

#seems like there is too much outlier for this ride_length data. However, we also cannot conclude this as 
#noise that might distort the visualization/ analysis. There may be customers who did rent the bike for 37 days. 
#I dont want to remove the outliers yet. So let's zoom in by setting the limit for the y axis 
ggplot(data=data) +
  geom_boxplot(mapping= aes(x=rideable_type, y=ride_length)) +
  ylim(0,3000)


# bar chart for membership count 
ggplot(data=data) +
  geom_bar(mapping= aes( x=member_casual)) 

#bar chart for membership vs ride length
ggplot(data=data) +
  geom_col(mapping = aes(x=member_casual, y=ride_length ))
                                                                   
# column bar based on the category                                                                                                                              
ggplot(data=data) + 
    geom_col(mapping= aes(x=member_casual, y=ride_length)) +
  facet_wrap(~rideable_type) + 
  labs(title = "Ride Length based on bike type",
       caption = "example",
       x = "" ,
       y = "Ride Length" )
  
#boxplot for duration
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


# Plot line graph for the 
data %>% 
  group_by(start_hour, member_casual) %>%
  summarise(total_ride = n()) %>%
  ggplot(aes(x=start_hour, y= total_ride, group=member_casual, colour=member_casual))+ 
  geom_line()+
  geom_point()




