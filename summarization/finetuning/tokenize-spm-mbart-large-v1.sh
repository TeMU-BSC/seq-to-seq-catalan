#!/bin/bash

PYTHON=python
# https://github.com/pytorch/fairseq/blob/main/scripts/spm_encode.py
SPM=spm_encode.py
MODEL=mbart.cc25/sentence.bpe.model
DATA=data/original
OUTPUT=data/tokenized
SRC=full
TGT=sum
TRAIN=train
VALID=valid
TEST=test

${PYTHON} ${SPM} --model=${MODEL} --max-len 1024 --inputs "${DATA}/${TRAIN}.${SRC}" "${DATA}/${TRAIN}.${TGT}" --outputs "${OUTPUT}/${TRAIN}.spm.${SRC}" "${OUTPUT}/${TRAIN}.spm.${TGT}"
${PYTHON} ${SPM} --model=${MODEL} --max-len 1024 --inputs "${DATA}/${VALID}.${SRC}" "${DATA}/${VALID}.${TGT}" --outputs "${OUTPUT}/${VALID}.spm.${SRC}" "${OUTPUT}/${VALID}.spm.${TGT}"
${PYTHON} ${SPM} --model=${MODEL} --max-len 1024 --inputs "${DATA}/${TEST}.${SRC}" "${DATA}/${TEST}.${TGT}" --outputs "${OUTPUT}/${TEST}.spm.${SRC}" "${OUTPUT}/${TEST}.spm.${TGT}"
