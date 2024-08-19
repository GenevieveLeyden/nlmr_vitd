library(data.table)
library(dplyr)

setwd('/projects/MRC-IEU/research/data/ukbiobank/phenotypic/applications/81499/released/2022-06-07/data')

## Taking measurements at recruitment 

## Key
## eid - "eid" -- got 
## age at attendance instance 0 "21003-0.0" -- got 
## sex "31-0.0" -- got 
## Assessment center "54-0.0"  -- got 
## Month of attendance -- "55-0.0" -- got 
## Place of birth is a atrange one and done by co-ordinates. Is this necessary of looking at Townsend I? - also its uk or other 
## Townsend index at recruitment - "22189-0.0" -- got  ###### NOT FOUND #### NEED TO GET THIS FROM DNAnexus?? 
## Vitamin D -- "30890-0.0" -- got  
## CRP -- "30710-0.0" -- got ######### NOT FOUND 
## bmi instance 0 "21001-0.0" -- got 


## haven't taken vitD supplementation - dodgy variable 

## chip ?? i think in the genetic file
## principal components saved separately 


dat <- fread('data.51913.csv', select = c("eid", "31-0.0", "21003-0.0", "54-0.0", "55-0.0", "22189-0.0", "30890-0.0", "30710-0.0","21001-0.0"))

## rm withdrawals
woc <- fread('../../../withdrawals/withdraw81499_55_20230915.txt')

dat <-(dat[!which(dat$eid %in% woc$V1),]) ##502357



## merge with linker
linker <- fread('linker.81499.csv') ## 488377
colnames(linker) <- c("IID", "eid")

dat1 <- merge(dat, linker, by = c("eid")) ## 488118



## rename variables 

colnames(dat1) <- c("eid", "sex", "age.at.attendance", "assessment.center", "month.of.attendance", "vitamin.D", "crp", "bmi", "IID")

#write.table(dat1, "/projects/MRC-IEU/research/projects/ieu2/p1/131/working/data/nlmr_vitd/phenotype.dat/raw.pheno.dat1.txt", col.names = T, row.names = F, quote = F, sep = "\t")

### Also extracting this phenotype data usind the RAP - to pick up variables missing in our release 



