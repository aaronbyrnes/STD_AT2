##library("lubridate")
rm(list=ls()) #for clearing the environment
alcohol_freq_hosp_death <- read_csv("alcohol_freq_hosp_death.csv")


str(alcohol_freq_hosp_death)

# More modification - make year into date format for charting
alcohol_freq_hosp_death <- alcohol_freq_hosp_death %>%
  mutate(year_new = substr(alcohol_freq_hosp_death$year,6,9), year_num = as.numeric(year_new), date_full=paste("30/06/",year_new) ,lockout = ifelse(year_num<2014,"Pre","Post"), date = as.Date(date_full,"%d/%m/%Y")) 


## alcohol_health_gender <- filter(alcohol_freq_hosp_death, Sex !="Persons") ## This if need gender based data


## Filter to the two local health districts close to Sydney CBD

sydney_LHDs <- alcohol_freq_hosp_death %>%
  filter(Sex =="Persons" & year_num > 2008)%>%
  filter(LHD == "Sydney LHD" | LHD == "South Eastern Sydney LHD")## | LHD == "Western Sydney LHD" | LHD =="Northern Sydney LHD")

## EDA Plot 1- Drinking Frequency in central sydney local health districts

ggplot(sydney_LHDs, aes(date)) + 
  geom_line(aes(y = freq_daily, colour = "daily")) + 
  geom_point(aes(y = freq_daily, colour = "daily", shape = lockout),size = 3)+
  geom_line(aes(y = freq_weekly, colour = "weekly")) +
  geom_point(aes(y = freq_weekly, colour = "weekly", shape = lockout),size = 3)+
  geom_line(aes(y= freq_less_weekly, colour = "less than weekly")) +
  geom_point(aes(y = freq_less_weekly, colour = "less than weekly", shape = lockout),size = 3)+
  geom_line(aes(y= freq_never, colour = "never"))+
  geom_point(aes(y = freq_never, colour = "never", shape = lockout),size = 3)+
  geom_vline(xintercept = as.numeric(as.Date("2014-02-01")), linetype="dotted", 
                  color = "black", size=1.5)+
  facet_wrap(~LHD)+
  labs(title = "Alcohol Drinking Frequency in Adults", subtitle = "Pre and Post Lockout Laws", y="Percent of Adults", colour = "Drinking Frequency")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  

## EDA Plot 2 - Health Related incidents in central sydney local health districts

ggplot(sydney_LHDs, aes(x = date, y = hospitalisation_rate, fill = lockout)) + 
  geom_col() +
  facet_wrap(~LHD)+
  labs(title = "Alcohol Related Hospitalisations", subtitle = "Pre and Post Lockout Laws", y="Hospitalisation rate per 100,000 population")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))


ggplot(sydney_LHDs, aes(x = date, y = death_rate, fill = lockout)) + 
  geom_col() +
  facet_wrap(~LHD)+
  labs(title = "Alcohol Related Deaths", subtitle = "Pre and Post Lockout Laws", y="Death rate per 100,000 population")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))

