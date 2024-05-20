---
output:
  html_document: default
  pdf_document: default
  word_document: default
---
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
['Zhou et al'](https://academic.oup.com/ije/article/52/1/260/6586699?login=true): The vitamin D instruments are based on a GWAS of Vitamin D in UKB, but taking the estimates from an earlier GWAS in the SUNLIGHT consortium. They constructed a weighted GRS using 35 SNPs. In brief - in a GWAS of Vitamin D in UKB 143 Snps were identified. After filtering INDELs and sex chromosome SNPs 122 were remaining. 3 of these were not present in hte SUNLIGHT consortium and of the remaining only 35 replicated in the SUNLIGHT consortium GWAS. Therefore, the scores were construcetd with the 35 which replicated between studies, and sensitivity analyses were performed using the 122. They mention the focused score based on 4 relevant loci but it's not clear what they do with it exactly. 

['Hamilton et al'](https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf): Used instruments as derived and described in this ['Burgess et al']('https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7615586/') study in the Lancet Endocrinology (UKB + other studies). In this analysis, a focused score based on 21 variants mapping to 4 genetic loci relevant to VitD metabolism was considered; but only 18 were available in UKB, the missing 3 were rare variants (MAF<0.005). Weighted GRS were calculated using PLINK v2. 

###### CRP 
['Zhou et al'](https://academic.oup.com/ije/article/52/1/260/6586699?login=true): This score was constructed using 46 SNPs associated with CRP/weights from a ['non-UKB meta-analysis'](https://www.sciencedirect.com/science/article/pii/S0002929718303203?via%3Dihub). They also log-transformed the CRP measurements in UKB. 

For vitamin D I think I should construct both GRS mentioned above. 

### Sensitivities 
In the ['Zhou et al'](https://academic.oup.com/ije/article/52/1/260/6586699?login=true) paper they run both a 1-sample and 2-sample absed analysis (different SNPs for the 2-Sample analysis). May need to refer back to this. 

##### To do: 

- derive GRS for all 3 scores 
- derive individual PRS for each exposure, could ues `PLINK v2` to calculate a weighted score using the GWAS effect estimates; or  `begenix` like ['here'](https://2cjenn.github.io/PRS_Pipeline/). 


#### NLMR 

['Zhou et al'](https://academic.oup.com/ije/article/52/1/260/6586699?login=true): used 100 strata


['Hamilton et al'](https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf):

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

[Zhou et al](https://academic.oup.com/ije/article/52/1/260/6586699?login=true): Many covariates: all models were adjusted for age, sex, assessment centre, birth location, SNP array, top 40 genetic principal components and nuisance factors related to the measurement of Vitamin D and/or CRP concentrations, including month in which blood sample was taken, fasting time before blood sample was taken and sample aliquots  for measurement. Adjustment for birth location and the 40 genetic components was recommended to account for the latent population structure in UKB. 

The month of sample collection is useful because then we can take account for the effect Spring/Summer/, Autumn/Winter effects on Vitamin D exposure. 

##### Sample
They restricted their analysis to White British based on self-reported and genetics, and had a total sample size of N = 294,970 

I can restrict to White British or White European based on the genetic PCs and I don't think it will restrict it quite as much.. 

[Hamilton et al](https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf): Age, sex, UKB recruitment centre, smoking status (coded as current or never/ex) and the first 5 principal components from UKB directly. Smoking status was a more relevant covariate for analysis of BMI. 

##### Sample
Used the in-house European derived subset 
Also excluded people with sex-chromosome mismatch, QC as outlined on the in-house documentation. 

#### Details 

[Zhou et al](https://academic.oup.com/ije/article/52/1/260/6586699?login=true): 
Used the fractional-polynomial method for NLMR of teh exposure-outcome association. UKB was stratified into 100 strata using the residuals of the exposure after regressing on the corresponding GRS. Within each stratum the localized average causal effect (LACE) was calculated using the ratio-of-coefficients method. 

[Hamilton et al](https://www.medrxiv.org/content/10.1101/2023.08.21.23293658v3.full.pdf):
Performed conventional Mr then used the `SUMnlmr` package in R to perform both the residual and doubly-ranked method on the individual level data. 

Conventional MR as performed using a 2-stage residual inclusion appreach in the `OneSampleMR` R package, using both the whole cohort then in strata of age and sex (these were outcomes). 

NLMR was performed using the standard settings in the `SUMnlmr` package, with a Gaussian distribution for linear outcomes, and a binomial distribution for binary outcomes. Used 10 strata for most analyses, but performed sensitivity analyses using different numbers of strata. 



##

## Analysis notes 

### Organise directories 

Will want to mirror the file structures between bc4 and project space on the rdsf so scripts and the data extracted/generated can be backed up appropriately. 

### Generate PGS 

##### Steps 
1. Get instrument estimates from publications.
2. Harmonise instruments/check coding against UKB sumstats.
3. Extract SNPs from genetic data (`begenix`).
4. Convert to dosage (`plink2`).
5. Prepare cohort (individual IDs, linekr file, apply exclusions). 
6. Extract phenotype data. 
6. Merge with scores. 



#### Get instrument estimates from publications. 
The focused score consists of the same SNPs between the Zhou and Hamilton study - but looks like the estimates are sometimes coded differently? They're not incorrect as where the allele differs the direction of the effect differs also.. I guess just important to make sure the coding in whichever version I use is consistent with UKB?? Maybe just get the estimates from the original publication where the score was derived?? The allele coding in the hamilton study matches that of the burgess study. Use the burgess estimates, expect that there will be 3 missing and check coding. 

Extract the snplists from the the SNPstats: 
I've created a script to extract each set of instruments from the `sumstats` files & extracted the `sumstats`. All expected SNPs are present except 1 SNP is missing from the vitD.zhou score (34/35 present). 

Tomorrow: 
- check allele coding 
- update if necessary
- investigate why 1 snp is missing 
- keep working on the scores 

The coding between A1 and A2 differs for a proportion of SNPs in each score. Need to find code from the short course which describes harmonizing these between the studies. 

- Write script to harmonise allele coding between studies 


the crp exposure should be 46 not 50 - the 4 extra snps were an additional sensitivity from another study and estimates weren't provide in the supplementary material. 

I need to find out whether plink automatically harmonizes alleles when generating a score. 

Main points about allele harmonization: 
- Ensure the alleles are coded the same (e.g. A-C/A-C not A-C/T-G)
- Effect alleles should match the reference in the individual data 
- It's not essential to make the effect allele reflect the the positive direction of effect, but people tend to prefer to do this (I guess just due to consistency). 
- Because I'm giving plink the effect allele and effect estimate, this is otherwise all mostly handled by plink. 

- continue checking the gwas alleles are coded this way in the sumstats 
- create the plink score file 
- then create the snp extraction script 
- then the prs script 


I have the snps files ready now, it's time to extract the snps/genotype data from the begen files for all individuals. 

SNP lists are here: `data/nlmr_vitd/instruments/organisation/snps`
Weights are here: `data/nlmr_vitd/instruments/organisation/effs`

I'm there are two vitamin D focused exposures because I want to compare the effect of transforming all the betas to be positive (as they haven previously been transformed for the other exposures), or keeping them in the exact format they appeared in the hamilton paper (mixed direction of effect). 

- Transfer the files to bc4 
- work on script to extract begens. 



#### Extract SNPs from bgen files 

Using [this](https://2cjenn.github.io/PRS_Pipeline/) online tutorial as a reference. 


Looking around the ukb individual/genetic level data atm. 


Going to use the dataset as recommended below, with these notes associated: 


#### 5.1 Filtered bgen files

Filtered bgen files that contain only the less stringent 'european' subset based on an in house kmeans clustering algorithm and after removing the standard exclusions (n=463,005, described in sections 2.1 and 2.2 of this document) are available. MAF and imputation info scores were recalculated on this subset of individuals and the following graded filtering of SNPs was performed (with varying imputation quality for different allele frequency ranges):

	Info>0.3 for MAF >3%
	Info>0.6 for MAF 1-3%
	Info>0.8 for MAF 0.5-1%
	Info>0.9 for MAF 0.1-0.5%

We recommend using these filtered files for your analysis, due to their reduction in size. They are located here:
`./data/ukbiobank/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen`
This directory also contains the associated sample (.sample) files for use with qctools and the index files (.bgi) for use the bgenix software.

The accompanying sample-stats files and snp-stats are located alongside this directory in:
./data/ukbiobank/genetic/variants/arrays/imputed/released/2018-09-18/data/sample-stats
and
./data/ukbiobank/genetic/variants/arrays/imputed/released/2018-09-18/data/snp-stats

NB. In total there are 12,370,749 SNPs and 463,005 individuals present in these files. Please be aware of duplicate SNPs due to triallelic alleles that may not fit the Info and MAF filtering mentioned above.

Please see associated documentation (/docs) for full information about all files in the /data folder.

 

Will revisit and apply additional restrictions as required based on the phenotype data etc. afterwards. 


Check out the output using commands like this: 

`module add apps/bgen/1.1.6`

`bgenix -g crp_genotype.bgen -list | column -t`



There are notes and code on how to handle multi-allelic snps/loci in the online tutorial, which comments on allele alignment also. Going to continue to the next step, on using plink to produce summary stats next and will revisit as necessary. 
Also further description of both SNP QC and sample QC. I'm not interested in SNP QC as I just want all the SNPs as described in the ohter publications. I'm also not interested in sample QC as I'll apply the exclusions afterwards based on the MRC pipeline information bout related individuals  etc. 

Plink2 has the capacity to convert bgen files to both dosage and hard-calls (as some plink tools only works on hard-calls). We're interested in the dosage files. 

So far I have: 

- extracted snps from the bgen files 
- converted that data to plink2 format 
- next want to generate the scores on that data 

Could be nice to check if I could run all 3 of the above steps from a single `slurm` script.

- lastly, will want to apply all necessary filters 
- merge with phenotype data 

Some standard exclusions have already been applied to the sample dataset that I am using. These are described in detail in sections 2.1 and 2.2 [here](https://data.bris.ac.uk/datasets/1ovaau5sxunp2cv8rcy88688v/UK%20Biobank%20Genetic%20Data_MRC%20IEU%20Quality%20Control%20version%202.pdf), and referred to as the filtered bgen files. My current sample size is 463005. Check whether additional exclusions are necessary later. 

Now I have all the scripts to generate the scores - I want to see if I can integrate them into a pipeline, so they all run from a single slurm submission - will test this out for the first vitamin D score. 

Now that I have scripts for the scores - and possibly a pipeline, the next thing is to get the phenotype datasets ready. 

The outcomes are measured VitaminD and CRP - and also looking at the latest update GDS sent about Townsend depravity index. 
With Townsend Deprivation index I'd need to divide individuals into each of the quartiles. 
Split data into time of year (of Vitamine D measurement)
Then test using simple linear MR the relationship between genetically higher Vitamin D on CRP in for e.g. Winter in each of the quartiles. 
So we have a group with a real Vitamin D deficiency - and is there a real effect of Vitamin D on CRP in them. 

To do: 

- back up the prs pipeline and data generated to the rdsf/github 
- make a plan for the phenotype data needed 
- need phenotype and covariate data for the initial nlmr fot vitD and CRP 
- need phenotype data to follow up the analysis with the townsend deprivation index data/time of year 

A note on the Townsend score: 

Positive values of the index will indicate areas with high material deprivation, whereas those with negative values will indicate relative affluence 



Need to get some data from other sources - get Townsend Index data from DNAnexus. 

TOMORROW - figure out how to extract data and download it from DNAnexus! (for this and the lifecourse stuff)

#### DNAnexus phenotype data 

Export selected phenotypic fields from the UKB study into a TSV (or CSV) using the Table Exporter app as described [here](https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/accessing-phenotypic-data-as-a-file).

- Open the dataset
- Select Data Preview
- Click +Add Columns 
- Keep building the phenotype dataset like this until ready 
- Select Dashboard Actions > Save Dashboard View and name the file 
- Navigate to the project folder and select Start Analysis 
- Select the Table Exporter app > Run Selected 
- Name the job 
- Within the Inputs tab: Select record > select the dataset you've just created.
- The table exporter app doesn't extract participant ID. It must be specified in the advanced options using: Entity = participant, and Field Names = eid in advanced options 
- Then select Options: specify filename (Output prefix) and File format (TSV). Coding Option > RAW, Header Style > UKB-FORMAT  
- Start Analysis 

Phenotype data has now been extracted - going to download it and merge with the linker file/withdrawals. There was an issue extracting the phenotype data - either could only extract the IDs or only the phenotype file - still need to work on this. Get this data today and then work on the code Gus sent. 


- `dx ls -la` gets the file ids - very useful 
- `dx describe` on a file gives you very useful file information on the platform. 
- you can only mv, not cp a file, due to the unique file ids generated on creation 
- every file has a property called eid and field (id in ukb the file corresponds to). You can use `dx find data` to find data using these properties. 
- use `dx download <file-id>` to download data 

Now I have been able to extract the phenotype data - need to download it, merge with linker files and remove withdrawals. Getting the field names/key for the ids using this: 

`dx extract_dataset app81499_20240207020122.dataset --list-fields > ukb_pheno.fields.txt` - but getting the appropriate dataset id 




### Exploring the data 

Focusing on the crp and Zhou vitamin D score for now. 

First sanity check, verify that the GRS is strongly associated with the trait and we're getting a similar result as reported in the paper. Using these commands: 

``` 
model <- lm(vitamin.d ~ vit.d.score, data = dat)
summary(model)
```

- The Zhou Vitamin D score is strongly associated with measured vitamin D (P<2e16).
- The r-squared is 0.02818 indicating that the score explains 2.8% of variation in the trait (same as what was reported in the paper)
- Should check the F-statistic - not sure how they calculated it in the paper
- The crp score explains the same amount of variation in log crp as reported by the pape also (~6%). The authors use log crp so I will continue to use log crp and measured vitamin D. 

- I now have code which performs onesample mr (without covariates)
- Need to update the data to include appropriate covariates (PCs etc)
- And update the data to run the Townsend index analysis 
- Before that, get the code for the nlmr script working 
- The have a meeting to plan the data/strata/groups - or just draw it out

Tomorrow: 

- play with code to run nlmr 
- Then plan all analyses (covariates etc)
- organise and run all analyses (Monday??)



#### Sample exclusions 
- The publications had different criteria for their exclusions 
- As I'm repeating the Zhou paper, will restrict to White British ancestry for now 
- They used questionnaire and genetic data - I'm just going to use the British subset as defined by the IEU QC pipeline 
- Basing the remaining standard exclusions on the recommendations in the IEU pipeline: excluding all standard exclusions (chromosome issues), excluding highly related individuals & keeping White British participants 
- I've already applied the filter for those with withdrawn consent 
- Filter highly and minimally related 
- Info to refer to is [here](https://data.bris.ac.uk/datasets/1ovaau5sxunp2cv8rcy88688v/UK%20Biobank%20Genetic%20Data_MRC%20IEU%20Quality%20Control%20version%202.pdf) 


#### Preliminary results from test script 

- I can replicate the results from the paper using the residual method - evidence for a non-linear effect of Vitamin D on CRP. Effect of Vitamin D on CRP only in the strata with the lowest Vitamin D. 
- No evidence for a non-linear effect using the Doubly-ranked method. 

#### Test results 

- 1SMR
- method = `tsri`
- repeat this using `ivreg` instead and also including the covariates on each side of the equation 

|	analysis	|	beta	|	se	|	pval	|
|	:----:	|	:----:	|	:----:	|	:----:	|
|	osmr: vitd->crp (no covariates)	|	-0.000201298	|	0.000544045	|	0.711380988	|
|	osmr: crp->vitd (no covariates)	|	-0.171012523	|	0.144634759	|	0.237056939	|
|	osmr: vitd->crp	|	0.18402747	|	0.004526784	|	0	|
|	osmr: crp->vitd	|	0.016858526	|	0.00023053	|	0	|







- NLMR 
- Vitamin D on CRP 
- Residual & Doubly-ranked 
- should make better plots for proper results 

![alt text](vitd.crp.nlmr.residual-3.png)![alt text](vitd.crp.nlmr.doubly.ranked-3.png)
 




