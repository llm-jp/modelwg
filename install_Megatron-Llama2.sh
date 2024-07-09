#!/bin/bash

git clone https://github.com/rioyokotalab/Megatron-Llama2.git
cd Megatron-Llama2
python3 -m venv venv
source venv/bin/activate
pip install -U pip 'setuptools<70' wheel
pip install -r requirements.txt
git clone https://github.com/NVIDIA/apex -b 23.08
cd apex
pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext" ./
cd ..
pip install packaging ninja
FLASH_ATTENTION_FORCE_BUILD=TRUE pip install "flash-attn!=2.5.9.post1" --no-build-isolation
