# setup -------------------------------------------------------------------
library(irr)

my_icc <- function(data, var) {
  val <- data %>%
    select(id, avaliador, posicao, {{var}}) %>%
    pivot_wider(names_from = avaliador:posicao, values_from = {{var}}) %>%
    select(-id) %>%
    icc(type = "ag")
  tibble(
    metric = var_label(data, unlist = TRUE)[{{var}}],
    val[c("value", "lbound", "ubound", "p.value")] %>% as_tibble(),
  ) %>%
    transmute(
      metric,
      # across(c(value, lbound, ubound), ~ style_number(.x, digits = 2)),
      icc = style_number(value, digits = 2),
      ic = format.interval(c(lbound, ubound)),
      p.value = style_pvalue(p.value)
    )
}

# tables ------------------------------------------------------------------

# # mensuracoes como variaveis / avaliador como observacoes
# tab_inf <- analytical %>%
#   mutate(id = paste(avaliador, id)) %>%
#   select(id, posicao, rot1, rot2, c, phisitiku, zwipp) %>%
#   filter(complete.cases(.)) %>%
#   group_by(id) %>%
#   filter(n() == 2) %>%
#   tbl_summary(by = posicao, include = -id) %>%
#   # add_difference(test = everything() ~"paired.t.test", group = id)
#   modify_header(label ~ "**Mensurações**") %>%
#   add_p(test = everything() ~"paired.t.test", group = id)
# 
# write_rds(tab_inf, "dataset/tab_inf.rds")

tab_inf <- read_rds("dataset/tab_inf.rds")

tab_icc <- rbind(
  my_icc(analytical, "c"),
  my_icc(analytical, "rot1"),
  my_icc(analytical, "rot2"),
  my_icc(analytical, "phisitiku"),
  my_icc(analytical, "zwipp")
  )
