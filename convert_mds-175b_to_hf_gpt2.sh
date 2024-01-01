#!/bin/bash

set -e

INPUT_MDS_CHECKPOINT_DIR=$1
OUTPUT_HUGGINGFACE_CHECKPOINT_DIR=$2
SOURCE_HUGGINGFACE_TOKENIZER_DIR=$3

source convert2hf-175b/venv/bin/activate

cd convert2hf-175b/tools/convert_checkpoint/

echo ==========================================
echo Phase 1: Convert Megatron-DeepSpeed to Hugging Face
echo python deepspeed_to_transformers.py \
  --input_folder ${INPUT_MDS_CHECKPOINT_DIR} \
  --output_folder ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR} \
  --target_tp 1 \
  --target_pp 1
python deepspeed_to_transformers.py \
  --input_folder ${INPUT_MDS_CHECKPOINT_DIR} \
  --output_folder ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR} \
  --target_tp 1 \
  --target_pp 1

echo ==========================================
echo Phase 2: Copy Hugging Face Tokenizer files
echo cp ${SOURCE_HUGGINGFACE_TOKENIZER_DIR}/* ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}/
cp ${SOURCE_HUGGINGFACE_TOKENIZER_DIR}/* ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}/

echo
echo ls -l ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}
ls -l ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}
echo
echo Conversion suceeded: from ${INPUT_MDS_CHECKPOINT_DIR} to ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}
echo
