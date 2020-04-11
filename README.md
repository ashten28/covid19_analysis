# Covid 19 Analysis

## Data
Source:  https://github.com/CSSEGISandData/COVID-19

Credit to Johns Hopkins CSSE for compiling and reporting COVID-19 data on a daily basis. 

Each data file in here reports the figures as a cumulative amount. Hence, to obtain incremental figures, all the historical files must be compiled. 

However, data files have inconsistent format from day to day. Codes in here aim to clean and compile the daily data into a tidy data. Please find the tidy data (here)[01_data/covid19_daily_cases_cleaned.csv]. 

In R, use the below code to read the clean tidy data:

```
covid19_data <- 
  read.csv(text = RCurl::getURL("https://raw.githubusercontent.com/ashten28/covid19_analysis/master/01_data/covid19_daily_cases_cleaned.csv"))
  
```

The data consist of these main columns:

1. report_date
2. country_region - Country
3. province_state - Province (earlier dates may not have breakdown)
4. cum_confirmed  - Cumulative confirmed cases
5. cum_deaths     - Cumulative deaths cases
6. cum_recovered  - Cumulative recovered cases
7. inc_confirmed  - Incremental confirmed cases (calculated field)
8. inc_deaths     - Incremental death cases     (calculated field)
9. inc_recovered  - Incremental recovered cases (calculated field)
10. lat          - Lattitude
11. long         - Longitude

