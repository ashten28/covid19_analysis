library(tidyverse)

k <- 1:70

data <-
  tibble(
    k = k,
    lamda10 = dpois(k, lambda = 10),
    lamda20 = dpois(k, lambda = 20),
    lamda30 = dpois(k, lambda = 30),
    lamda40 = dpois(k, lambda = 40)
  )

data %>% 
  pivot_longer(cols = c("lamda10", "lamda20", "lamda30", "lamda40"), names_to = "lamda", values_to = "p") %>% 
  ggplot(aes(x = k, y = p, colour = lamda)) +
  geom_point() +
  geom_line() +
  theme_bw()
    

k <- 20

lamdas <- seq(from = 1 , to = 45, length.out = 90)

map_dbl(lamdas, dpois, x = 20)

data.frame(
  n = lamdas,
  p = map_dbl(lamdas, dpois, x = 20)
) %>% 
  ggplot(aes(x = n, y = p)) +
  geom_point() +
  geom_line() +
  theme_bw()

k <- c(20, 40, 55, 90)
gamma <- 1/7 

# We create an array for every possible value of Rt
R_T_MAX <- 12
r_t_range = seq(0, R_T_MAX, length.out = R_T_MAX*100+1)

lpp <- k[-1]*exp(gamma*(r_t_range - 1))


# Gamma is 1/serial interval
# https://wwwnc.cdc.gov/eid/article/26/7/20-0282_article
# https://www.nejm.org/doi/full/10.1056/NEJMoa2001316
GAMMA = 1/7

array([20, 40, 55])

array([[0.8668779 ],
       [0.86811718],
       [0.86935824],
       ...,
       [4.79978646],
       [4.80664819],
       [4.81351974]])




