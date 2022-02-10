#!/bin/bash


for DATASET in train.ca train.en valid.ca valid.en; do

  python spm_encode.py --model tokenized/m.model --inputs staged_raw/final/$DATASET --outputs staged_tokenized/$DATASET --max-len 1024

done;
