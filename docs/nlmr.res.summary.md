
 Non-linear MR: evaluating Vitamin D and CRP 
================
## Overview
Overview of analysis and methods. 

- Re-investigation of the non-linear association between Vitamin D and CRP described by [Zhou et al](https://academic.oup.com/ije/article/52/1/260/6586699?login=true) using the residual nlmr method. 
- Univariable MR analyses on UKB by Townsend Deprivation Index Quartile (TDI-Q) and by season. 

## Method details 

#### Instrumental variables 

##### Vitamin D Zhou/GWAS score 
As described by [Zhou et al](https://academic.oup.com/ije/article/52/1/260/6586699?login=true), the vitamin D instrument was based on a GWAS of Vitamin D in UKB. Effects taken from an earlier independent study (SUNLIGHT consortium). 143 SNPs were identified for Vitamin in UKB. After QC 122 were remaining. 3 of these were not present in the SUNLIGHT consortium and of the remaining SNPs only 35 replicated in the SUNLIGHT consortium GWAS. Therefore, the main score was constructed with the 35 SNPs which replicated between studies. 


##### Vitamin D focused score 
Used instruments as derived and described in the [Burgess et al]('https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7615586/') study (UKB + other studies). In this analysis, a focused score based on 21 variants mapping to 4 genetic loci relevant to VitD metabolism was considered; but only 18 were available in UKB, the missing 3 were rare variants (MAF<0.005). 

##### CRP score
Taken from [Zhou et al](https://academic.oup.com/ije/article/52/1/260/6586699?login=true): This score was constructed using 46 SNPs associated with CRP/weights from a ['non-UKB meta-analysis'](https://www.sciencedirect.com/science/article/pii/S0002929718303203?via%3Dihub). They also log-transformed the CRP measurements in UKB. 


#### Covariates 

Covariates based on the [Zhou](https://academic.oup.com/ije/article/52/1/260/6586699?login=true) study: sex + age.at.assessment + assessmenth.centre + month.of.assessment + fasting.time +
                          PC1 + (...) PC10

#### Sample 
Individuals of white British ancestry in the UKB (to match the [Zhou](https://academic.oup.com/ije/article/52/1/260/6586699?login=true) study)

#### Outcomes/Phenotypes 
All UKB 
- Used log(CRP), to match the [Zhou](https://academic.oup.com/ije/article/52/1/260/6586699?login=true) study 
- Measured Vitamin D (nmol/L)

Mean phenotypic values in TFI-Quartile groups by season, where Winter = (October->March) and 
Summer = (April->September).


#### Summer 
|	Townsend Deprivation Index	|	N	|	mean Vitamin D nmol/L	|	mean CRP mg/L	|
|	 :----:	|	 :----:	|	 :----:	|	 :----:	|
|	Q1	|	43639	|	56.23449406	|	2.2730053	|
|	Q2	|	44645	|	55.62643913	|	2.378077166	|
|	Q3	|	44818	|	53.92306312	|	2.480660404	|
|	Q4	|	43201	|	50.18716136	|	2.965550361	|

#### Winter 
|	Townsend Deprivation Index	|	N	|	mean Vitamin D nmol/L	|	mean CRP mg/L	|
|	:----:	|	:----:	|	:----:	|	:----:	|
|	Q1	|	40837	|	47.24170804	|	2.405773514	|
|	Q2	|	39435	|	46.65011687	|	2.49998469	|
|	Q3	|	38757	|	45.30158562	|	2.625797655	|
|	Q4	|	40901	|	41.51274673	|	3.031211241	|

## Results 



### Non-linear MR results 
![](plots/nlmr.vitd.gwas.png)

#### Evidence of a significant effects: 
 - Evidence of a non-linear effect of Vitamin D on CRP using the residual method. 
 - No evidence using the doubly-ranked method. 

![](plots/nlmr.vitd.focused.png)

#### Evidence of a significant effects: 
 - Evidence of a non-linear effect of Vitamin D on CRP using the residual method. 
 - No evidence using the doubly-ranked method. 

![](plots/nlmr.crp.png)

#### Evidence of a significant effects: 
 - Putative evidence for a non-linear effect of CRP on Vitamin D using the residual method in Quartile 8 of CRP only. 
 - Putative evidence for a non-linear effect of CRP on Vitamin D using the doubly-ranked method in Quartile 5 of CRP only. 





### Univaraible MR by TDI Quartile and by Season 

![](plots/v1_season_zhou.png)



![](plots/v1_season_focused.png)



![](plots/v1_season_crp.png)






#### N (Sample) with Vitamin D deficiency (Vitamin D <25nmol/L)
 
|	Townsend Deprivation Quartile 	|	Summer (N)	|	Winter (N)	|
|	:----:	|	:----:	|	:----:	|
|	Q1	|	2106	|	5033	|
|	Q2	|	2235	|	5021	|
|	Q3	|	2778	|	5788	|
|	Q4	|	4374	|	8682	|



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





## Vitamin D and depression 

#### Univariable MR by TDI Quartile and by Season 

Investigating relationship between Vitamin D and probable depression in UKB by Townsend Deprivation Index (TDI) and by season. 

Probable depression variable provided in data-field `20126`; excluded those with probable bipolar. Phenotype derived in [Smith et al 2013](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0075362). 


![](plots/univar_focused_vitd_depression.png)

- No significant effects observed using the focused vitamin D score. 

![](plots/univar_zhou_vitd_depression.png)

- Significant effect observed using the Vitamin D GWAS score between vit D and probable depression in Summer TD-I Q4 (most deprived)? 

