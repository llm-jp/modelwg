#!/bin/bash

set -e

cd run_sitter/
source venv/bin/activate

SLACK_WEBHOOK_URL=`cat run_sitter_url.txt`

python is_stoppoed.py $@
