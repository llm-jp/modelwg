#!/bin/bash

git clone https://github.com/llm-jp/llm-jp-eval.git
cd llm-jp-eval
python3 -m venv venv
source venv/bin/activate
pip install -U pip setuptools wheel
pip install .
sed 's|dataset_dir: "path/to/dataset"|dataset_dir: "dataset/evaluation/dev"|' configs/config_template.yaml > configs/config.yaml
ln -s /model/tuning_eval_data/20231204/ dataset
cd ..
