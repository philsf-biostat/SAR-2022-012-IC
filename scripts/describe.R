# setup -------------------------------------------------------------------

# library(Hmisc) # describe
# library(skimr) # skim
# library(gmodels) # CrossTable
library(gtsummary)
library(gt)
# library(effectsize)
# library(finalfit) # missing_compare

# setup gtsummary theme
theme_ff_gtsummary()
theme_gtsummary_compact()
theme_gtsummary_language(language = "pt") # traduzir

# exploratory -------------------------------------------------------------

# overall description
# analytical %>%
#   skimr::skim()

# minimum detectable effect size
# interpret_cohens_d(0.5)
# cohens_d(outcome ~ group, data = analytical) %>% interpret_cohens_d()
# interpret_icc(0.7)

# tables ------------------------------------------------------------------

# criar objetos

# # descritiva das mensurações
# tab_desc <- analytical %>%
#   # pivot_wider(names_from = mens, values_from = outcome) %>%
#   tbl_summary(
#     include = -c(id, avaliador),
#     by = posicao,
#   ) %>%
#   # modify_caption(caption = "**Tabela 1** Características demográficas") %>%
#   # modify_header(label ~ "**Características dos pacientes**") %>%
#   bold_labels() %>%
#   modify_table_styling(columns = "label", align = "c")
# 
# # avaliadores como variaveis / mensuracao como observacoes
# tab_desc_2 <- analytical %>%
#   pivot_wider(names_from = posicao, values_from = a:zwipp) %>%
#   tbl_summary(include = -id, by = avaliador)
# 
# write_rds(tab_desc, "dataset/tab_desc1.rds")
# write_rds(tab_desc_2, "dataset/tab_desc2.rds")

# carregar objetos salvos
tab_desc <- read_rds("dataset/tab_desc1.rds")
tab_desc_2 <- read_rds("dataset/tab_desc2.rds")
