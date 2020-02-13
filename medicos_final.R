library(dplyr)
library(readxl)
library(writexl)
library(janitor)
library(stringi)

setwd("C:/Users/coliv/Documents/R-Projects/medicos_el_pais")
medicos_original <- read_excel("medicos_original.xlsx")

medicos_original <- medicos_original %>%
  clean_names() %>%
  rename(medicos_2019 = x43466)

med2018 <- medicos_original %>%
  select(uf1, mun1, medicos_out_2018) %>%
  mutate(mun_clean = tolower(stri_trans_general(mun1, "Latin-ASCII"))) %>%
  rename(uf = uf1)

med2019 <- medicos_original %>%
  select(uf2, mun2, medicos_2019) %>%
  mutate(mun_clean = tolower(stri_trans_general(mun2, "Latin-ASCII"))) %>%
  rename(uf = uf2)

medicos_final <- med2019 %>%
  left_join(med2018) %>%
  mutate(medicos_out_2018 = ifelse(is.na(medicos_out_2018), "não estava em 2018",
                                   medicos_out_2018)) %>%
  select(uf, mun2,medicos_out_2018, medicos_2019 )

write_xlsx(as.data.frame(medicos_final), "medicos_final.xlsx")
