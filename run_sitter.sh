#!/bin/bash

set -e

export SLACK_WEBHOOK_URL=`cat run_sitter_url.txt`

cd run_sitter/
source venv/bin/activate

python is_stopping.py $@
