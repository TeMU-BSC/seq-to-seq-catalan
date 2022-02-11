#!/bin/bash

DATA_DIR=data-bin
MODEL_DIR=path/to/sentencepiece

python $(which fairseq-generate) \
    --fp16 $DATA_DIR \
    --task translation_multi_simple_epoch --lang-pairs ca,en \
    --gen-subset test --source-lang ca --target-lang en \
    --lang-tok-style mbart \
    --encoder-langtok "src" --decoder-langtok \
    --dataset-impl lazy \
    --path checkpoints_mbart_ca_en_mt/checkpoint_last.pt   
    --bpe 'sentencepiece' --sentencepiece-model $MODEL_DIR/m.model \
    --remove-bpe 'sentencepiece'

