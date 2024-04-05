Summary #1 
================
## Non-linear MR evaluating Vitamin D and CRP 

05/04/24

#### Data 

#### UKB Data 
- Look vitamin D and CRP in UKB measures at recruitment 
- Vitamin D (nmol/L) - check the distribution - assess whether to log transform or not. 
- CRP (mg/L) - check the distribution, the authors state the CRP was highly skewed so they log transformed the measure. 

#### GRS 

###### Vitamin D 
['Zhou et al']('https://academic.oup.com/ije/article/52/1/260/6586699?login=true'): The vitamin D instruments are based on a GWAS of Vitamin D in UKB, but taking the estimates from an earlier GWAS in the SUNLIGHT consortium. They constructed a weighted GRS using 35 SNPs. They mention the focused score based on 4 relevant loci but I don't know what they do with it exactly. 

['Hamilton et al']('https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf'): Used instruments as derived and described in this ['Burgess et al']('https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7615586/') study in the Lancet Endocrinology (UKB + other studies). In this analysis, a focused score based on 21 variants mapping to 4 genetic loci relevant to VitD metabolism was considered; but only 18 were available in UKB, the missing 3 were rare variants (MAF<0.005). Weighted GRS were calculated using PLINK v2. 

###### CRP 
['Zhou et al']('https://academic.oup.com/ije/article/52/1/260/6586699?login=true'): This score was constructed using 46 SNPs associated with CRP/weights from a ['non-UKB meta-analysis']('https://www.sciencedirect.com/science/article/pii/S0002929718303203?via%3Dihub'). They also log-transformed the CRP measurements in UKB. 

For vitamin D I think I should construct both GRS mentioned above. 

##### To do: 

- derive GRS for all 3 scores 
- derive individual PRS for each exposure, could ues `PLINK v2` to calculate a weighted score using the GWAS effect estimates; or  `begenix` like ['here']('https://2cjenn.github.io/PRS_Pipeline/'). 


#### NLMR 

['Zhou et al']('https://academic.oup.com/ije/article/52/1/260/6586699?login=true'): used 100 strata


['Hamilton et al']('https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf):

#### Residual method summary 

Notes from Hamilton paper: The measured levels of the exposure (e.g. Vitamin D) are regressed onto the instrument (e.g. VitD GRS). The residuals of that regression are the IV-free exposure. The residuals are then split into strata (often 10-100) ordered by the mean IV-free exposure value. 

For example: the sample in stratum 1 have the lowest level of "IV-free" Vitamin D, and the sample in stratum 10 have the highest. 

MR is then run within each stratum , and estimates are combined by parametric statistical methods (e.g. fractional polynomials) to estimate a non-linear curve. The rationale for stratifying by residuals as opposed to the exposure itself is driven by the aim of avoiding collider bias induced by stratification by the exposure itself. 

A problem with studies of vitamin D using this method: despite a precisely estimated null effect or a harmful overall effect - using the residual approach identified a protective effect in every strata, which upon revisit by the authors has been declared to be implausible. 

The residual method is considered bias due to a primary assumption relating to a "constant genetic effect". 

The constant genetic effect assumption doesn't hold for Vitamin D because there's a much larger genotype-exposure effect in the top strata vs the bottom strata. (Does this also raise an possibility that the non0-linear effect attributed to those below low thresholds of Vitamin D could be influenced by a weak instrument bias??). 


#### Doubly-ranked method summary 
In this method the strata are developed in multiple steps. 

1. Sort full sample by level of IV into pre-strata: The population is doubly-ranked by the level of the genetic instrument into pre-strata. 
2. Within pre-strata sorting by level of exposure: Within each pre-stratum, the participant with the lowest level of the exposure is taken and placed into the lowest final stratum. 
3. The participant with the next lowest level of the exposure in pre-strata 1 is placed into final stratum 2. i.e. the first participant from each pre-strata is placed in the first final strata. The second participant in each pre-strata is placed in the second final strata, and so on. 

The same process occurs for all pre-strata. The first stratum therefore contains the first participant of every pre-strata, each of which has the lowest level of exposure in the pre-stratum. The number of pre-stratum to be generated (K) depends on the number of strata desired (J) and the total sample size (N) using the formula N=JxK. 


This approach resolves some of the issues attributed to the residual method but is still susceptible to bias. 


#### Outcomes and covariates  
- Genetically predicted vitamin D -> Measured CRP 
- Genetically predicted CRP -> Measured Vitamin D 


Different covariates used in each study: 

['Zhou et al']('https://academic.oup.com/ije/article/52/1/260/6586699?login=true'): Many covariates: all models were adjusted for age, sex, assessment centre, birth location, SNP array, top 40 genetic principal components and nuisance factors related to the measurement of Vitamin D and/or CRP concentrations, including month in which blood sample was taken, fasting time before blood sample was taken and sample aliquots  for measurement. Adjustment for birth location and the 40 genetic components was recommended to account for the latent population structure in UKB. 


['Hamilton et al']('https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf'): Age, sex, UKB recruitment centre, smoking status (coded as current or never/ex) and the first 5 principal components from UKB directly. Smoking status was a more relevant covariate for analysis of BMI. 

#### Details 

['Zhou et al']('https://academic.oup.com/ije/article/52/1/260/6586699?login=true'): 
Used the fractional-polynomial method for NLMR of teh exposure-outcome association. UKB was stratified into 100 strata using the residuals of the exposure after regressing on the corresponding GRS. Within each stratum the localized average causal effect (LACE) was calculated using the ratio-of-coefficients method. 

['Hamilton et al']('https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf'):
Performed conventional Mr then used the `SUMnlmr` package in R to perform both the residual and doubly-ranked method on the individual level data. 

Conventional MR as performed using a 2-stage residual inclusion appreach in the `OneSampleMR` R package, using both the whole cohort then in strata of age and sex (these were outcomes). 

NLMR was performed using the standard settings in the `SUMnlmr` package, with a Gaussian distribution for linear outcomes, and a binomial distribution for binary outcomes. Used 10 strata for most analyses, but performed sensitivity analyses using different numbers of strata. 