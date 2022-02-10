#!/bin/bash

XSUM_KWARGS() {
 BEAM=6 
 LENPEN=1.0 
 MAX_LEN_B=60 
 MIN_LEN=10 
 NO_REPEAT_NGRAM_SIZE=3

}

CNN_KWARGS() {
 BEAM=4 
 LENPEN=2.0 
 MAX_LEN_B=140 
 MIN_LEN=55 
 NO_REPEAT_NGRAM_SIZE=3
}

CNN_KWARGS

python $(which fairseq-generate) \
    data-bin/catsum-spm \
    --fp16 \
    --task translation \
    --skip-invalid-size-inputs-valid-test \
    --path checkpoints/mbart-large/checkpoint_best.pt \
    --source-lang full --target-lang sum \
    --beam $BEAM \
    --lenpen $LENPEN \
    --max-len-b $MAX_LEN_B \
    --min-len $MIN_LEN \
    --no-repeat-ngram-size $NO_REPEAT_NGRAM_SIZE \
    --num-workers 128 \
    --remove-bpe 'sentencepiece'

