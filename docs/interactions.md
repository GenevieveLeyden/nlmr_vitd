---
output:
  pdf_document: default
  html_document: default
  word_document: default
---
 Non-linear MR: evaluating Vitamin D and CRP 
================


## Interactions with sickness 

Analyses to investigate interactions between Vitamin D/CRP genetic exposures and sickness. 

Results were generated using two sickness variables: (1) a sickness score comprising several phenotypes & (2) the median rank across phenotypes (comparing overall severity). 

##### Sickness variables 

Score comprising binary variables:

- high Townsend deprivation index  (top 20%) 
- high Cystatin C (top 20%) 
- low FEV1 = fev1 (bottom 20%) 
- low Albumin = albumin (bottom 20%)
- high cholesterol (top 20%)
- high HbA1C (top 20%)
- history of cancer (self reported diagnoses by doctor)
 
##### Models 

```
model_sickness_score <- list(
  vitamin_d ~ vit_d_focused * sick_summary,
  vitamin_d ~ vit_d_score * sick_summary,
  crp_log ~ crp_score * sick_summary
)
model_median_rank <- list(
  vitamin_d ~ vit_d_focused * median_rank_n,
  vitamin_d ~ vit_d_score * median_rank_n,
  crp_log ~ crp_score * median_rank_n
)

```

##### Results 

### Binary sickness scores 

Effect Estimates and P-values for Sickness Rank and Interaction Effects (**Sickness score**)



|                            | beta (SE)       | p.value   |
|----------------------------|------------------|-----------|
| **vitD_focused**           |                  |           |
| Sickness summary score (main) | -1.802 (0.039)   | <1e-300   |
| vitD_focused:sickness interaction | 39.097 (6.16)  | 2.21e-10  |
| **vitD_gwas**              |                  |           |
| Sickness summary score (main) | -0.522 (0.247)   | 3.47e-02  |
| vitD_gwas:sickness interaction | -77.2 (14.07)   | 4.10e-08  |
| **CRP score**              |                  |           |
| Sickness summary score (main) | 0.284 (0.018)    | 2.96e-55  |
| CRP:sickness interaction   | -0.099 (0.606)   | 8.70e-01  |



##### Replication using log(vitamin D)
Effect Estimates and P-values for Sickness Rank and Interaction Effects (**Sickness score**)

                        

|                            | beta (SE)       | p.value   |
|----------------------|------------------|-----------|
| **vitD_focused** |                 |		     |
| Sickness summary score | -0.043 (0.001) | <1e-300	|
| vitD_focused:sickness interaction	| 0.402 (0.135) | 2.89E-03	|
| **vitD_gwas**	|		|		|
| Sickness summary score	| -0.03 (0.005)	|	3.72E-08	|
| vitD_gwas:sickness interaction | -0.778 (0.308)	| 1.15E-02	|
| **CRP**	|		|		|
| Sickness summary score | 0.284 (0.018)	| 2.96E-55	|
| CRP:sickness interaction | -0.099 (0.606) | 8.70E-01	|



### Median rank sickness 

 Effect Estimates and P-values for Sickness Rank and Interaction Effects (**Median rank sickness**)

|                   | beta (SE)       | p.value   |
|-------------------|------------------|-----------|
| **vitD_focused**  |                  |           |
| Sickness rank     | -2.266 (0.041)   | <1e-300   |
| vitD_focused:sickness interaction | 52.646 (6.596) | 1.45e-15 |
| **vitD_gwas**     |                  |           |
| Sickness rank     | -0.554 (0.263)   | 3.56e-02  |
| vitD_gwas:sickness interaction | -103.363 (15.019) | 5.91e-12 |
| **CRP**           |                  |           |
| Sickness rank     | 0.337 (0.019)    | 1.69e-67  |
| CRP:sickness interaction | 1.348 (0.649)  | 3.77e-02 |



##### Replication using log(vitamin D)
 Effect Estimates and P-values for Sickness Rank and Interaction Effects (**Median rank sickness**)

|		|	beta (SE) |	p.value	|
|--------------- |	---------------	| --------------- |
|**vitD_focused** |	                |	              |
|Sickness rank | -0.052 (0.001)	| <1e-300	|
|vitD_focused:sickness interaction	| 0.543 (0.145)	|	1.81E-04 |
|**vitD_gwas**	|		|		|
|Sickness rank	|	-0.034 (0.006)	|	6.16E-09	|
|vitD_gwas:sickness interaction	|	-1.099 (0.329)	|	8.47E-04	|
|**CRP** |		|		|
|Sickness rank |	0.337 (0.019)	|	1.69E-67	|
|CRP:sickness interaction |	1.348 (0.649)	|	3.77E-02	|




