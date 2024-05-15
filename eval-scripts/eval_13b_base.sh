#!/bin/bash

set -eux

SCRIPT_PATH="llm-jp-eval/"
cd $SCRIPT_PATH

source venv/bin/activate
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-0}

# Evaluate procedure
function evaluate_13b_model () {
    TARGET_MODEL=$1
    WANDB_NAME=$2

    WANDB_ENTITY="llm-jp"
    WANDB_PROJECT="13b-sft-and-eval"

    python scripts/evaluate_llm.py \
        model.pretrained_model_name_or_path="$TARGET_MODEL" \
        tokenizer.pretrained_model_name_or_path="$TARGET_MODEL" \
        target_dataset=all \
        wandb.run_name="$WANDB_NAME" \
        wandb.entity="$WANDB_ENTITY" \
        wandb.project="$WANDB_PROJECT" \
        wandb.log=true
}

# exp6
TARGET_MODEL="/model/13B_HF/llm-jp-13b-cc-v2-63500step.code10K_en20K_ja30K_ver2.2" # exp6
WANDB_NAME="eval-exp6-base"
evaluate_13b_model $TARGET_MODEL $WANDB_NAME

# exp8
TARGET_MODEL="/model/13B_HF/llm-jp-13b-cc-v2-beta-61000step.code20K_en40K_ja60K_ver2.2" # exp8
WANDB_NAME="eval-exp8-base"
evaluate_13b_model $TARGET_MODEL $WANDB_NAME
