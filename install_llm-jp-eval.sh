#!/bin/bash

git clone https://github.com/llm-jp/llm-jp-eval.git
cd llm-jp-eval
python3 -m venv venv
source venv/bin/activate
pip install -U pip setuptools wheel
pip install -r requirements.txt
cd ..
