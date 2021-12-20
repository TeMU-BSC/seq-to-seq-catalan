#!/bin/bash

#SBATCH --job-name=train_tokenizer
#SBATCH --output=slurm_logs/train_tokenizer_ca_en_%j.out
#SBATCH --error=slurm_logs/train_tokenizer_ca_en_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --time=2-00:00:00


module load gcc/10.2.0 rocm/4.0.1 intel/2018.4 python/3.7.4
export LD_LIBRARY_PATH=/gpfs/projects/bsc88/projects/bne/eval_amd/slurms/external-lib:$LD_LIBRARY_PATH

source /gpfs/projects/bsc88/projects/bne/eval_amd/env/bin/activate && source /gpfs/projects/bsc88/projects/bne/eval_amd/env-fairseq09/bin/activate

echo $SLURM_JOB_NODELIST

python train_tokenizer.py