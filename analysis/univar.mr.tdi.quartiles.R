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

path <- getwd()
##filenames <- list.files(path = path) ## 
### V1 files 
#f1 <- list.files(path = path, pattern = ".summer.txt")
#f2 <- list.files(path = path, pattern = ".winter.txt")
#filenames <- c(f1,f2)



#### V2 files 
filenames <- list.files(path = path) 
subset <- c("pheno.q1.txt", "pheno.q2.txt", "pheno.q3.txt","pheno.q4.txt")
filenames <- filenames[which(filenames %in% subset)]


### V1 
#covs <- c("sex", "age.at.assessment", "assessmenth.centre", "month.of.assessment", ## keep month?? ## makes no difference after checking
 #         "fasting.time", "chip", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", 
  #        "PC8", "PC9", "PC10")


### V2 - adjust for season instead
covs <- c("sex", "age.at.assessment", "assessmenth.centre", "month.of.assessment", ## keep month?? ## 
          "season","fasting.time", "chip", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", 
         "PC8", "PC9", "PC10")

############# UPDATE WHICH SCORE IS BEING USED! ################### 
##iv <- "vit.d.score" ## Update manually??! 
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




####################### Version 2 - loop 

results <- list()

# Iterate over each filename
for (filename in filenames) {
  # Read in the input file
  q1 <- fread(filename, header = TRUE)  # Assuming data is in tabular format
  
  q1$season <- ifelse(q1$season == "summer", 1, 0) ### update variables to binary ## makes no difference 
  
  # Run the analysis
  model <- ivreg(noquote(formula), data = q1)
  
  # Extract the estimates and weak instruments p-value
  res <- extract_estimate(summary(model, diagnostics = TRUE))
  
  # Append results to the list
  results[[filename]] <- res
}

# Combine all results into a single data frame
combined_results <- do.call(rbind, results)

combined_results$exp <- rownames(combined_results)
row.names(combined_results) <- NULL
combined_results$exp <- gsub("pheno\\.|\\.txt", "", combined_results$exp)

combined_results





##### Save output 
##write.table(combined_results, "../../../../../../results/nlmr_vitd/univariable.mr.TDI/univar.tdiq.season.zhou.vitd.txt", col.names = T, row.names = F, quote = F, sep = "\t")
  
##write.table(combined_results, "../../../../../../results/nlmr_vitd/univariable.mr.TDI/univar.tdiq.season.focused.vitd.txt", col.names = T, row.names = F, quote = F, sep = "\t")

##write.table(combined_results, "../../../../../../results/nlmr_vitd/univariable.mr.TDI/univar.tdiq.season.focused.transformed.vitd.txt", col.names = T, row.names = F, quote = F, sep = "\t")

#write.table(combined_results, "../../../../../../results/nlmr_vitd/univariable.mr.TDI/univar.tdiq.season.crp.txt", col.names = T, row.names = F, quote = F, sep = "\t")


### need to repeat the last anlaysis using crp as didn't save the df 

#### V2 results 

#write.table(combined_results, "../../../../../../results/nlmr_vitd/univariable.mr.TDI/univar.tdiq.V2.crp.txt", col.names = T, row.names = F, quote = F, sep = "\t")

##write.table(combined_results, "../../../../../../results/nlmr_vitd/univariable.mr.TDI/univar.tdiq.V2.vitd.zhou.txt", col.names = T, row.names = F, quote = F, sep = "\t")

#write.table(combined_results, "../../../../../../results/nlmr_vitd/univariable.mr.TDI/univar.tdiq.V2.vitd.focused.txt", col.names = T, row.names = F, quote = F, sep = "\t")



