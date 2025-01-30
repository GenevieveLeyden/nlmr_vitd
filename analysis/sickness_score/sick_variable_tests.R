library(tidyverse)
library(broom)
library(gt)

##  
setwd('/')

d <- fread('sickness_vars.txt', header = T) %>%
  janitor::clean_names()

dat <- d

####  

dat$vitamin_d_original <- dat$vitamin_d
dat$vitamin_d <- log(dat$vitamin_d)

#### create sickness variables 



# Step 1: Identify High/Low Risk Groups
dat <- dat %>%
  mutate(
    high_townsend = townsend_index > quantile(townsend_index, 0.8, na.rm = TRUE),
    high_cystatin = cystatin_c > quantile(cystatin_c, 0.8, na.rm = TRUE),
    low_fev1 = fev1 < quantile(fev1, 0.2, na.rm = TRUE),
    low_albumin = albumin < quantile(albumin, 0.2, na.rm = TRUE),
    high_cholesterol = cholesterol > quantile(cholesterol, 0.8, na.rm = TRUE),
    high_hba1c = hba1c > quantile(hba1c, 0.8, na.rm = TRUE)
  )

# Step 2: Create Binary Indicators
dat <- dat %>%
  mutate(
    high_townsend = as.numeric(high_townsend),
    high_cystatin = as.numeric(high_cystatin),
    low_fev1 = as.numeric(low_fev1),
    low_albumin = as.numeric(low_albumin),
    high_cholesterol = as.numeric(high_cholesterol),
    high_hba1c = as.numeric(high_hba1c),
    cancer = as.numeric(cancer)  # Assuming cancer is already binary
  )

# Step 3: Create the sick_summary Variable
dat <- dat %>%
  mutate(
    sick_summary = high_townsend + high_cystatin + low_fev1 + low_albumin + high_cholesterol + high_hba1c + cancer
  )

# Step 4: Rank Based on sick_summary and Other Variables
# Reverse fev1 and albumin (lower values = worse)
dat_rank <- dat %>%
  mutate(
    fev1 = -fev1,
    albumin = -albumin
  ) %>%
  mutate(
    # Rank each of the relevant variables
    rank_townsend_index = rank(townsend_index),
    rank_cystatin_c = rank(cystatin_c),
    rank_fev1 = rank(fev1),
    rank_albumin = rank(albumin),
    rank_cholesterol = rank(cholesterol),
    rank_hba1c = rank(hba1c)
  ) %>%
  mutate(
    # Calculate the median rank across these variables
    median_rank = apply(select(., rank_townsend_index, rank_cystatin_c, rank_fev1, rank_albumin, rank_cholesterol, rank_hba1c), 1, median),
    
    # Normalize the median rank to get median_rank_n
    median_rank_n = scale(median_rank)
  )

# Display a summary of the new variables
summary(dat_rank %>% select(sick_summary, median_rank_n))



##### V1 
##### models 
# Define the list of models with the specified PRS interacting with median rank
model_formulas_median <- list(
  vitamin_d ~ vit_d_focused * median_rank_n,
  vitamin_d ~ vit_d_score * median_rank_n,
  crp_log ~ crp_score * median_rank_n
)

# Define the list of models with the specified PRS interacting with sick_summary
model_formulas_sick<- list(
  vitamin_d ~ vit_d_focused * sick_summary,
  vitamin_d ~ vit_d_score * sick_summary,
  crp_log ~ crp_score * sick_summary
)





# List of effects to extract for each model
effects_median <- list(
  c("median_rank_n", "vit_d_focused:median_rank_n"),
  c("median_rank_n", "vit_d_score:median_rank_n"),
  c("median_rank_n", "crp_score:median_rank_n")
)

effects_sick <- list(
  c("sick_summary", "vit_d_focused:sick_summary"),
  c("sick_summary", "vit_d_score:sick_summary"),
  c("sick_summary", "crp_score:sick_summary")
)




# Relabeling function
relabel_term <- function(term) {
  case_when(
    term == "median_rank_n" ~ "Sickness rank",
    term == "vit_d_focused:median_rank_n" ~ "vitD_focused:sickness interaction",
    term == "vit_d_score:median_rank_n" ~ "vitD_gwas:sickness interaction",
    term == "crp_score:median_rank_n" ~ "CRP:sickness interaction",
    term == "sick_summary" ~ "Sickness summary score",
    term == "vit_d_focused:sick_summary" ~ "vitD_focused:sickness interaction",
    term == "vit_d_score:sick_summary" ~ "vitD_gwas:sickness interaction",
    term == "crp_score:sick_summary" ~ "CRP:sickness interaction",
    TRUE ~ term
  )
}



# Function to extract desired statistics
extract_stats <- function(model, effect) {
  tidy(model) %>%
    filter(term %in% effect) %>%
    mutate(
      term = relabel_term(term),
      estimate = round(estimate, 3),
      std.error = round(std.error, 3),
      beta_se = paste0(estimate, " (", std.error, ")"),
      p.value = ifelse(p.value < 1e-300, "<1e-300", format(p.value, scientific = TRUE, digits = 3))
    ) %>%
    select(term, beta_se, p.value)
}

  
  # Fit models and extract statistics for median_rank_n
  models_median <- map(model_formulas_median, ~ lm(.x, data = dat_rank))
  results_median <- map2_dfr(models_median, effects_median, extract_stats)
  
  # Add an exposure column for grouping for median_rank_n
  results_median <- results_median %>%
    mutate(
      exposure = rep(c("vitD_focused", "vitD_gwas", "CRP"), each = 2)
    )
  
  # Fit models and extract statistics for sick_summary
  models_sick <- map(model_formulas_sick, ~ lm(.x, data = dat_rank))
  results_sick <- map2_dfr(models_sick, effects_sick, extract_stats)
  
  # Add an exposure column for grouping for sick_summary
  results_sick <- results_sick %>%
    mutate(
      exposure = rep(c("vitD_focused", "vitD_gwas", "CRP"), each = 2)
    )
  

  
  
  # Create the table for median_rank_n using gt and group by exposure
  table_median <- results_median %>%
    group_by(exposure) %>%
    gt() %>%
    tab_header(
      title = "Effect Estimates and P-values for Sickness Rank and Interaction Effects (Median Rank)"
    ) %>%
    cols_label(
      term = "Effect",
      beta_se = "Beta (SE)",
      p.value = "P-value"
    )
  
  # Create the table for sick_summary using gt and group by exposure
  table_sick <- results_sick %>%
    group_by(exposure) %>%
    gt() %>%
    tab_header(
      title = "Effect Estimates and P-values for Sickness Rank and Interaction Effects (Sick Summary)"
    ) %>%
    cols_label(
      term = "Effect",
      beta_se = "Beta (SE)",
      p.value = "P-value"
    )

  # Display tables
  table_median
  table_sick
  
  

  
    ### save results 
  #write.table(results_sick, "../../../results/nlmr_vitd/nlmr.res/interactions/sickness_score_interactions.txt", row.names = F, col.names = T, quote = F, sep = "\t")
  #write.table(results_median, "../../../results/nlmr_vitd/nlmr.res/interactions/median_rank_interactions.txt", row.names = F, col.names = T, quote = F, sep = "\t")
  
  # Save table_median as HTML
#  gtsave(table_sick, "../../../results/nlmr_vitd/nlmr.res/interactions/table_sickness_interaction.html")
#  gtsave(table_median, "../../../results/nlmr_vitd/nlmr.res/interactions/table_median_rank_interaction.html")
  

  ### replication results using log(vitamin D)
  
  write.table(results_sick, "../../../results/nlmr_vitd/nlmr.res/interactions/sickness_score_interactions_log_vitD_rep.txt", row.names = F, col.names = T, quote = F, sep = "\t")
  write.table(results_median, "../../../results/nlmr_vitd/nlmr.res/interactions/median_rank_interactions_log_vitD_rep.txt", row.names = F, col.names = T, quote = F, sep = "\t")
  
  # Save table_median as HTML
    gtsave(table_sick, "../../../results/nlmr_vitd/nlmr.res/interactions/table_sickness_interaction_log_vitD_rep.html")
    gtsave(table_median, "../../../results/nlmr_vitd/nlmr.res/interactions/table_median_rank_interaction_log_vitD_rep.html")
  
  
  
  
  
  
  
  
  ### Results
   ## vitD_focused: Both approaches indicate that the vitD_focused genetic score's predictive power for vitamin D levels increases with higher sickness levels. The magnitude of the interaction effect is larger in the median rank approach.
   ## vitD gwas: Both approaches show that the vitD_gwas genetic score's ability to predict vitamin D levels decreases with increasing sickness. The negative interaction effect is more pronounced in the median rank approach. 
   ## crp:Comparison: The interaction effect for CRP is not significant in the sickness summary approach but significant in the median rank approach, with the direction of the effect being different. This discrepancy might arise from differences in how sickness is quantified (summary vs. median rank) and could suggest that CRP’s role in predicting sickness is more complex or context-dependent.

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ###### V2 
  ###### UPDATES with extra models :: 
  
  ## update with exrta models 
  model_formulas_median <- list(
    vitamin_d ~ vit_d_focused * median_rank_n,
    vitamin_d ~ vit_d_score * median_rank_n,
    crp_log ~ crp_score * median_rank_n,
    crp_log ~ vit_d_focused * median_rank_n,
    crp_log ~ vit_d_score * median_rank_n,
    vitamin_d ~ crp_score * median_rank_n          # Added interaction model
  )
  
  model_formulas_sick <- list(
    vitamin_d ~ vit_d_focused * sick_summary,
    vitamin_d ~ vit_d_score * sick_summary,
    crp_log ~ crp_score * sick_summary,
    crp_log ~ vit_d_focused * sick_summary,
    crp_log ~ vit_d_score * sick_summary,
    vitamin_d ~ crp_score * sick_summary           # Added interaction model
  )
  
  

  ## update with exrta models 
  effects_median <- list(
    c("median_rank_n", "vit_d_focused:median_rank_n"),
    c("median_rank_n", "vit_d_score:median_rank_n"),
    c("median_rank_n", "crp_score:median_rank_n"),
    c("median_rank_n", "vit_d_focused:median_rank_n"),
    c("median_rank_n", "vit_d_score:median_rank_n"),
    c("median_rank_n", "crp_score:median_rank_n")  # Added interaction effect
  )
  
  effects_sick <- list(
    c("sick_summary", "vit_d_focused:sick_summary"),
    c("sick_summary", "vit_d_score:sick_summary"),
    c("sick_summary", "crp_score:sick_summary"),
    c("sick_summary", "vit_d_focused:sick_summary"),
    c("sick_summary", "vit_d_score:sick_summary"),
    c("sick_summary", "crp_score:sick_summary")    # Added interaction effect
  )
  
  
  
  # Relabeling function
  relabel_term <- function(term) {
    case_when(
      term == "median_rank_n" ~ "Sickness rank",
      term == "vit_d_focused:median_rank_n" ~ "vitD_focused:sickness interaction",
      term == "vit_d_score:median_rank_n" ~ "vitD_gwas:sickness interaction",
      term == "crp_score:median_rank_n" ~ "CRP:sickness interaction",
      term == "sick_summary" ~ "Sickness summary score",
      term == "vit_d_focused:sick_summary" ~ "vitD_focused:sickness interaction",
      term == "vit_d_score:sick_summary" ~ "vitD_gwas:sickness interaction",
      term == "crp_score:sick_summary" ~ "CRP:sickness interaction",
      TRUE ~ term
    )
  }
  
  # Function to extract desired statistics
  extract_stats <- function(model, effect) {
    tidy(model) %>%
      filter(term %in% effect) %>%
      mutate(
        term = relabel_term(term),
        estimate = round(estimate, 3),
        std.error = round(std.error, 3),
        beta_se = paste0(estimate, " (", std.error, ")"),
        p.value = ifelse(p.value < 1e-300, "<1e-300", format(p.value, scientific = TRUE, digits = 3))
      ) %>%
      select(term, beta_se, p.value)
  }
  
  
  
  # Fit models and extract statistics for median_rank_n
  models_median <- map(model_formulas_median, ~ lm(.x, data = dat_rank))
  results_median <- map2_dfr(models_median, effects_median, extract_stats)
  
  # Add an exposure column for grouping for median_rank_n
  results_median <- results_median %>%
    mutate(
      exposure = rep(c("vitD_focused", "vitD_gwas", "CRP", "CRP_vitD_focused", "CRP_vitD_gwas", "CRP_sick"), each = 2)
    )
  
  # Fit models and extract statistics for sick_summary
  models_sick <- map(model_formulas_sick, ~ lm(.x, data = dat_rank))
  results_sick <- map2_dfr(models_sick, effects_sick, extract_stats)
  
  # Add an exposure column for grouping for sick_summary
  results_sick <- results_sick %>%
    mutate(
      exposure = rep(c("vitD_focused", "vitD_gwas", "CRP", "CRP_vitD_focused", "CRP_vitD_gwas", "CRP_sick"), each = 2)
    )
  
  
  
  # Create the table for median_rank_n using gt and group by exposure
  table_median <- results_median %>%
    group_by(exposure) %>%
    gt() %>%
    tab_header(
      title = "Effect Estimates and P-values for Sickness Rank and Interaction Effects (Median Rank)"
    ) %>%
    cols_label(
      term = "Effect",
      beta_se = "Beta (SE)",
      p.value = "P-value"
    )
  
  # Create the table for sick_summary using gt and group by exposure
  table_sick <- results_sick %>%
    group_by(exposure) %>%
    gt() %>%
    tab_header(
      title = "Effect Estimates and P-values for Sickness Rank and Interaction Effects (Sick Summary)"
    ) %>%
    cols_label(
      term = "Effect",
      beta_se = "Beta (SE)",
      p.value = "P-value"
    )
  
  table_median
  table_sick
