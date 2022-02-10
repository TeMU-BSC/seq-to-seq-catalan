#!/usr/bin/env bash

DATA_DIR=data/tokenized
DEST_DIR=data-bin

# preprocess CATSUM/VILAWEB parallel spm tokenized for MBART large

SRC="full"
TGT="sum"

load_config

python $(which fairseq-preprocess) \
  --source-lang $SRC \
  --target-lang $TGT \
  --trainpref "${DATA_DIR}/train.spm" \
  --validpref "${DATA_DIR}/valid.spm" \
  --testpref "${DATA_DIR}/test.spm" \
  --destdir "${DEST_DIR}" \
  --workers 128 \
  --srcdict mbart.cc25/dict.txt \
  --tgtdict mbart.cc25/dict.txt;
