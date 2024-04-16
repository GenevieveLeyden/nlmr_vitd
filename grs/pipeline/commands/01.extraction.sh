#!/bin/bash

###module add apps/qctool/2.2.0 ### edit to begenix software 

module add apps/bgen/1.1.6

# specify input/output file paths
snplistfile=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/organisation/snps/vitd.focused
gendir=/mnt/storage/private/mrcieu/data/ukbiobank/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen/
outdir=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.1/


cmd=""
for i in {01..22}
do
  bgenix -g "$gendir"data.chr${i}.bgen -incl-rsids "$snplistfile" > "$outdir"chr_${i}.bgen
  cmd=$cmd"$outdir""chr_${i}.bgen "
done

# Combine the .bgen files for each chromosome into one
cat-bgen -g  $cmd -og "${outdir}"vitd.f.genotype.bgen -clobber
# Write index file .bgen.bgi
bgenix -g "${outdir}"vitd.f.genotype.bgen -index -clobber


# Remove the individual chromosome files
for i in {01..22}
do
  rm "${outdir}"chr_${i}.bgen 
done
