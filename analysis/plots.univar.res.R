###############################################################
################## Plots ######################################
library(ggforestplot)
library(ggpubr)
library(ggforce)
library(RColorBrewer)
library(rlang)
library(tidyverse)
library(dplyr)
library(data.table)

setwd('/Volumes/MRC-IEU-research/projects/ieu2/p1/131/working/results/nlmr_vitd/univariable.mr.TDI/plots') 



######################################
############# FUNCTION ###############
######################################
forestplot1 <- function (df, name = name, estimate = estimate, se = se, pvalue = NULL, 
                         colour = NULL, shape = NULL, logodds = FALSE, psignif = 0.05, 
                         ci = 0.95, ...) 
{
  stopifnot(is.data.frame(df))
  stopifnot(is.logical(logodds))
  name <- enquo(name)
  estimate <- enquo(estimate)
  se <- enquo(se)
  pvalue <- enquo(pvalue)
  colour <- enquo(colour)
  shape <- enquo(shape)
  const <- stats::qnorm(1 - (1 - ci)/2)
  df <- df %>% dplyr::mutate(`:=`(!!name, factor(!!name, levels = !!name %>% 
                                                   unique() %>% rev(), ordered = TRUE)), .xmin = !!estimate - 
                               const * !!se, .xmax = !!estimate + const * !!se, .filled = TRUE, 
                             .label = sprintf("%.2f", !!estimate))
  if (logodds) {
    df <- df %>% mutate(.xmin = exp(.data$.xmin), .xmax = exp(.data$.xmax), 
                        `:=`(!!estimate, exp(!!estimate)))
  }
  #  if (!quo_is_null(pvalue)) {
  #   df <- df %>% dplyr::mutate(.filled = !!pvalue < !!psignif)
  #}
  g <- ggplot2::ggplot(df, aes(x = !!estimate, y = !!name))
  if (logodds) {
    g <- g + scale_x_continuous(trans = "log10", breaks = scales::log_breaks(n = 7))
  }
  g <- g + theme_forest() + scale_colour_ng_d() + scale_fill_ng_d() + 
    geom_vline(xintercept = ifelse(test = logodds, 
                                   yes = 1, no = 0), linetype = "solid", size = 0.4, colour = "black")
  g <- g + geom_effect(ggplot2::aes(xmin = .data$.xmin, xmax = .data$.xmax, 
                                    colour = !!colour, shape = !!shape, filled = .data$.filled), 
                       position = ggstance::position_dodgev(height = 0.5)) + 
    ggplot2::scale_shape_manual(values = c(23L, 21L, 22L, 
                                           24L, 25L)) + guides(colour = guide_legend(reverse = T), 
                                                               shape = guide_legend(reverse = T))
  args <- list(...)
  if ("title" %in% names(args)) {
    g <- g + labs(title = args$title)
  }
  if ("subtitle" %in% names(args)) {
    g <- g + labs(subtitle = args$subtitle)
  }
  if ("caption" %in% names(args)) {
    g <- g + labs(caption = args$caption)
  }
  if ("xlab" %in% names(args)) {
    g <- g + labs(x = args$xlab)
  }
  if (!"ylab" %in% names(args)) {
    args$ylab <- ""
  }
  g <- g + labs(y = args$ylab)
  if ("xlim" %in% names(args)) {
    g <- g + coord_cartesian(xlim = args$xlim)
  }
  if ("ylim" %in% names(args)) {
    g <- g + ylim(args$ylim)
  }
  g
}





##########################################
################ Data ####################
##########################################


################# V1 plot ################
#df <- fread('../univar.tdiq.season.zhou.vitd.txt', header =T)
#df <- fread('../univar.tdiq.DEFICIENT.zhou.vitd.txt', header =T)

#df <- fread('../univar.tdiq.season.focused.vitd.txt', header =T)
#df <- fread('../univar.tdiq.DEFICIENT.focused.vitd.txt', header =T)

#df <- fread('../univar.tdiq.season.crp.txt', header =T)
df <- fread('../univar.tdiq.DEFICIENT.crp.txt', header =T)

####df <- fread('../univar.mr.vitdDeficientQ4.txt')
####df$name <- "Q4.vitD.deficient"
colnames(df) <- c('Exposure', 'beta', 'se', 'pvalue', 'fstat', 'N', 'name')

#### Order variables 
# Define the levels in the desired order
desired_levels <- c("q1.summer", "q1.winter", "q2.summer", "q2.winter", 
                    "q3.summer", "q3.winter", "q4.summer", "q4.winter")

# Convert the 'name' column to a factor with desired levels
df$name <- factor(df$name, levels = desired_levels)

df <- df[order(df$name), ]

df
#colours1 <- c('midnightblue')
colours1 <- c('mediumvioletred')




# Figure a
p1 <- forestplot1(
  df = df,
  estimate = beta,
  colour = Exposure,
  pvalue = pvalue,
  size = beta,
  psignif = 0.05,
  title = "Univariable MR effects of Vitamin D on CRP - VitD deficient population",
  #title = "Univariable MR effects of CRP on Vitamin D",
  #subtitle = "VitD GWAS score",
  #subtitle = "VitD focused score",
  subtitle = "CRP score",
  #xlab = "change in log(CRP) per 1-SD change in Vitamin D (95% CI)",
  xlab = "change in Vitamin D per 1-SD change in log(CRP) (95% CI)",
) +
  # scale_size_manual(values = c(2,2,2)) +
  scale_color_manual(values=colours1) +
  
  ### Code to rescale the plot if necessary ### 
  #ggplot2::coord_cartesian( 
  #xlim = c(0.5, 5.0) 
  #) + 
  #scale_x_continuous(breaks = c(0.5, 1.0, 2.0, 3.0, 5.0)) + 
  guides(shape = guide_legend(override.aes = list(linetype = "blank"))) +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    text = element_text(colour = "black"), 
    strip.background = element_blank(),
    strip.text = element_text(colour = "black"),
    panel.border = element_rect(fill = NA, colour = "grey20", size = rel(1)),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    axis.text = element_text(colour = "black"),
    axis.title = element_text(colour = "black"),
    axis.ticks = element_line(size = 0.25, colour = "grey20"),
    plot.title = element_text(hjust = 0.5, size=12)
  )

p1


ggsave(
  #filename = "v1_season_zhou.png",    
  #filename = "v1_season_focused.png", 
  #filename = "v1_season_crp.png",   
  #filename = "v3_season_deficient_zhou.png",    
  #filename = "v3_season_deficient_focused.png", 
  filename = "v3_season_deficient_crp.png",   
  plot = p1,                  # The ggplot object
  width = 6,                 # Width of the plot in inches
  height = 4,                # Height of the plot in inches
  dpi = 300,                 # DPI (resolution) of the plot
  units = "in",              # Units of width and height
  
)





################# V2 plot ################

################# V1 plot ################
#df1 <- fread('../univar.tdiq.V2.vitd.zhou.txt', header =T)
df1 <- fread('../univar.tdiq.V2.vitd.focused.txt', header =T)
#df1 <- fread('../univar.tdiq.V2.crp.txt', header =T)
colnames(df1) <- c('Exposure', 'beta', 'se', 'pvalue', 'fstat', 'name')


colours2 <- c('mediumvioletred')


# Figure a
p2 <- forestplot1(
  df = df1,
  estimate = beta,
  colour = Exposure,
  pvalue = pvalue,
  size = beta,
  psignif = 0.05,
  title = "Univariable MR effects of Vitamin D on CRP (season adjusted)",
  #title = "Univariable MR effects of CRP on Vitamin D (season adjusted)",
  #subtitle = "VitD GWAS score",
  subtitle = "VitD focused score",
  #subtitle = "CRP score",
  xlab = "change in log(CRP) per 1-SD change in Vitamin D (95% CI)",
  #xlab = "change in Vitamin D per 1-SD change in log(CRP) (95% CI)",
) +
  # scale_size_manual(values = c(2,2,2)) +
  scale_color_manual(values=colours2) +
  
  ### Code to rescale the plot if necessary ### 
  #ggplot2::coord_cartesian( 
  #xlim = c(0.5, 5.0) 
  #) + 
  #scale_x_continuous(breaks = c(0.5, 1.0, 2.0, 3.0, 5.0)) + 
  guides(shape = guide_legend(override.aes = list(linetype = "blank"))) +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    text = element_text(colour = "black"), 
    strip.background = element_blank(),
    strip.text = element_text(colour = "black"),
    panel.border = element_rect(fill = NA, colour = "grey20", size = rel(1)),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    axis.text = element_text(colour = "black"),
    axis.title = element_text(colour = "black"),
    axis.ticks = element_line(size = 0.25, colour = "grey20"),
    plot.title = element_text(hjust = 0.5, size=12)
  )

p2





ggsave(
  #filename = "v2_season_zhou.png",    
  filename = "v2_season_focused.png",    
  #filename = "v2_season_crp.png",    
  plot = p2,                 
  width = 6,                 # Width inches
  height = 4,                # Height  inches
  dpi = 300,                 # DPI (resolution) 
  units = "in",              
  
)




















###########
df1 <- df
# Figure a
p3 <- forestplot1(
  df = df1,
  estimate = beta,
  colour = Exposure,
  pvalue = pvalue,
  size = beta,
  psignif = 0.05,
  title = "Univariable MR effects in VitD deficient (<25nmol/L) TDI-Q4 population",
  #title = "Univariable MR effects of CRP on Vitamin D (season adjusted)",
  #subtitle = "VitD GWAS score",
  subtitle = "Results of bidirectional analysis",
  #subtitle = "CRP score",
  xlab = "change in outcome per 1-SD change in exposure (95% CI)",
  #xlab = "change in Vitamin D per 1-SD change in log(CRP) (95% CI)",
) +
  # scale_size_manual(values = c(2,2,2)) +
  ###scale_color_manual(values=colours2) +
  
  ### Code to rescale the plot if necessary ### 
  #ggplot2::coord_cartesian( 
  #xlim = c(0.5, 5.0) 
  #) + 
  #scale_x_continuous(breaks = c(0.5, 1.0, 2.0, 3.0, 5.0)) + 
  guides(shape = guide_legend(override.aes = list(linetype = "blank"))) +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    text = element_text(colour = "black"), 
    strip.background = element_blank(),
    strip.text = element_text(colour = "black"),
    panel.border = element_rect(fill = NA, colour = "grey20", size = rel(1)),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    axis.text = element_text(colour = "black"),
    axis.title = element_text(colour = "black"),
    axis.ticks = element_line(size = 0.25, colour = "grey20"),
    plot.title = element_text(hjust = 0.5, size=12)
  )

p3



ggsave(
  filename = "v3_univarMR_vitDdeficientQ4.png",   
  plot = p3,                 
  width = 6,                 # Width inches
  height = 4,                # Height  inches
  dpi = 300,                 # DPI (resolution) 
  units = "in",              
  
)


