# setup -------------------------------------------------------------------
# library(survminer)

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

scale_color_discrete <- function(...) scale_color_brewer(palette = ff.pal, ...)
scale_fill_discrete <- function(...) scale_fill_brewer(palette = ff.pal, ...)

gg <- analytical_long %>%
  ggplot() +
  theme_ff()

# plots -------------------------------------------------------------------

gg.outcome <- gg +
  geom_density(aes(outcome, fill = posicao), alpha = .9) +
  facet_wrap(~ mens, scales = "free") +
  labs(
    fill = "Posição",
    caption = paste("N =", N_part, "participantes\n5 avaliadores")
       ) +
  xlab("Mensurações") +
  ylab("Densidade")

# cool facet trick from https://stackoverflow.com/questions/3695497 by JWilliman
# gg +
#   geom_histogram(bins = 5, aes(outcome, y = ..count../tapply(..count.., ..PANEL.., sum)[..PANEL..]), fill = ff.col) +
#   scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
#   xlab(attr(analytical$outcome, "label")) +
#   ylab("") +
#   facet_wrap(~ group, ncol = 2)
