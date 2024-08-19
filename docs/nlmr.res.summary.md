---
output:
  html_document: default
  pdf_document: default
  word_document: default
---
 Non-linear MR: evaluating Vitamin D and CRP 
================
## Overview

- Re-investigation of the non-linear association between Vitamin D and CRP described by [Zhou et al](https://academic.oup.com/ije/article/52/1/260/6586699?login=true) using the residual nlmr method. 
- Univariable MR analyses on UKB by Townsend Deprivation Index Quartile (TDI-Q) and by season. 

## Method details 

#### Instrumental variables 

##### Vitamin D Zhou/GWAS score 
As described by [Zhou et al](https://academic.oup.com/ije/article/52/1/260/6586699?login=true), the vitamin D instrument was based on a GWAS of Vitamin D in UKB. Effects taken from an earlier independent study (SUNLIGHT consortium). 143 SNPs were identified for Vitamin in UKB. After QC 122 were remaining. 3 of these were not present in the SUNLIGHT consortium and of the remaining SNPs only 35 replicated in the SUNLIGHT consortium GWAS. Therefore, the main score was constructed with the 35 SNPs which replicated between studies. 


##### Vitamin D focused score 
Used instruments as derived and described in this [Burgess et al]('https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7615586/') study (UKB + other studies). In this analysis, a focused score based on 21 variants mapping to 4 genetic loci relevant to VitD metabolism was considered; but only 18 were available in UKB, the missing 3 were rare variants (MAF<0.005). 

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

#### Evidence of a significant effects: 
 - Vitamin D on CRP in Q1 (least deprived) during Summer. 

![](plots/v1_season_focused.png)

#### Evidence of a significant effects: 
 - No evidence of a significant effect of VIT D on CRP using the focused score. 


![](plots/v1_season_crp.png)

#### Evidence of a significant effects: 
 - CRP on Vitamin D in Q1 (least deprived) during Winter  




#### N (Sample) with Vitamin D deficiency (Vitamin D <25nmol/L)
 
|	Townsend Deprivation Quartile 	|	Summer (N)	|	Winter (N)	|
|	:----:	|	:----:	|	:----:	|
|	Q1	|	2106	|	5033	|
|	Q2	|	2235	|	5021	|
|	Q3	|	2778	|	5788	|
|	Q4	|	4374	|	8682	|


