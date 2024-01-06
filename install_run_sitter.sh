#!/bin/bash

git clone https://github.com/t0-0/run_sitter.git -b llm-jp-modelwg
cd run_sitter/
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd ..
