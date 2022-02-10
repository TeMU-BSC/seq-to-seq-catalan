#!/usr/bin/env bash

DATA_SOURCE=data/original
DATA_TARGET=data/tokenized
TOKENIZER=path/to/tokenizer
# https://github.com/pytorch/fairseq/blob/main/examples/roberta/multiprocessing_bpe_encoder.py
PYTHON_SCRIPT=multiprocessing_bpe_encoder.py
source="full"
target="sum"

for SPLIT in train valid test
do
  for LANG in full sum
  do
    python $PYTHON_SCRIPT \
    --encoder-json $TOKENIZER/vocab.json \
    --vocab-bpe $TOKENIZER/merges.txt \
    --inputs "$DATA_SOURCE/$SPLIT.${LANG}" \
    --outputs "$DATA_TARGET/${SPLIT}.bpe.${LANG}" \
    --workers 128 \
    --keep-empty;
  done
done

