#!/bin/bash

source ~/.bashrc


    # Fairseq parameters
    DATA_DIR=data-bin
    TOTAL_UPDATES=100000    # Total number of training steps
    MAX_EPOCH=5
    WARMUP_UPDATES=200    # Warmup the learning rate over this many updates
    PEAK_LR=0.0001          # Peak learning rate, adjust as needed
    TOKENS_PER_SAMPLE=512   # Max sequence length
    MAX_POSITIONS=1024       # Num. positional embeddings (usually same as above)
    MAX_SENTENCES=1         # Number of sequences per batch (batch size)
    UPDATE_FREQ=512         # Total batch size UPDATE_FREQ * MAX_SENTENCES_NUM_GPUS = 2048 x
    
    $(which fairseq-train) --fp16 $DATA_DIR \
    --task translation_multi_simple_epoch --langs ca,en \
    --lang-pairs ca-en,en-ca --lang-tok-style mbart \
    --encoder-langtok "src" --decoder-langtok --enable-reservsed-directions-shared-datasets \
    --criterion label_smoothed_cross_entropy \
    --arch mbart_large --label-smoothing 0.1 --dataset-impl lazy \
    --optimizer adam --adam-betas '(0.9,0.98)' --adam-eps 1e-6 --clip-norm 0.0 \
    --lr-scheduler polynomial_decay --lr $PEAK_LR --warmup-updates $WARMUP_UPDATES --total-num-update $TOTAL_UPDATES \
    --dropout 0.1 --attention-dropout 0.1 --weight-decay 0.01 \
    --batch-size $MAX_SENTENCES --update-freq $UPDATE_FREQ \
    --max-epoch $MAX_EPOCH --log-format simple --log-interval 1 \
    --tensorboard-logdir tb --skip-invalid-size-inputs-valid-test \
    --save-interval-updates 1000 --dataset-impl lazy \
    --encoder-normalize-before --decoder-normalize-before --activation-dropout 0.1 \
    --restore-file checkpoints/mbart_large_ca_en/checkpoint_best.pt \
    --save-dir checkpoints/mbart_large_ca_en_ft_mtse_dirty \
    --user-dir ca-en-extend/fairseq_model --distributed-no-spawn
   
