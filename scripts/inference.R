# setup -------------------------------------------------------------------
library(irr)

# tables ------------------------------------------------------------------

# mensuracoes como variaveis / avaliador como observacoes
tab_inf <- analytical %>%
  mutate(id = paste(avaliador, id)) %>%
  select(id, posicao, rot1, rot2, c, phisitiku, zwipp) %>%
  filter(complete.cases(.)) %>%
  group_by(id) %>%
  filter(n() == 2) %>%
  tbl_summary(by = posicao, include = -id) %>%
  # add_difference(test = everything() ~"paired.t.test", group = id)
  add_p(test = everything() ~"paired.t.test", group = id)

my_icc <- function(data, var) {
  val <- data %>%
    select(id, avaliador, posicao, {{var}}) %>%
    pivot_wider(names_from = avaliador:posicao, values_from = {{var}}) %>%
    select(-id) %>%
    icc(type = "ag")
  tibble(
    metric = {{var}},
    val[c("value", "lbound", "ubound", "p.value")] %>% as_tibble(),
    )
}

tab_icc <- rbind(
  my_icc(analytical, "c"),
  my_icc(analytical, "rot1"),
  my_icc(analytical, "rot2"),
  my_icc(analytical, "phisitiku"),
  my_icc(analytical, "zwipp")
) %>%
  mutate(
    across(c(value, lbound, ubound), ~ style_number(.x, digits = 2)),
    p.value = style_pvalue(p.value)
  )

# template p-value table
# tab_inf <- analytical %>%
#   tbl_summary(
#     include = c(group, outcome),
#     by = group,
#   ) %>%
#   # include study N
#   add_overall() %>%
#   # pretty format categorical variables
#   bold_labels() %>%
#   # bring home the bacon! (options: add_p or add_difference)
#   # add_p: quick and dirty
#   add_p(
#     # use Fisher test (defaults to chi-square)
#     test = all_categorical() ~ "fisher.test",
#     # use 3 digits in pvalue
#     pvalue_fun = function(x) style_pvalue(x, digits = 3),
#   ) %>%
#   # # diff: alternative to add_p
#   #   add_difference(
#   #     test = all_categorical() ~ "fisher.test",
#   #     # use 3 digits in pvalue
#   #     pvalue_fun = function(x) style_pvalue(x, digits = 3),
#   #     # ANCOVA
#   #     # adj.vars = c(sex, age, bmi),
#   #   ) %>%
#   # # EN
#   # modify_footnote(update = c(estimate, ci, p.value) ~ "ANCOVA (adjusted by sex, age and BMI)") %>%
#   # # PT
#   # modify_header(estimate ~ '**Diferença ajustada**') %>%
#   # modify_footnote(update = c(estimate, ci, p.value) ~ "ANCOVA (ajustada por sexo, idade e IMC)") %>%
#   # bold significant p values
#   bold_p()

# Template Cohen's D table (obs: does NOT compute p)
# tab_inf <- analytical %>%
#   # select
#   select(
#     -id,
#   ) %>%
#   tbl_summary(
#     by = group,
#   ) %>%
#   add_difference(
#     test = all_continuous() ~ "cohens_d",
#     # ANCOVA
#     adj.vars = c(sex, age, bmi),
#   ) %>%
#   modify_header(estimate ~ '**d**') %>%
#   bold_labels()
