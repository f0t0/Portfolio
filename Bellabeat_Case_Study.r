#Phase 2: Prepare
#Import Libraries to use for data analysis
library(tidyverse)
library(scales)
library(lubridate)
library(gridExtra)

#Phase 3: Process
#Input Datasets to R
daily_activity <- read_csv("../input/fitabase-data-4121651216/dailyActivity_merged.csv")
daily_sleep <- read_csv("../input/fitabase-data-4121651216/sleepDay_merged.csv")

#Viewing Data
str(daily_activity)
head(daily_activity, 6)

str(daily_sleep)
head(daily_sleep, 6)

#Viewing how many distinct values for accuracy
num_id <- daily_activity %>% #should only be 30 users, but we get 33
  select(Id) %>% 
  n_distinct()

num_days <- daily_activity %>% 
  select(ActivityDate) %>% 
  n_distinct()

print(paste("Number of Distinct Id's", num_id))
print(paste("Number of Distinct Days", num_days))

#Showing the number of Id's and Activity for each individual sorted in ascending order by ActivityDate
aggregate(ActivityDate ~ Id, daily_activity, function(x) length(unique(x))) %>% 
  arrange(ActivityDate)
  
#Checking sleepID's and sleepdays   
num_sleep_id <- daily_sleep %>% 
  select(Id) %>% 
  n_distinct()

num_sleep_days <- daily_sleep %>% 
  select(SleepDay) %>% 
  n_distinct() 

print(paste("Number of Distinct Sleep Id's", num_sleep_id))
print(paste("Number of Distinct Sleep Days", num_sleep_days))

aggregate(SleepDay ~ Id, daily_sleep, function(x) length(unique(x))) %>% 
  arrange(SleepDay)
  
#Merging the datasets, but first have to make sure they are both set at the same format for date
daily_sleepv02 <- daily_sleep %>% 
  mutate(SleepDay = substr(SleepDay, 1, 9))

daily_sleepv03 <- daily_sleepv02 %>% 
  mutate(SleepDay = as.Date(SleepDay, "%m/%d/%Y"))

daily_activityv02 <- daily_activity %>% 
  mutate(ActivityDate = as.Date(ActivityDate, "%m/%d/%Y"))

glimpse(daily_sleepv03)
glimpse(daily_activityv02)

#merged dataset, joined by "Id" and "ActivityDate" = "SleepDay"
daily_activity_sleep <- merge(daily_activityv02, daily_sleepv03, 
                              by.x=c("Id", "ActivityDate"), by.y=c("Id", "SleepDay"))

str(daily_activity_sleep)
head(daily_activity_sleep, 6)

#Phase 4: Analyze          
#Datasets are filtered for the amount of sleep (420min = 7hrs)
less_sleep <- daily_activity_sleep %>% 
  filter(TotalMinutesAsleep < 420)
str(less_sleep)
head(less_sleep, 6)

enough_sleep <- daily_activity_sleep %>% 
  filter(TotalMinutesAsleep >= 420)
str(enough_sleep)
head(enough_sleep, 6)


#Datasets are filtered out for TotalSteps (Reccomended amount of steps per day is 10,000)
less_steps <- daily_activity_sleep %>% 
  filter(TotalSteps < 10000)
str(less_steps)
head(less_steps, 6)

enough_steps <- daily_activity_sleep %>% 
  filter(TotalSteps >= 10000)
str(enough_steps)
head(enough_steps, 6)

#Phase 5: Share
#Visualizing my dataset of less sleep, < 420, to see if there is any correlation with Calories
ggplot(data = less_sleep) +
  geom_point(aes(x = Calories, y = TotalMinutesAsleep, color = "points")) +
  geom_smooth(aes(x = Calories, y = TotalMinutesAsleep, color = "line")) +
  labs(title="Less Sleep vs Calories", 
       subtitle = "People with < 420 minutes of sleep")
       
       
#Seeing how much of a relationship there are between the two
less_sleep %>% 
  summarize(cor(Calories, TotalMinutesAsleep)
  
  
#Visualizing my dataset of enough sleep, >= 420, to see if there is any correlation with Calories
ggplot(data = enough_sleep) +
  geom_point(aes(x = Calories, y = TotalMinutesAsleep, color = "points")) +
  geom_smooth(aes(x = Calories, y = TotalMinutesAsleep, color = "line")) +
  labs(title="Enough Sleep vs Calories", 
       subtitle = "People with >= 420 minutes of sleep")
   
   
#Seeing how much of a relationship there are between the two
enough_sleep %>% 
  summarize(cor(x=Calories, y = TotalMinutesAsleep))
  

#Visualizing Calories vs TotalMinutesAsleep with the filters off
ggplot(data = daily_activity_sleep) +
  geom_point(aes(x = Calories, y = TotalMinutesAsleep, color = "points")) +
  geom_smooth(aes(x = Calories, y = TotalMinutesAsleep, color = "line")) +
  labs(title="TotalMinutesAsleep vs Calories", subtitle = "daily_activity_sleep DF")
  
  
#Seeing how much of a relationship there are between the two  
daily_activity_sleep %>% 
  summarize(cor(x=Calories, y = TotalMinutesAsleep))
  
  
# Now I will visualize my dataset to see if there are any correlation between taking less than 10,000 steps and Calories
ggplot(data = less_steps) +
  geom_point(aes(x = Calories, y = TotalSteps)) +
  geom_smooth(aes(x = Calories, y = TotalSteps)) +
  labs(title="Less Steps vs Calories", 
       subtitle = "People with < 10,000 steps per day")
       
# Calculating the correlation score to see if there are any relationship
less_steps %>% 
  summarize(cor(x=Calories, y = TotalSteps))
  
  
# Now I will visualize my dataset to see if there are any correlation between taking more than 10,000 steps and Calories
ggplot(data = enough_steps) +
  geom_point(aes(x = Calories, y = TotalSteps)) +
  geom_smooth(aes(x = Calories, y = TotalSteps)) +
  labs(title="Enough Steps vs Calories", 
       subtitle = "People with >= 10,000 steps per day")

enough_steps %>% 
  summarize(cor(x=Calories, y = TotalSteps))
  
  
# Now I will visualize my dataset to see if there are any correlation Steps and Calories
ggplot(data = daily_activity_sleep) +
  geom_point(aes(x = Calories, y = TotalSteps)) +
  geom_smooth(aes(x = Calories, y = TotalSteps)) +
  labs(title="Steps vs Calories", 
       subtitle = "daily_activity_sleep DF")  
       
daily_activity_sleep %>% 
  summarize(cor(x=Calories, y = TotalSteps))     
  
  
# Now I want to see the dataset less_steps to see Intensity of the Activity of the minutes affect Calories
ggplot(data = less_steps) +
  geom_point(mapping = aes(x = Calories, y = LightlyActiveMinutes, color = "LightlyActivepoint")) + 
  geom_smooth(mapping = aes(x = Calories, y = LightlyActiveMinutes, color = "LightlyActiveline")) +
  geom_point(mapping = aes(x = Calories, y = FairlyActiveMinutes, color = "FairlyActivepoint")) + 
  geom_smooth(mapping = aes(x = Calories, y = FairlyActiveMinutes, color = "FairlyActiveline")) +
  geom_point(mapping = aes(x = Calories, y = VeryActiveMinutes, color = "VeryActivepoint")) + 
  geom_smooth(mapping = aes(x = Calories, y = VeryActiveMinutes, color = "VeryActiveline")) +
  labs(title="Activity vs Calories", subtitle = "less_steps DF", y = "Minutes")+  
  scale_colour_manual("", 
                      breaks = c("LightlyActivepoint", "LightlyActiveline",
                                 "FairlyActivepoint", "FairlyActiveline",
                                 "VeryActivepoint", "VeryActiveline"),
                      values = c("green", "green", "yellow", "yellow", "red", "red"))  
                      
                      
# Now I want to see the dataset enough_steps to see Intensity of the Activity of the minutes affect Calories
ggplot(data = enough_steps) +
  geom_point(mapping = aes(x = Calories, y = LightlyActiveMinutes, color = "LightlyActivepoint")) + 
  geom_smooth(mapping = aes(x = Calories, y = LightlyActiveMinutes, color = "LightlyActiveline")) +
  geom_point(mapping = aes(x = Calories, y = FairlyActiveMinutes, color = "FairlyActivepoint")) + 
  geom_smooth(mapping = aes(x = Calories, y = FairlyActiveMinutes, color = "FairlyActiveline")) +
  geom_point(mapping = aes(x = Calories, y = VeryActiveMinutes, color = "VeryActivepoint")) + 
  geom_smooth(mapping = aes(x = Calories, y = VeryActiveMinutes, color = "VeryActiveline")) +
  labs(title="Activity vs Calories", subtitle = "enough_steps DF", y = "Minutes")+
  scale_colour_manual("", 
                      breaks = c("LightlyActivepoint", "LightlyActiveline",
                                 "FairlyActivepoint", "FairlyActiveline",
                                 "VeryActivepoint", "VeryActiveline"),
                      values = c("green", "green", "yellow", "yellow", "red", "red"))    

#Phase 6:Act
#Analysis1 Calories vs TotalMinutesAsleep                      
ggplot(data = daily_activity_sleep) +
  geom_point(aes(x = Calories, y = TotalMinutesAsleep, color = "points")) +
  geom_smooth(aes(x = Calories, y = TotalMinutesAsleep, color = "line")) +
  labs(title="TotalMinutesAsleep vs Calories", subtitle = "daily_activity_sleep DF")   

#Analysis2 Calories vs TotalSteps
ggplot(data = daily_activity_sleep) +
  geom_point(aes(x = Calories, y = TotalSteps)) +
  geom_smooth(aes(x = Calories, y = TotalSteps)) +
  labs(title="Steps vs Calories", 
       subtitle = "daily_activity_sleep DF")
