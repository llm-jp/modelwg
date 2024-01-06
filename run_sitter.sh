#!/bin/bash

set -e

cd run_sitter/
source venv/bin/activate

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/"

echo ==========================================
echo python is_stopped.py $@
python is_stoppoed.py $@
