library(tidyverse)
library(vroom)
library(data.table)
library(SUMnlmr)
library(broom)
library(patchwork)
library(OneSampleMR)

setwd('/Volumes/MRC-IEU-research/projects/ieu2/p1/131/working/data/nlmr_vitd/phenotype.dat/rap/working.data') 

dat.c <- fread('pheno.dat.filtered.covars1.txt', header = T)


### filter for compelte values 
dat1 <- subset(dat.c, !is.na(crp))
dat1 <- subset(dat1, !is.na(vitamin.d)) ## keeping only complete values of phenotype  ## N = 306,186
dat1 <- subset(dat1, !is.na(fasting.time)) ## adding for completeness

# y = measured outcome 
# x = measured exposure 
# g = genotype of exposure 

####### 1. Residual method 

### i. create dummy matrix variable for covariates  - same for all analyses 
dummies.1 <- model.matrix(~  sex + age.at.assessment + assessmenth.centre + month.of.assessment + fasting.time +
                          PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = dat1)[,-1]

NROW(dummies.1)

### ii. create summary data 
##### a. Vit D GWAS score -> CRP 
vitd.residual.1<-create_nlmr_summary(y = dat1$crp.log,
                                      x = dat1$vitamin.d,
                                      g = dat1$vit.d.score,
                                      covar = dummies.1,
                                      family = "gaussian",
                                      strata_method = "residual", 
                                      controlsonly = FALSE,
                                      q = 10)

head(vitd.residual.1)$summary


### iii. fit the model
model.residual.1<- with(vitd.residual.1$summary, frac_poly_summ_mr(bx=bx,
                                                            by=by, 
                                                            bxse=bxse, 
                                                            byse=byse, 
                                                            xmean=xmean,
                                                            family="gaussian",
                                                            fig=TRUE)
)



summary(model.residual.1)

model.residual.1$lace  

### iv. get the effect estimates for each strata 
effs1 <-model.residual.1$lace %>% as.data.frame() %>% mutate(method = "Residual") %>%
  mutate(strata = row_number())
  

##### b. Vit D focused score -> CRP 
### ii. create summary data 
vitd.residual.2<-create_nlmr_summary(y = dat1$crp.log,
                                     x = dat1$vitamin.d,
                                     g = dat1$vit.d.focused,
                                     covar = dummies.1,
                                     family = "gaussian",
                                     strata_method = "residual", 
                                     controlsonly = FALSE,
                                     q = 10)

head(vitd.residual.2)$summary


### iii. fit the model
model.residual.2<- with(vitd.residual.2$summary, frac_poly_summ_mr(bx=bx,
                                                                   by=by, 
                                                                   bxse=bxse, 
                                                                   byse=byse, 
                                                                   xmean=xmean,
                                                                   family="gaussian",
                                                                   fig=TRUE)
)



summary(model.residual.2)

model.residual.2$lace  

### iv. get the effect estimates for each strata 
effs3 <-model.residual.2$lace %>% as.data.frame() %>% mutate(method = "Residual") %>%
  mutate(strata = row_number())






##### b. CRP -> Vitamin D 
### ii. create summary data 
vitd.residual.3<-create_nlmr_summary(y = dat1$vitamin.d,
                                     x = dat1$crp.log,
                                     g = dat1$crp.score,
                                     covar = dummies.1,
                                     family = "gaussian",
                                     strata_method = "residual", 
                                     controlsonly = FALSE,
                                     q = 10)

head(vitd.residual.3)$summary


### iii. fit the model
model.residual.3<- with(vitd.residual.3$summary, frac_poly_summ_mr(bx=bx,
                                                                   by=by, 
                                                                   bxse=bxse, 
                                                                   byse=byse, 
                                                                   xmean=xmean,
                                                                   family="gaussian",
                                                                   fig=TRUE)
)



summary(model.residual.3)

model.residual.3$lace  

### iv. get the effect estimates for each strata 
effs5 <-model.residual.3$lace %>% as.data.frame() %>% mutate(method = "Residual") %>%
  mutate(strata = row_number())















####### 2. Doubly ranked method 

##### a. Vit D GWAS score -> CRP 
### i. creae the summary data - same covariates as before 
vitd.ranked.1<-create_nlmr_summary(y = dat1$crp.log,
                                      x = dat1$vitamin.d,
                                      g = dat1$vit.d.score,
                                      covar = dummies.1,
                                      family = "gaussian",
                                      strata_method = "ranked", 
                                      controlsonly = FALSE,
                                      q = 10)

head(vitd.ranked.1)$summary


model.ranked.1<- with(vitd.ranked.1$summary, frac_poly_summ_mr(bx=bx,
                                                            by=by, 
                                                            bxse=bxse, 
                                                            byse=byse, 
                                                            xmean=xmean,
                                                            family="gaussian",
                                                            fig=TRUE)
)



summary(model.ranked.1)

model.ranked.1$lace  
model.ranked.1$p_tests
model.ranked.1$p_heterogeneity


effs2 <-model.ranked.1$lace %>% as.data.frame() %>% mutate(method = "Ranked") %>%
  mutate(strata = row_number())



vitd.gwas <- rbind(effs1,effs2)


##### b. Vit D focused score -> CRP 
### i. create the summary data - same covariates as before 
vitd.ranked.2<-create_nlmr_summary(y = dat1$crp.log,
                                     x = dat1$vitamin.d,
                                     g = dat1$vit.d.focused,
                                     covar = dummies.1,
                                     family = "gaussian",
                                     strata_method = "ranked", 
                                     controlsonly = FALSE,
                                     q = 10)

head(vitd.ranked.2)$summary


model.ranked.2<- with(vitd.ranked.2$summary, frac_poly_summ_mr(bx=bx,
                                                                 by=by, 
                                                                 bxse=bxse, 
                                                                 byse=byse, 
                                                                 xmean=xmean,
                                                                 family="gaussian",
                                                                 fig=TRUE)
)



summary(model.ranked.2)

model.ranked.2$lace  
model.ranked.2$p_tests
model.ranked.2$p_heterogeneity


effs4 <-model.ranked.2$lace %>% as.data.frame() %>% mutate(method = "Ranked") %>%
  mutate(strata = row_number())



vitd.focused <- rbind(effs3,effs4)










##### c. CRP -> Vitamin D 
### i. create the summary data - same covariates as before 
vitd.ranked.3<-create_nlmr_summary(y = dat1$vitamin.d,
                                   x = dat1$crp.log,
                                   g = dat1$crp.score,
                                   covar = dummies.1,
                                   family = "gaussian",
                                   strata_method = "ranked", 
                                   controlsonly = FALSE,
                                   q = 10)

head(vitd.ranked.3)$summary


model.ranked.3<- with(vitd.ranked.3$summary, frac_poly_summ_mr(bx=bx,
                                                               by=by, 
                                                               bxse=bxse, 
                                                               byse=byse, 
                                                               xmean=xmean,
                                                               family="gaussian",
                                                               fig=TRUE)
)



summary(model.ranked.3)

model.ranked.3$lace  
model.ranked.3$p_tests
model.ranked.3$p_heterogeneity


effs6 <-model.ranked.3$lace %>% as.data.frame() %>% mutate(method = "Ranked") %>%
  mutate(strata = row_number())


crp <- rbind(effs5,effs6)