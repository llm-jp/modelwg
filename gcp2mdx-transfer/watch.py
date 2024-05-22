#!/usr/bin/env python3

'''
Command line tool to run a command and send a message to a Slack webhook if the command fails.
'''

import subprocess
import urllib
import urllib.request
import urllib.parse
import argparse

def call_slack_webhook(webhook, message):
    data = urllib.parse.urlencode({'payload': f'{{"text": "{message}"}}'}).encode()
    req = urllib.request.Request(webhook, data=data)
    urllib.request.urlopen(req)

def main():
    parser = argparse.ArgumentParser(description='Watch subprocesses')
    parser.add_argument('--slack_webhook', help='Slack webhook URL')
    parser.add_argument('command', nargs=argparse.REMAINDER, help='Command to run')

    args = parser.parse_args()
    webhook = args.slack_webhook
    command = args.command
    if not command:
        parser.error('No command provided')
        exit(1)

    command_str = ' '.join(command)
    print(f'Running command: `{command_str}`')
    proc = subprocess.run(command)
    if proc.returncode != 0:
        message = f'Command failed with exit code {proc.returncode}: `{command_str}`'
        print(message)
        if webhook:
            call_slack_webhook(webhook, message)
    else:
        message = f'Command successfully ended: `{command_str}`'
        print(message)
        if webhook:
            call_slack_webhook(webhook, message)

if __name__ == '__main__':
    main()