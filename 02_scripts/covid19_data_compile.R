# Authors : Ashten Anthony 
# Email   : ashten28@gmail.com

# r packages used
rpkgs <- 
  c(
    "dplyr","readr", "tidyr", "RCurl", "lubridate"
    )

# install r packages that have not been installed
rpkgs_to_install <- 
  rpkgs[!(rpkgs %in% installed.packages()[,"Package"])]

if(length(rpkgs_to_install)) { install.packages(rpkgs_to_install) }

# load r packages
for (pkg in rpkgs){
  suppressMessages(library(pkg, character.only = T))
  
}

# last available data file in repo
end_date <- today(tz = "UTC") -1

# create a vector of dates
date_vector <-
  seq.Date(as.Date("01-22-2020", format = "%m-%d-%Y"), end_date, by = 1) %>% 
  format("%m-%d-%Y") %>% 
  as.character()

data <- 
  date_vector %>% 
  lapply(
    function(x){
      read.csv(text = RCurl::getURL(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/", x, ".csv"))) %>%
      # read_csv(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/", x, ".csv")) %>% 
        mutate(Report_Date = as.Date(x, format = "%m-%d-%Y")) %>% 
        suppressMessages()
        }
    
  ) 

# format 1
daily_cases_format_1 <-
  data[1:39] %>% 
  lapply(function(x) setNames(x, c("province_state", "country_region", "last_update", "cum_confirmed", "cum_deaths", "cum_recovered", "report_date"))) %>% 
  bind_rows()

# format 2
daily_cases_format_2 <-
  data[40:60] %>% 
  lapply(function(x) setNames(x, c("province_state", "country_region", "last_update", "cum_confirmed", "cum_deaths", "cum_recovered", "lat", "long", "report_date"))) %>% 
  bind_rows()

# format 3
daily_cases_format_3 <-
  data[61:length(data)] %>% 
  lapply(function(x) setNames(x, c("fips", "admin2", "province_state", "country_region", "last_update", "lat", "long", "cum_confirmed", "cum_deaths", "cum_recovered", "active", "combined_key", "report_date"))) %>% 
  bind_rows()

# stack all formats
daily_cases_all <-
  bind_rows(daily_cases_format_1, daily_cases_format_2, daily_cases_format_3) 

# clean data
daily_cases_all_clean <-
  daily_cases_all %>% 
  replace_na(list(cum_confirmed = 0, cum_deaths = 0, cum_recovered = 0)) %>% 
  mutate_at(.vars = c("province_state", "country_region"), .funs = trimws) %>% 
  mutate(
    country_region = case_when(
      country_region == "Bahamas, The"       ~ "Bahamas", 
      country_region == "The Bahamas"        ~ "Bahamas", 
      country_region == "The Gambia"         ~ "Gambia", 
      country_region == "Gambia, The"        ~ "Gambia", 
      country_region == "Hong Kong SAR, The" ~ "Hong Kong", 
      country_region == "Iran (Islamic Republic of)" ~ "Iran", 
      country_region == "Korea, South" ~ "South Korea", 
      country_region == "Republic of Korea" ~ "South Korea", 
      country_region == "occupied Palestinian territory" ~ "Palestine", 
      country_region == "North Ireland" ~ "Ireland", 
      country_region == "Macao SAR" ~ "Macau", 
      country_region == "Mainland China" ~ "China", 
      country_region == "Russian Federation" ~ "Russia", 
      country_region == "Taiwan*" ~ "Taiwan", 
      country_region == "Taipei and environs" ~ "Taiwan", 
      country_region == "UK" ~ "United Kingdom", 
      country_region == "Viet Nam" ~ "Vietnam", 
      TRUE ~ country_region
      
    )
  ) %>% 
  mutate(
    country_region = case_when(
      country_region == "China" & province_state == "Hong Kong"~ "Hong Kong", 
      TRUE ~ country_region
      
    )
  ) %>% 
  filter(
    ! country_region %in% c("Republic of Ireland") # appears duplicated
  )
  
# add incremental columns
daily_cases_all_clean2 <-
  daily_cases_all_clean %>% 
  arrange(province_state,  cum_confirmed, cum_deaths, cum_recovered, report_date) %>% 
  group_by(province_state, country_region) %>% 
  mutate(
    inc_confirmed = cum_confirmed - lag(cum_confirmed, default = 0),
    inc_deaths = cum_deaths - lag(cum_deaths, default = 0),
    inc_recovered = cum_recovered - lag(cum_recovered, default = 0)
    
  ) %>% 
  select(
    report_date, country_region, province_state, 
    cum_confirmed, cum_deaths, cum_recovered, 
    inc_confirmed, inc_deaths, inc_recovered
  )
  

# dir create for new date
dir.create(paste0("01_data/daily_cases/", format(end_date, "%Y-%m-%d")), recursive = T)

# write csv
write.csv(
  x = daily_cases_all_clean2,
  file = paste0("01_data/daily_cases/", format(end_date, "%Y-%m-%d"), "/covid19_daily_cases_cleaned.csv"),
  row.names = FALSE
)





