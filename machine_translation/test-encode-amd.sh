#!/bin/bash

#SBATCH --job-name=encode_spm
#SBATCH --output=slurm_logs/encode_spm_ca_en_%j.out
#SBATCH --error=slurm_logs/encode_spm_ca_en_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --time=2-00:00:00


module load gcc/10.2.0 rocm/4.0.1 intel/2018.4 python/3.7.4
export LD_LIBRARY_PATH=/gpfs/projects/bsc88/projects/bne/eval_amd/slurms/external-lib:$LD_LIBRARY_PATH

source /gpfs/projects/bsc88/projects/bne/eval_amd/env/bin/activate && source /gpfs/projects/bsc88/projects/bne/eval_amd/env-fairseq09/bin/activate

echo $SLURM_JOB_NODELIST

for DATASET in 1_ca_en_un.en  2_ca_en_cyber.en  3_ca_en_bio.n   4_ca_en_floresdev.en  5_ca_en_florestest.en  6_ca_en_wmtnews2013.en 1_en_ca_un.ca  2_en_ca_cyber.ca  3_en_ca_bio.ca  4_en_ca_floresdev.ca  5_en_ca_florestest.ca  6_en_ca_wmtnews2013.ca; do

  python spm_encode.py --model tokenized/m.model --inputs raw/all_test_sets/$DATASET --outputs tokenized/all_test_sets/$DATASET --max-len 512

done;

