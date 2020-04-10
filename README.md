# Covid 19 Analysis

## Data
Source:https://github.com/CSSEGISandData/COVID-19

Credit to Johns Hopkins CSSE for compiling and reporting COVID-19 data on a daily basis. 

Each data file in here reports the figures as a cumulative amount. Hence, to obtain incremental figures, all the historical files must be compiled. 

However, data files have inconsistent format from day to day. Codes in here aim to clean and compile the daily data into a tidy data. Please find the tidy data (here)[]. 

In R, use the below code to read the clean tidy data:

`base::read.csv(RCurl::ULR()`

The data consist of these main columns:

1. country_region
2. province_state
4. lat
5. long
6. cum_confirmed
7. cum_deaths
8. cum_recovered
9. inc_confirmed
10. inc_deaths
11. inc_recovered
12. last_update
13. report_date
14. combined_key
15. fips
16. admin2
17. active

