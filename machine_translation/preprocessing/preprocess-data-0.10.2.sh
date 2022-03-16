#!/usr/bin/env bash


SRC="ca"
TGT="en"

python $(which fairseq-preprocess) --source-lang $SRC \
  --target-lang $TGT \
  --trainpref "${DATA_DIR}/train/train.en-ca" \
  --validpref "${DATA_DIR}/valid/valid.en-ca" \
  --destdir $DEST_DIR \
  --workers 128 \
  --srcdict "${DATA_DIR}/dict.txt" --joined-dictionary
#  --tgtdict "${DATA_DIR}/dict.txt"


python $(which fairseq-preprocess) --source-lang $TGT \
  --target-lang $SRC \
  --trainpref "${DATA_DIR}/train/train.en-ca" \
  --validpref "${DATA_DIR}/valid/valid.en-ca" \
  --destdir $DEST_DIR \
  --workers 128 \
  --srcdict "${DATA_DIR}/dict.txt" --joined-dictionary

#  --tgtdict "${DATA_DIR}/dict.txt" \

/ '  
# preprocess monolingual EN

python $(which fairseq-preprocess) --only-source --srcdict "${DATA_DIR}/dict.txt" \
  --trainpref "${DATA_DIR}/train/train.en" \
  --destdir $DEST_DIR \
  --workers 128

# preprocess monolingual CA


python $(which fairseq-preprocess) --only-source --srcdict "${DATA_DIR}/dict.txt" \
  --trainpref "${DATA_DIR}/train/train.10k.ca" \
  --destdir $DEST_DIR \
  --workers 128
'
