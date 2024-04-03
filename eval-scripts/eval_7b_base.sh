#!/bin/bash

set -eux

SCRIPT_PATH="llm-jp-eval/"
cd $SCRIPT_PATH

source venv/bin/activate
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-0}

# Evaluate procedure
function evaluate_7b_model () {
    TARGET_MODEL=$1
    WANDB_NAME=$2

    WANDB_ENTITY="llm-jp"
    WANDB_PROJECT="7b-sft-and-eval"

    python scripts/evaluate_llm.py \
        model.pretrained_model_name_or_path="$TARGET_MODEL" \
        tokenizer.pretrained_model_name_or_path="$TARGET_MODEL" \
        target_dataset=all \
        wandb.run_name="$WANDB_NAME" \
        wandb.entity="$WANDB_ENTITY" \
        wandb.project="$WANDB_PROJECT" \
        wandb.log=true
}

# exp1
TARGET_MODEL="/model/7B_HF/llm-jp-7b-61000step.code20K_en40K_ja60K_ver2.2" # exp1
WANDB_NAME="eval-exp1-base"
evaluate_7b_model $TARGET_MODEL $WANDB_NAME

# exp2
TARGET_MODEL="/model/7B_HF/llm-jp-7b-okazaki-lab-cc-63500step.code10K_en20K_ja30K_ver2.2" # exp2
WANDB_NAME="eval-exp2-base"
evaluate_7b_model $TARGET_MODEL $WANDB_NAME

# exp3
TARGET_MODEL="/model/7B_HF/llm-jp-7b-63500step.code10K_en20K_ja30K_ver2.2" # exp3
WANDB_NAME="eval-exp3-base"
evaluate_7b_model $TARGET_MODEL $WANDB_NAME

# exp4
TARGET_MODEL="/model/7B_HF/llm-jp-7b-cc-v2-63500step.code10K_en20K_ja30K_ver2.2" # exp4
WANDB_NAME="eval-exp4-base"
evaluate_7b_model $TARGET_MODEL $WANDB_NAME

# exp4+
TARGET_MODEL="/model/7B_HF/llm-jp-7b-cc-v2-beta-63500step.code10K_en20K_ja30K_ver2.2" # exp4+
WANDB_NAME="eval-exp4+-base"
evaluate_7b_model $TARGET_MODEL $WANDB_NAME

# exp5
# Skip for now

# exp7
TARGET_MODEL="/model/7B_HF/llm-jp-7b-cc-v2-beta-119000step.code10k_en20k_ja30k_ver2.2" # exp7
WANDB_NAME="eval-exp7-base"
evaluate_7b_model $TARGET_MODEL $WANDB_NAME

# exp9
TARGET_MODEL="/model/7B_HF/llm-jp-7b-CC_v2_100k_ver3.0" # exp9
WANDB_NAME="eval-exp9-base"
evaluate_7b_model $TARGET_MODEL $WANDB_NAME