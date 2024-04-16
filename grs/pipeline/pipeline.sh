#!/bin/bash

module add apps/bgen/1.1.6
module add apps/plink/2.00

# specify input/output file paths
snplistfile=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/organisation/snps/vitd.zhou
gendir=/mnt/storage/private/mrcieu/data/ukbiobank/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen/
outdir=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.3/
sample=/mnt/storage/private/mrcieu/data/ukbiobank/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen/data.chr1-22_plink.sample
bgen=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.3/vitd.genotype.bgen
pgen=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.3/vitd.dosage
score=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/organisation/effs/vitd.zhou.txt
prs=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.3/vitd.prs


########### 01. Extraction 

cmd=""
for i in {01..22}
do
  bgenix -g "$gendir"data.chr${i}.bgen -incl-rsids "$snplistfile" > "$outdir"chr_${i}.bgen
  cmd=$cmd"$outdir""chr_${i}.bgen "
done

# Combine the .bgen files for each chromosome into one
cat-bgen -g  $cmd -og "${outdir}"vitd.genotype.bgen -clobber
# Write index file .bgen.bgi
bgenix -g "${outdir}"vitd.f.genotype.bgen -index -clobber


# Remove the individual chromosome files
for i in {01..22}
do
  rm "${outdir}"chr_${i}.bgen 
done



########### 02. Conversion

# specify input/output file paths

plink2 --bgen "$bgen" ref-first --sample "$sample" --make-pgen --out "$pgen" 



########### 03. Score

plink2 --pfile "$pgen" \
--score "$score" no-mean-imputation \
--out "$prs"

