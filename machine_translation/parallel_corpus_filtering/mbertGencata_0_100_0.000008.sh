#!/bin/bash  
  
DATETIME=`date +'date_%y-%m-%d_time_%H-%M-%S'`  
  
SEED=1  
  
#MODEL ARGUMENTS   

filename=$(basename $0)
filename_without_sh=${filename:0:(-3)}
arr_filename=(${filename_without_sh//_/ })
  
MODEL='mbert-cased'
NUM_EPOCHS=10
BATCH_SIZE=8  
GRADIENT_ACC_STEPS=1  
MAX_SEQ_LENGTH=512
BATCH_SIZE_PER_GPU=$(( $BATCH_SIZE*$GRADIENT_ACC_STEPS ))  
MIN_TRAIN_PERCENTAGE=${arr_filename[1]}
MAX_TRAIN_PERCENTAGE=${arr_filename[2]}
LEARN_RATE=${arr_filename[3]}
WARMUP=0.06  
WEIGHT_DECAY=0.01  
SAVE_STEPS=2000
DATASET_PATH='../gencata/gencata.py'  
  
MODEL_ARGS=" \
 --model_name_or_path $MODEL \
 --dataset_name $DATASET_PATH \
 --train_slice "train[${MIN_TRAIN_PERCENTAGE}%:${MAX_TRAIN_PERCENTAGE}%]" \
 --task_name mt_qe \
 --do_train \
 --do_eval \
 --do_predict \
 --num_train_epochs $NUM_EPOCHS \
 --max_seq_length $MAX_SEQ_LENGTH \
 --gradient_accumulation_steps $GRADIENT_ACC_STEPS \
 --per_device_train_batch_size $BATCH_SIZE \
 --learning_rate $LEARN_RATE \
 --warmup_ratio $WARMUP \
 --weight_decay $WEIGHT_DECAY \
 --metric_for_best_model accuracy \
 --evaluation_strategy steps \
 --save_strategy steps \
 --save_steps $SAVE_STEPS \
 "  
  
#DISTRIBUTED ARGUMENTS  
  
export NNODES=$SLURM_NNODES  
export GPUS_PER_NODE=2
export WORLD_SIZE=$(($GPUS_PER_NODE*$NNODES))  
export MASTER_ADDR=$SLURM_LAUNCH_NODE_IPADDR
echo $SLURM_LAUNCH_NODE_IPADDR
export MASTER_PORT=29401
echo $SLURM_PROCID
export RANK=$SLURM_PROCID 

  
DIST_ARGS=" \
 --nproc_per_node=$GPUS_PER_NODE \
 --nnodes=$NNODES \
 --rdzv_id=$SLURM_JOB_ID \
 --rdzv_backend=c10d \
 --rdzv_endpoint=$MASTER_ADDR:$MASTER_PORT \
 "  
  
#OUTPUT ARGUMENTS  
  
OUTPUT_DIR='./output/'  
LOGGING_DIR='./tb/'  
LOGGING_STEPS=2000
CACHE_DIR='./.cache'  
DIR_NAME=${filename_without_sh}_${BATCH_SIZE_PER_GPU}_${WEIGHT_DECAY}_${LEARN_RATE}_$(date +"%m-%d-%y_%H-%M")  
  
OUTPUT_ARGS=" \
 --output_dir $OUTPUT_DIR/$DIR_NAME \
 --overwrite_output_dir \
 --logging_dir $LOGGING_DIR/$DIR_NAME \
 --logging_strategy steps \
 --logging_steps $LOGGING_STEPS \
 --cache_dir $CACHE_DIR/$DIR_NAME \
 --overwrite_cache \
 --load_best_model_at_end \
 "  
  
export HF_HOME=$CACHE_DIR/$DIR_NAME/huggingface  
# export NCCL_P2P_LEVEL=0
# export NCCL_DEBUG=INFO

  
echo "lr:"
echo $LEARN_RATE
echo "train[${MIN_TRAIN_PERCENTAGE}%:${MAX_TRAIN_PERCENTAGE}%]"
python run_glue.py --seed $SEED $MODEL_ARGS $OUTPUT_ARGS
