#!/bin/bash

git clone https://github.com/llm-jp/Megatron-DeepSpeed.git -b llmjp0/dev-0 convert2hf-13b
cd convert2hf-13b
python3 -m venv venv
source venv/bin/activate
pip install -U pip setuptools wheel
pip install torch==2.0.1+cu118 --index-url https://download.pytorch.org/whl/cu118
pip install -e .
pip install deepspeed six safetensors transformers
git clone https://github.com/NVIDIA/apex -b 23.08
cd apex
pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext" ./
cd ..
cd ..
