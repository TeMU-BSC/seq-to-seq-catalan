#!/bin/bash

# IMPORTANT: use memory efficieny fp16 (instead of --fp16), otherwise BART ooms
# Fairseq parameters
    DATA_DIR=data-bin/catsum
    TOTAL_UPDATES=20000    # Total number of training steps
    WARMUP_UPDATES=500    # Warmup the learning rate over this many updates, no update for fine-tuning
    PEAK_LR=0.00003          # Peak learning rate, adjust as needed
    TOKENS_PER_SAMPLE=512   # Max sequence length
    MAX_POSITIONS=512       # Num. positional embeddings (usually same as above)
    MAX_SENTENCES=2        # Number of sequences per batch (batch size)
    UPDATE_FREQ=64          # Total batch size UPDATE_FREQ * MAX_SENTENCES * NUM_GPUS = 2048 x
    BART_PATH=checkpoints/bart-base-ca/checkpoint_best.pt
    
    $(which fairseq-train) --fp16 $DATA_DIR \
    --restore-file $BART_PATH \
    --batch-size $MAX_SENTENCES \
    --save-dir checkpoints/ft-catsum \
    --task translation \
    --source-lang full --target-lang sum \
    --truncate-source \
    --layernorm-embedding \
    --share-all-embeddings \
    --share-decoder-input-output-embed \
    --reset-optimizer --reset-dataloader --reset-meters \
    --required-batch-size-multiple 1 \
    --arch bart_base \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --dropout 0.1 --attention-dropout 0.1 \
    --weight-decay 0.01 --optimizer adam --adam-betas "(0.9, 0.999)" --adam-eps 1e-08 \
    --clip-norm 0.1 \
    --lr-scheduler polynomial_decay --lr $PEAK_LR \
    --total-num-update $TOTAL_UPDATES --warmup-updates $WARMUP_UPDATES \
    --fp16 --update-freq $UPDATE_FREQ \
    --skip-invalid-size-inputs-valid-test \
    --find-unused-parameters;
    
