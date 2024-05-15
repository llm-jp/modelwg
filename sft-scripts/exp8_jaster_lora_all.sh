#!/bin/bash

# Single GPU sft script
# based on https://github.com/llm-jp/llm-jp-sft/blob/main/mdx/train_peft_single_gpu.sh

set -eux

# Move to script path
SCRIPT_PATH="llm-jp-sft/"
cd $SCRIPT_PATH
source venv/bin/activate

# Set CUDA Device (default: 0)
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0}"

# Target Model (TODO: Change if needed)
TARGET_MODEL="/model/13B_HF/llm-jp-13b-cc-v2-beta-61000step.code20K_en40K_ja60K_ver2.2/" # exp8
SFT_TYPE="lora-all-jaster"
OUTPUT_DIR="/model/13B_HF_RE/$(basename ${TARGET_MODEL%/})_${SFT_TYPE}"

# wandb info
export WANDB_ENTITY="llm-jp"
export WANDB_PROJECT="13b-sft-and-eval"
export WANDB_NAME="sft-exp8-${SFT_TYPE}"

# Training settings
dataset_path="./dataset"
dataset_sh="./mdx/dataset_jaster.sh"
num_train_epochs=5
per_device_train_batch_size=1
gradient_accumulation_steps=64  # global_batch_size = per_device_train_batch_size * gradient_accumulation_steps = 64
peft_target_model="llama-all"
max_seq_length=4096             # for llama model
learning_rate="2e-5"
lr_scheduler_type="cosine"
warmup_ratio=0.1

python train.py \
    --model_name_or_path $TARGET_MODEL \
    --tokenizer_name_or_path $TARGET_MODEL \
    --use_peft \
    --num_train_epochs $num_train_epochs \
    --per_device_train_batch_size $per_device_train_batch_size \
    --gradient_accumulation_steps $gradient_accumulation_steps \
    --learning_rate $learning_rate \
    --warmup_ratio $warmup_ratio \
    --lr_scheduler_type $lr_scheduler_type \
    --bf16 \
    --max_seq_length $max_seq_length \
    --logging_steps 10 \
    --report_to wandb \
    --data_files $($dataset_sh $dataset_path) \
    --output_dir "$OUTPUT_DIR" \
    --peft_target_model $peft_target_model
