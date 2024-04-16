#!/bin/bash

#SBATCH --job-name=test.pipeline.vitd.focused.raw
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH -p cpu,mrcieu
#SBATCH --account=SSCM013902
#SBATCH --mem=5GB
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=rj18633@bristol.ac.uk



# srun --exclusive -n 1 ensures analysis runs sequentially 
# --exclusive:avoids multiple scripts running simultaneously on the same node

srun --exclusive -n 1 bash 01.extraction.sh


srun --exclusive -n 1 bash 02.conversion.sh


srun --exclusive -n 1 bash 03.score.sh





