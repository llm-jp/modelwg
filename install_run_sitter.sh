#!/bin/bash

git clone https://github.com/t0-0/run_sitter.git -b llm-jp-modelwg
chmod -R a+w run_sitter/
cd run_sitter/
umask 000
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd ..
