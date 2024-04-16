#!/bin/bash

module add apps/plink/2.00

pgen=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.1/vitd.f.dosage
score=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/organisation/effs/vitd.focused.raw.txt
outfile=/user/work/rj18633/nlmr_vitd/data/nlmr_vitd/instruments/extracted.genotype.dat/vitd.1/vitd.f.raw.prs


plink2 --pfile "$pgen" \
--score "$score" no-mean-imputation \
--out "$outfile"

