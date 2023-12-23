#!/bin/bash

git clone https://github.com/rioyokotalab/Megatron-Llama2.git
cd Megatron-Llama2
python3 -m venv venv
source venv/bin/activate
pip install -U pip setuptools wheel
pip install -r requirements.txt
git clone https://github.com/NVIDIA/apex -b 23.08
cd apex
pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext" ./
cd ..
cp ../tools/convert_megatron_to_hf_llama.sh .
pip install packaging ninja
FLASH_ATTENTION_FORCE_BUILD=TRUE pip install flash-attn --no-build-isolation
