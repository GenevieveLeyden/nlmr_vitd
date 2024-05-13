library(tidyverse)
library(dplyr)
library(data.table)
library(OneSampleMR)
library(ivreg)

setwd('/Volumes/MRC-IEU-research/projects/ieu2/p1/131/working/data/nlmr_vitd/phenotype.dat/rap/working.data/') 


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




######### DATA 
df <- fread('pheno.dat.filtered.covars1.txt')


covs <- c("sex", "age.at.assessment", "assessmenth.centre", "month.of.assessment", 
          "fasting.time", "chip", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", 
          "PC8", "PC9", "PC10")




############# UPDATE WHICH SCORE IS BEING USED! ################### 
#iv <- "vit.d.score" ## Update manually??! 
iv <- "vit.d.focused"
# iv <- "vit.d.focused.transformed"
exp <- "vitamin.d"
# 
outcome <- "crp.log"
# 


###### Update for the opposite direction
#iv <- "crp.score"
#exp <- "crp.log"

#outcome <- "vitamin.d"




############### MODEL ###############
formula <- paste(outcome, "~", 
                 paste(covs, collapse = " + "), 
                 paste("+ ", exp, "|"),
                 #"|", 
                 iv, " + ",
                 paste(covs, collapse = " + "))
formula <- noquote(formula)

formula


# Run the analysis
model <- ivreg(noquote(formula), data = df)

# Extract the estimates and weak instruments p-value
#res1 <- extract_estimate(summary(model, diagnostics = TRUE))
res2 <- extract_estimate(summary(model, diagnostics = TRUE))
#res3 <- extract_estimate(summary(model, diagnostics = TRUE))


res <- rbind(res1,res2,res3)

write.table(res, '../../../../../results/nlmr_vitd/nlmr.res/univar.mr.overall.txt', col.names = T, row.names = F, quote = F, sep = "\t")
