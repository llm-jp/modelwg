#!/bin/bash

set -e

INPUT_MEGATRON_CHECKPOINT_DIR=$1
OUTPUT_HUGGINGFACE_CHECKPOINT_DIR=$2
SOURCE_HUGGINGFACE_TOKENIZER_DIR=$3
TEMP_MEGATRON_CHECKPOINT_DIR=${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}.megatron_tp1_pp1.tmp

echo ==========================================
echo Phase 1: Merge TPs and PPs
echo python Megatron-Llama2/tools/checkpoint/util.py \
  --megatron-path `pwd`/Megatron-Llama2 \
  --model-type GPT \
  --loader megatron \
  --saver megatron \
  --target-tensor-parallel-size 1 \
  --target-pipeline-parallel-size 1 \
  --load-dir ${INPUT_MEGATRON_CHECKPOINT_DIR} \
  --save-dir ${TEMP_MEGATRON_CHECKPOINT_DIR}
python Megatron-Llama2/tools/checkpoint/util.py \
  --megatron-path `pwd`/Megatron-Llama2 \
  --model-type GPT \
  --loader megatron \
  --saver megatron \
  --target-tensor-parallel-size 1 \
  --target-pipeline-parallel-size 1 \
  --load-dir ${INPUT_MEGATRON_CHECKPOINT_DIR} \
  --save-dir ${TEMP_MEGATRON_CHECKPOINT_DIR}

echo ==========================================
echo Phase 2: Convert Megatron to Hugging Face
echo python Megatron-Llama2/scripts/abci/megatron_to_hf/llama_checkpoint_conversion.py \
  --megatron-path `pwd`/Megatron-Llama2 \
  --convert_checkpoint_from_megatron_to_transformers \
  --load_path ${TEMP_MEGATRON_CHECKPOINT_DIR} \
  --save_path ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR} \
  --target_params_dtype "bf16" \
  --print-checkpoint-structure
python Megatron-Llama2/scripts/abci/megatron_to_hf/llama_checkpoint_conversion.py \
  --megatron-path `pwd`/Megatron-Llama2 \
  --convert_checkpoint_from_megatron_to_transformers \
  --load_path ${TEMP_MEGATRON_CHECKPOINT_DIR} \
  --save_path ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR} \
  --target_params_dtype "bf16" \
  --print-checkpoint-structure

echo ==========================================
echo Phase 3: Delete temporal directory
echo rm -r ${TEMP_MEGATRON_CHECKPOINT_DIR}
rm -r ${TEMP_MEGATRON_CHECKPOINT_DIR}

echo ==========================================
echo Phase 4: Copy Hugging Face Tokenizer files
echo cp ${SOURCE_HUGGINGFACE_TOKENIZER_DIR}/* ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}/
cp ${SOURCE_HUGGINGFACE_TOKENIZER_DIR}/* ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}/

echo
echo ls -l ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}
ls -l ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}
echo
echo Conversion suceeded: from ${INPUT_MEGATRON_CHECKPOINT_DIR} to ${OUTPUT_HUGGINGFACE_CHECKPOINT_DIR}
echo
