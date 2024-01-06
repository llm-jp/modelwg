#!/bin/bash

set -e

cd run_sitter/
source venv/bin/activate

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/"

echo ==========================================
echo nohup python is_stopped.py $@ '&> /dev/null &'
nohup python is_stoppoed.py $@ &> /dev/null &
