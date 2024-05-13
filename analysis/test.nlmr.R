library(tidyverse)
library(vroom)
library(data.table)
library(SUMnlmr)
library(broom)
library(patchwork)
library(OneSampleMR)

setwd('/Volumes/MRC-IEU-research/projects/ieu2/p1/131/working/data/nlmr_vitd/phenotype.dat/rap/working.data') 

dat <- fread('pheno.dat.filtered.txt', header = T)
dat.c <- fread('pheno.dat.filtered.covars.txt', header = T)

### info on the SUMnlmr functions: https://rdrr.io/github/amymariemason/SUMnlmr/man/

# y = measured outcome 
# x = measured exposure 
# g = genotype of exposure 

### need to apply additional exclusions! 

dat1 <- subset(dat, !is.na(crp))
dat1 <- subset(dat1, !is.na(vitamin.d)) ## keeping only complete values of phenotype  ## N = 306,186
dat1 <- subset(dat1, !is.na(fasting.time)) ## adding for completeness

### Test the residual method first! 

## when including covariates would need to create the dummy variables first and include them


### creaets the summary data 
vitd.residual.1<-create_nlmr_summary(y = dat1$crp.log,
                               x = dat1$vitamin.d,
                               g = dat1$vit.d.score,
                               covar = NULL,
                               family = "gaussian",
                               strata_method = "residual", 
                               controlsonly = FALSE,
                               q = 10)

head(vitd.residual.1)$summary


model<- with(vitd.residual.1$summary, frac_poly_summ_mr(bx=bx,
                                                  by=by, 
                                                  bxse=bxse, 
                                                  byse=byse, 
                                                  xmean=xmean,
                                                  family="gaussian",
                                                  fig=TRUE)
)

summary(model)

model$figure +
  xlab("Vitamin D (nmol/L)") +
  ylab("\u394 CRP (%)")

model$lace
model$p_tests
model$p_heterogeneity



#########
######### Add in covariates 

dat.c1 <- dat.c[which(dat.c$IID %in% dat1$IID),]


# df1 <- model.frame(~  IID + sex + age.at.assessment + assessmenth.centre + month.of.assessment + fasting.time +
#                     PC1 + PC2 + PC3 + PC4 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = dat.c1)
#                   

###missing_IIDs <- df$IID[!(df$IID %in% df1$IID)] ## 8 missing complete info in fasting time?? 

####dat.c1 <- dat.c1[!(dat.c1$IID %in% missing_IIDs), ]

dummies <- model.matrix(~  sex + age.at.assessment + assessmenth.centre + month.of.assessment + fasting.time +
                          PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = dat.c1)[,-1]

NROW(dummies)


vitd.residual.c1<-create_nlmr_summary(y = dat.c1$crp.log,
                                     x = dat.c1$vitamin.d,
                                     g = dat.c1$vit.d.score,
                                     covar = dummies,
                                     family = "gaussian",
                                     strata_method = "residual", 
                                     controlsonly = FALSE,
                                     q = 10)

head(vitd.residual.c1)$summary


model.c1<- with(vitd.residual.c1$summary, frac_poly_summ_mr(bx=bx,
                                                        by=by, 
                                                        bxse=bxse, 
                                                        byse=byse, 
                                                        xmean=xmean,
                                                        family="gaussian",
                                                        fig=TRUE)
)



summary(model.c1)



model.c1$lace  
model.c1$p_tests
model.c1$p_heterogeneity

plot1 <- model.c1$figure +
  xlab("Vitamin D (nmol/L)") +
  ylab("\u394 CRP (%)") + 
  ggtitle("Non-linear MR - Residual method")

plot1



######## Test the doubly ranked method next! 
vitd.residual.c2<-create_nlmr_summary(y = dat.c1$crp.log,
                                      x = dat.c1$vitamin.d,
                                      g = dat.c1$vit.d.score,
                                      covar = dummies,
                                      family = "gaussian",
                                      strata_method = "ranked", 
                                      controlsonly = FALSE,
                                      q = 10)

head(vitd.residual.c2)$summary


model.c2<- with(vitd.residual.c2$summary, frac_poly_summ_mr(bx=bx,
                                                            by=by, 
                                                            bxse=bxse, 
                                                            byse=byse, 
                                                            xmean=xmean,
                                                            family="gaussian",
                                                            fig=TRUE)
)



summary(model.c2)

model.c2$figure +
  xlab("Vitamin D (nmol/L)") +
  ylab("\u394 CRP (%)")

model.c2$lace  
model.c2$p_tests
model.c2$p_heterogeneity

plot2 <- model.c2$figure +
  xlab("Vitamin D (nmol/L)") +
  ylab("\u394 CRP (%)") + 
  ggtitle("Non-linear MR - Doubly-ranked method")

plot2



##### Save plots 

ggsave('../../../../../results/nlmr_vitd/tests/plots/vitd.crp.nlmr.residual.png',
  plot = plot1,
  scale = 1,
  width = 20,
  height = 15,
  units = c("cm"),
  dpi = 300
)



ggsave('../../../../../results/nlmr_vitd/tests/plots/vitd.crp.nlmr.doubly.ranked.png',
       plot = plot2,
       scale = 1,
       width = 20,
       height = 15,
       units = c("cm"),
       dpi = 300
)









########## Checking the other instruments 
##### Residual 


vitd.residual.c1<-create_nlmr_summary(y = dat.c1$vitamin.d,
                                      x = dat.c1$crp.log,
                                      g = dat.c1$crp.score,
                                      covar = dummies,
                                      family = "gaussian",
                                      strata_method = "residual", 
                                      controlsonly = FALSE,
                                      q = 10)


head(vitd.residual.c1)$summary


model.c1<- with(vitd.residual.c1$summary, frac_poly_summ_mr(bx=bx,
                                                            by=by, 
                                                            bxse=bxse, 
                                                            byse=byse, 
                                                            xmean=xmean,
                                                            family="gaussian",
                                                            fig=TRUE)
)




summary(model.c1)



model.c1$lace  
model.c1$p_tests
model.c1$p_heterogeneity



####### Doubly rankned 
vitd.residual.c2<-create_nlmr_summary(y = dat.c1$vitamin.d,
                                      x = dat.c1$crp.log,
                                      g = dat.c1$crp.score,
                                      covar = dummies,
                                      family = "gaussian",
                                      strata_method = "ranked", 
                                      controlsonly = FALSE,
                                      q = 10)

head(vitd.residual.c2)$summary


model.c2<- with(vitd.residual.c2$summary, frac_poly_summ_mr(bx=bx,
                                                            by=by, 
                                                            bxse=bxse, 
                                                            byse=byse, 
                                                            xmean=xmean,
                                                            family="gaussian",
                                                            fig=TRUE)
)



summary(model.c2)

model.c2$figure +
  xlab("Vitamin D (nmol/L)") +
  ylab("\u394 CRP (%)")


model.c2$lace  
model.c2$p_tests
model.c2$p_heterogeneity

