#!/bin/bash

set -e -o pipefail

check_() {
    gcs_path="$1"
    mdx_path="$2"
    gcs_md5="$(rclone --config=rclone.conf md5sum "$gcs_path" | sort -k 2,2)"
    mdx_md5="$(rclone --config=rclone.conf md5sum "$mdx_path" | sort -k 2,2)"
    if [ "$gcs_md5" = "" ]; then
        echo -e "\e[36m[INFO]\e[0m $gcs_path is empty, skipping..."
    elif [ "$gcs_md5" != "$mdx_md5" ]; then
        echo -e "\e[31m[ERROR]\e[0m MD5 mismatch for $gcs_path"
    else
        echo -e "\e[32m[OK]\e[0m MD5 match for $gcs_path"
    fi
}

mdx_bucket="mdx-s3:llama-2-172b-checkpoints"
gcs_bucket="gcs:llama-2-172b-lustre-checkpoints"
first_iter="$(rclone --config=rclone.conf lsd $gcs_bucket | grep -o 'iter_[0-9]\+' | sed 's/^iter_0*//' | grep -E '^[0-9]+000$' | sort -h | head -n1)"
last_iter="$(rclone --config=rclone.conf lsd $mdx_bucket | grep -o 'iter_[0-9]\+' | sed 's/^iter_0*//' | sort -h | tail -n1)"
echo "First iteration: $tmux first_iter"
echo "Last iteration: $last_iter"

# Checkpoints from 31000 to 150000 with step 1000
begin=31000
end="$last_iter"
step=1000
for iter in $(seq -f 'iter_%07g' $begin $step $end); do
    check_ "$gcs_bucket/$iter" "$mdx_bucket/$iter"
done
