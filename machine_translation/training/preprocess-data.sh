#!/usr/bin/env bash

DATA_DIR=tokenized 
DEST_DIR=data-bin

echo $SLURM_JOB_NODELIST

# preprocess CA-EN parallel

SRC="ca"
TGT="en"

python $(which fairseq-preprocess) --source-lang $SRC \
  --target-lang $TGT \
  --trainpref "${DATA_DIR}/train/train.en-ca" \
  --validpref "${DATA_DIR}/valid/valid.en-ca" \
  --destdir $DEST_DIR \
  --workers 128 \
  --srcdict "${DATA_DIR}/dict.txt" --joined-dictionary \
  --dataset-impl lazy

# preprocess monolingual EN

python $(which fairseq-preprocess) --only-source --srcdict "${DATA_DIR}/dict.txt" \
  --trainpref "${DATA_DIR}/train/train.en" \
  --validpref "${DATA_DIR}/valid/valid.flores.en" \
  --destdir "${DEST_DIR}/en" \
  --dataset-impl lazy \
  --workers 128

# preprocess monolingual CA


python $(which fairseq-preprocess) --only-source --srcdict "${DATA_DIR}/dict.txt" \
  --trainpref "${DATA_DIR}/train/train.ca" \
  --validpref "${DATA_DIR}/valid/valid.flores.ca" \
  --destdir "${DEST_DIR}/ca" \
  --dataset-impl lazy \
  --workers 128
