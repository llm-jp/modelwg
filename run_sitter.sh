#!/bin/bash

set -e

SLACK_WEBHOOK_URL=`cat run_sitter_url.txt`

cd run_sitter/
source venv/bin/activate

python is_stoppoed.py $@
