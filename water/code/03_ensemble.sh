#!/bin/bash
#SBATCH --partition=highmem
#SBATCH --mail-user=ranadeep.daw@nih.gov
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=99G           # total memory per node





## Run the matlab script
SCRIPT='ensemble.m'
srun matlab2023a  -nodesktop -nosplash -nodisplay -r "run('${SCRIPT}');exit"
