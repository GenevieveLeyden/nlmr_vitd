#!/bin/bash

module add apps/plink/2.00

# specify input/output file paths
sample=/mnt/storage/private/mrcieu/data/ukbiobank/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen/data.chr1-22_plink.sample
bgen=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.1/vitd.f.genotype.bgen
outfile=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.1/vitd.f.dosage

plink2 --bgen "$bgen" ref-first --sample "$sample" --make-pgen --out "$outfile" 


