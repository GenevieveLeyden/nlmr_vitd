#!/bin/bash

#SBATCH --job-name=pipeline.vitd.zhou
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH -p cpu,mrcieu
#SBATCH --account=SSCM013902
#SBATCH --mem=5GB
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=rj18633@bristol.ac.uk


bash pipeline.sh

