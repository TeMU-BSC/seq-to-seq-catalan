#!/bin/bash

    # Fairseq parameters
    DATA_DIR=data-bin
    TOTAL_UPDATES=100000    # Total number of training steps
    # MAX_EPOCH=1
    WARMUP_UPDATES=5000    # Warmup the learning rate over this many updates
    PEAK_LR=0.0005          # Peak learning rate, adjust as needed
    TOKENS_PER_SAMPLE=512   # Max sequence length
    MAX_POSITIONS=1024       # Num. positional embeddings (usually same as above)
    MAX_SENTENCES=4         # Number of sequences per batch (batch size)
    UPDATE_FREQ=16          # Increase the batch size 32x
    
    $(which fairseq-train) --fp16 $DATA_DIR \
    --task multilingual_denoising --langs ca,en \
    --criterion label_smoothed_cross_entropy --add-lang-token --replace-length=1 \
    --arch mbart_large --label-smoothing 0.1 --dataset-impl lazy \
    --optimizer adam --adam-betas '(0.9,0.98)' --adam-eps 1e-6 --clip-norm 0.0 \
    --lr-scheduler polynomial_decay --lr $PEAK_LR --warmup-updates $WARMUP_UPDATES --total-num-update $TOTAL_UPDATES \
    --dropout 0.1 --attention-dropout 0.1 --weight-decay 0.01 \
    --batch-size $MAX_SENTENCES --update-freq $UPDATE_FREQ \
    --max-update $TOTAL_UPDATES --log-format simple --log-interval 1 \
    --tensorboard-logdir tb --skip-invalid-size-inputs-valid-test \
    --save-interval-updates 1000 --dataset-impl lazy \
    --encoder-normalize-before --decoder-normalize-before --activation-dropout 0.1 \
    --save-dir checkpoints/mbart_large_ca_en --mask 0.35 --poisson-lambda 3.5 --permute 1 \
    --multilang-sampling-alpha 0.1 --dataset-impl lazy \
    --user-dir ca-en-extend/fairseq_model --distributed-no-spawn
   
