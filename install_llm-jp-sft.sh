#!/bin/bash

git clone https://github.com/llm-jp/llm-jp-sft.git
cd llm-jp-sft
python3 -m venv venv
source venv/bin/activate
pip install -U pip setuptools wheel
pip install -r requirements.in
ln -s /model/tuning_eval_data/20231204/tuning/train/ dataset
cd ..
