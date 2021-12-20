#!/usr/bin/env bash
#SBATCH --job-name=ca_en_preprocess
#SBATCH --output=slurm_logs/ca_en_test_preprocess_%j.out
#SBATCH --error=slurm_logs/ca_en_test_preprocess_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --time=2-00:00:00

DATA_DIR=tokenized 
DEST_DIR=data-bin

module load gcc/10.2.0 rocm/4.0.1 intel/2018.4 python/3.7.4

export LD_LIBRARY_PATH=/gpfs/projects/bsc88/projects/bne/eval_amd/scripts_to_run/external-lib:$LD_LIBRARY_PATH

source /gpfs/projects/bsc88/projects/bne/eval_amd/ksenia/venv-fairseq/bin/activate

echo $SLURM_JOB_NODELIST

# preprocess CA-EN parallel

SRC="ca"
TGT="en"

#python $(which fairseq-preprocess) --source-lang $SRC \
#  --target-lang $TGT \
#  --testpref "${DATA_DIR}/test/test.wikimatrix" \
#  --destdir $DEST_DIR \
#  --workers 128 \
#  --srcdict "${DATA_DIR}/dict.txt" --joined-dictionary \
#  --dataset-impl lazy









python $(which fairseq-preprocess) --source-lang $TGT \
  --target-lang $SRC \
  --testpref "${DATA_DIR}/test/test.wikimatrix" \
  --destdir $DEST_DIR \
  --workers 128 \
  --srcdict "${DATA_DIR}/dict.txt" --joined-dictionary \
  --dataset-impl lazy


  
