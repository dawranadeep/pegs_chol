#!/bin/bash
#SBATCH --partition=highmem
#SBATCH --mail-user=ranadeep.daw@nih.gov
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=2G           # total memory per node


## Run the matlab script
SCRIPT='test.m'
srun matlab2023a  -nodesktop -nosplash -nodisplay -r "run('${SCRIPT}');exit"
