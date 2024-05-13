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

setwd('/Volumes/MRC-IEU-research/projects/ieu2/p1/131/working/results/nlmr_vitd/nlmr.res') 

########## DATA 
overall <- fread('univar.mr.overall.txt')
overall$uci <- (overall$estimate) + (1.96*overall$std_error)
overall$lci <- (overall$estimate) - (1.96*overall$std_error)
overall<- overall[,c(2,3,7,6,4)]
colnames(overall) <-c("beta", "se", "lci","uci", "pval" )
overall$method <- "overall"
overall$strata <- "overall"
overall 

#### 1. VitD GWAS -> CRP 
vitd.gwas<- overall[1,]
vitd.gwas
df <- fread('vitd.gwas.lace.txt')


df1 <- rbind(df,vitd.gwas)


# Create a data frame
df2 <- data.frame(method = df1$method, strata = df1$strata, beta = df1$beta,
                 lci = df1$lci, uci = df1$uci)


# Define custom order for strata variable
order <- c("overall", 1:10)
order
df2$strata <- factor(df2$strata, levels = order)



p1 <- ggplot(df2, aes(x = strata, y = beta, color = method)) +
  geom_point(position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(ymin = lci, ymax = uci),
                position = position_dodge(width = 0.5), width = 0.25) +
  labs(x = "Strata of Vitamin D", y = "Vitamin D (β) on log-CRP", color = "Method", subtitle = "VitD GWAS score") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black") + 
  ggtitle("Non-linear MR of Vitamin D on CRP") +
  theme_light()






#### 2. VitD focused -> CRP 
vitd.focused<- overall[2,]
vitd.focused
df <- fread('vitd.focused.lace.txt')


df1 <- rbind(df,vitd.focused)


# Create a data frame
df2 <- data.frame(method = df1$method, strata = df1$strata, beta = df1$beta,
                  lci = df1$lci, uci = df1$uci)


# Define custom order for strata variable
order <- c("overall", 1:10)
order
df2$strata <- factor(df2$strata, levels = order)



p2 <- ggplot(df2, aes(x = strata, y = beta, color = method)) +
  geom_point(position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(ymin = lci, ymax = uci),
                position = position_dodge(width = 0.5), width = 0.25) +
  labs(x = "Strata of Vitamin D", y = "Vitamin D (β) on log-CRP", color = "Method", subtitle = "VitD focused score") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black") + 
  ggtitle("Non-linear MR of Vitamin D on CRP") +
  theme_light()

p2








#### 3. CRP -> Vitamin D 
crp<- overall[3,]
crp
df <- fread('crp.lace.txt')


df1 <- rbind(df,crp)


# Create a data frame
df2 <- data.frame(method = df1$method, strata = df1$strata, beta = df1$beta,
                  lci = df1$lci, uci = df1$uci)


# Define custom order for strata variable
order <- c("overall", 1:10)
order
df2$strata <- factor(df2$strata, levels = order)



p3 <- ggplot(df2, aes(x = strata, y = beta, color = method)) +
  geom_point(position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(ymin = lci, ymax = uci),
                position = position_dodge(width = 0.5), width = 0.25) +
  labs(x = "Strata of log CRP", y = "log-CRP (β) on Vitamin D", color = "Method", subtitle = "CRP score") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black") + 
  ggtitle("Non-linear MR of CRP on Vitamin D") +
  theme_light()

p3







###### Save plots 
# p1 
ggsave(
  filename = "plots/nlmr.vitd.gwas.png",    
  plot = p1,                 
  width = 6,                 
  height = 4,                
  dpi = 300,                  
  units = "in",              
  
)



# p2
ggsave(
  filename = "plots/nlmr.vitd.focused.png",    
  plot = p2,                 
  width = 6,                 
  height = 4,                
  dpi = 300,                  
  units = "in",              
  
)


# p3
ggsave(
  filename = "plots/nlmr.crp.png",    
  plot = p3,                 
  width = 6,                 
  height = 4,                
  dpi = 300,                  
  units = "in",              
  
)
