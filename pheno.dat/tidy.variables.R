library(data.table)
library(dplyr)

setwd('/Volumes/MRC-IEU-research/projects/ieu2/p1/131/working/data/nlmr_vitd/phenotype.dat/rap')

## phenotype data extracted from RAP 

dat <- fread('nlmr.vitd.pheno.tsv')
#print.noquote(colnames(dat)) 

colnames(dat) <- c("eid", "townsend.index","sex", "age.at.assessment", "assessmenth.centre","month.of.assessment", "vitamin.d", "crp", "bmi", "fasting.time")


## merge with linker
linker <- fread('/Volumes/MRC-IEU-research/data/ukbiobank/phenotypic/applications/81499/released/2022-06-07/data/linker.81499.csv') ## 488377
colnames(linker) <- c("IID", "eid")
dat1 <- merge(dat, linker, by = c("eid")) ## 487988

dat1 <- dat1[,c(11,1,3,4,5,6,10,2,7,8,9)]


## log the crp measure 
dat1$crp.log <- log(dat1$crp)
dat1 <- dat1[,c(1:10,12,11)]


########################### Apply exclusions ################################
# rm withdrawals 
woc <- fread('/Volumes/MRC-IEU-research/data/ukbiobank/phenotypic/applications/81499/withdrawals/withdraw81499_55_20230915.txt')
dat1 <- dat1[!which(dat1$eid %in% woc$V1),]

# rm relateds 
rel1 <- fread('../data.highly_relateds.qctools.txt', header=F)
rel2 <- fread('../data.minimal_relateds.qctools.txt', header=F)
rel <- rbind(rel1,rel2)
dat1 <- dat1[!which(dat1$IID %in% rel$V1),]

# recommended exclusions from QC 
excl <- fread('../data.combined_recommended.qctools.txt', header = F)
dat1 <- dat1[!which(dat1$IID %in% excl$V1),]


## white british filter 
wb <- fread('../data.white_british.qctools.txt', header = F) 
dat1 <- dat1[which(dat1$IID %in% wb$V1),] ## including the wb subset 
NROW(dat1) ## 336,839

## bring in scores - just the main scores used in the zhou paper first 

# crp
crp <- fread('../../instruments/extracted.genotype.dat/crp/crp.prs.sscore')
crp <- crp[,c(2,5)]
colnames(crp) <- c("IID", "crp.score")
# vit.d 
vitd <- fread('../../instruments/extracted.genotype.dat/vitd.3/vitd.prs.sscore')
vitd <- vitd[,c(2,5)]
colnames(vitd) <- c("IID", "vit.d.score")

dat2 <- merge(dat1, crp, by = c("IID"))
dat2 <- merge(dat2, vitd, by = c("IID"))

  
### correlations 
tmp <- dat2[,c("IID", "vitamin.d", "vit.d.score")]
tmp <- na.omit(tmp)
cor(tmp$vit.d.score,(tmp$vitamin.d))

tmp1 <- dat2[,c("IID", "crp.log", "crp.score")]
tmp1 <- na.omit(tmp1)
cor(tmp1$crp.score, tmp1$crp.log)




#### Look at the other vit d scores 

# vit.d 
# vitd1 <- fread('../../instruments/extracted.genotype.dat/vitd.1/vitd.f.raw.prs.sscore')
# vitd1 <- vitd1[,c(2,5)]
# colnames(vitd1) <- c("IID", "vit.d.score")
# 
# vitd2 <- fread('../../instruments/extracted.genotype.dat/vitd.2/vitd.f.transformed.prs.sscore')
# vitd2 <- vitd2[,c(2,5)]
# colnames(vitd2) <- c("IID", "vit.d.score")
# 
# 
# dat3 <- merge(dat1, vitd1, by = c("IID"))
# dat3 <- merge(dat3, vitd2, by = c("IID"))
# 
# tmp <- dat3[,c("IID", "vitamin.d", "vit.d.score.x")]
# tmp <- na.omit(tmp)
# cor(tmp$vit.d.score.x,(tmp$vitamin.d))
# 
# tmp1 <- dat3[,c("IID", "vitamin.d", "vit.d.score.y")]
# tmp1 <- na.omit(tmp1)
# cor(tmp1$vit.d.score.y, tmp1$vitamin.d)
# 
# 


###### Exploring the data 
###### Use these commands to test that the score is strongly associated with the measured trait
###### Verify that these results are the same as in the paper 

# model <- lm(vitamin.d ~ vit.d.score, data = dat2)
# summary(model)


############ Bring in Genetic covariates 
## chip & PCs 
chip <- fread('../data.covariates.qctools.txt', header = F)
colnames(chip) <- c("IID", "sex", "chip")
pcs <- fread('../data.pca1-10.qctools.txt', header = F)
colnames(pcs) <- c("IID", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")
covars <- merge(chip, pcs, by = c("IID"))
covars <- covars[,c(1,3:13)]

dat2

df <- merge(dat2, covars, by = c("IID"))





###### Save data 
write.table(dat2,'working.data/pheno.dat.filtered.txt', col.names = T, row.names = F, quote = F, sep = "\t")

write.table(df,'working.data/pheno.dat.filtered.covars.txt', col.names = T, row.names = F, quote = F, sep = "\t")

