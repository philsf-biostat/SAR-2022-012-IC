# setup -------------------------------------------------------------------
library(philsfmisc)
# library(data.table)
library(tidyverse)
library(readxl)
# library(haven)
# library(foreign)
# library(lubridate)
# library(naniar)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
# data.raw <- tibble(id=gl(2, 10), group = gl(2, 10), outcome = rnorm(20))
data.raw <- read_excel("dataset/sindesmose.xlsx") %>%
  janitor::clean_names()

Nvar_orig <- data.raw %>% ncol
Nobs_orig <- data.raw %>% nrow

# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
  select(-nome) %>%
  rename(
      id = prontuario,
      ante_plantar = ant_pre,
      ante_dorsal = ant_pos,
      incis_plantar = incis_pre,
      incis_dorsal = incis_pos,
      poste_plantar = post_pre,
      poste_dorsal = post_pos,
      zwipp_plantar = zwipp_plan,
      zwipp_dorsal = zwipp_dors,
  ) %>%
  mutate() %>%
  filter()

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  mutate(
    id = factor(id), # or as.character
  )

# reshape
data.raw <- data.raw %>%
  pivot_longer(3:12, values_to = "outcome") %>%
  separate(name, into = c("mens", "posicao")) %>%
  pivot_wider(names_from = mens, values_from = outcome)

# variáveis do estudo
# renomear as variáveis de distâncias mensuradas A, B e C
# calcular as métricas
data.raw <- data.raw %>%
  rename(
    a = ante,
    b = poste,
    c = incis,
  ) %>%
  mutate(
    rot1 = a/b,
    rot2 = b-a,
    # c = c,
  )

# de-identificar avaliadores
data.raw <- data.raw %>%
  group_by(avaliador) %>%
  mutate(avaliador = paste("Avaliador", cur_group_id())) %>%
  ungroup() %>%
  arrange(avaliador)

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    posicao = "Posição",
    a = "Distância A",
    b = "Distância B",
    c = "Distância C",
    rot1 = "Rotação 1",
    rot2 = "Rotação 2",
    phisitiku = "Phisitiku",
    zwipp = "Zwipp",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw %>%
  # select analytic variables
  select(
    id,
    # group,
    # outcome,
    avaliador,
    posicao,
    a,b,c,rot1,rot2,
    phisitiku,
    zwipp,
  )

Nvar_final <- analytical %>% ncol
Nobs_final <- analytical %>% nrow

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( id = c( "1", "2", "3", "...", "N") ) %>%
# analytical_mockup <- tibble( id = c( "1", "2", "3", "...", as.character(Nobs_final) ) ) %>%
  left_join(analytical %>% head(0), by = "id") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")

outcomes <- c("rot1","rot2","c","phisitiku","zwipp")
analytical_long <- analytical %>%
  pivot_longer(cols = -c(id, avaliador, posicao), names_to = "mens", values_to = "outcome")
