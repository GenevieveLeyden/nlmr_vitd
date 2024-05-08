### Assessing the non-linear relationship between vitD/CRP by univariable MR in UKB  
### split by Townsend Deprivation Quartile and by Season using ivreg 

library(tidyverse)
library(dplyr)
library(data.table)
library(OneSampleMR)
library(ivreg)

setwd('/Volumes/MRC-IEU-research/projects/ieu2/p1/131/working/data/nlmr_vitd/phenotype.dat/rap/working.data/tdi.quartiles/') 


############### FUNCTIONS ###############

############### 1.Extract results ###############
extract_estimate <- function(summary) {
  
  coef_table <- summary$coef ## extract coefficients table
  exp_estimate <- grep(exp, rownames(coef_table)) #define exposure 
  F_stat <- summary$diagnostics[1, "statistic"]
  
  # Define estimates 
  estimate <- coef_table[exp_estimate, "Estimate"]
  std_error <- coef_table[exp_estimate, "Std. Error"]
  p_value <- coef_table[exp_estimate, "Pr(>|t|)"]
  
  # Build results df
  estimates_df <- data.frame(
    exposure = iv[1], ## naming the exposure after the iv's for clarity 
    estimate = estimate,
    std_error = std_error,
    p_value = p_value,
    F_stat = F_stat
  )
  
  return(estimates_df)
}


############### VARIABLES ###############
############### Vitamin D -> CRP 
## Data 
q1 <- fread('pheno.q1.txt', header = T)

covs <- c("sex", "age.at.assessment", "assessmenth.centre", "month.of.assessment", ## keep month?? 
          "fasting.time", "chip", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", 
          "PC8", "PC9", "PC10")

iv <- "vit.d.score" ## Zhou score --> get it to loop through each of the scores 

exp <- "vitamin.d"

outcome <- "crp.log"


############### MODEL ###############
formula <- paste(outcome, "~", 
                 paste(covs, collapse = " + "), 
                 paste("+ ", exp, "|"),
                 #"|", 
                 iv, " + ",
                 paste(covs, collapse = " + "))
formula <- noquote(formula)

formula





############### ANALYSIS ###############
model <- ivreg(noquote(formula), data = q1) ## get it to loop through the datasets?! 

#summary(model, diagnostics = TRUE)

res <- extract_estimate(summary(model, diagnostics = TRUE))
print(res)



