#!/bin/bash

set -e

# Non lustre checkpoints
begin=500
end=12500
step=500
gcs_bucket="gcs:llama-2-172b-checkpoints"
mdx_bucket="mdx-s3:llama-2-172b-checkpoints"
for iter in $(seq -f 'iter_%07g' $begin $step $end); do
    gcs_md5="$(rclone --config=rclone.conf md5sum "$gcs_bucket/$iter" | sort -k 2,2)"
    mdx_md5="$(rclone --config=rclone.conf md5sum "$mdx_bucket/$iter" | sort -k 2,2)"
    if [ "$gcs_md5" != "$mdx_md5" ]; then
        echo -e "\e[31m[ERROR]\e[0m MD5 mismatch for $iter"
    else
        echo -e "\e[32m[OK]\e[0m MD5 match for $iter"
    fi
done

# Lustre checkpoints from 13000 to 30000 with step 500
begin=13000
end=30000
step=500
gcs_bucket="gcs:llama-2-172b-lustre-checkpoints"
mdx_bucket="mdx-s3:llama-2-172b-checkpoints"
for iter in $(seq -f 'iter_%07g' $begin $step $end); do
    gcs_md5="$(rclone --config=rclone.conf md5sum "$gcs_bucket/$iter" | sort -k 2,2)"
    mdx_md5="$(rclone --config=rclone.conf md5sum "$mdx_bucket/$iter" | sort -k 2,2)"
    if [ "$gcs_md5" != "$mdx_md5" ]; then
        echo -e "\e[31m[ERROR]\e[0m MD5 mismatch for $iter"
    else
        echo -e "\e[32m[OK]\e[0m MD5 match for $iter"
    fi
done
