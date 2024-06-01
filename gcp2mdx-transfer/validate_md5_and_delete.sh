#!/bin/bash

set -e -o pipefail

check_delete() {
    gcs_path="$1"
    mdx_path="$2"
    echo "============== $gcs_path =============="
    echo "============== $mdx_path =============="
    gcs_md5="$(rclone --config=rclone.conf md5sum "$gcs_path" | sort -k 2,2)"
    mdx_md5="$(rclone --config=rclone.conf md5sum "$mdx_path" | sort -k 2,2)"
    if [ "$gcs_md5" = "" ]; then
        echo -e "\e[31m[ERROR]\e[0m gcs_md5 empty for $gcs_path"
    fi
    if [ "$mdx_md5" = "" ]; then
        echo -e "\e[31m[ERROR]\e[0m mdx_md5 empty for $mdx_path"
    fi
    if [ "$gcs_md5" != "$mdx_md5" ]; then
        echo -e "\e[31m[ERROR]\e[0m MD5 mismatch for $gcs_path"
    else
        echo -e "\e[32m[OK]\e[0m MD5 match for $gcs_path"
        $echo rclone --config=rclone.conf --rmdirs --dry-run delete "$gcs_path"
    fi
}

echo=""

# Non lustre checkpoints
begin=500
end=12500
step=500
gcs_bucket="gcs:llama-2-172b-checkpoints"
mdx_bucket="mdx-s3:llama-2-172b-checkpoints"
for iter in $(seq -f 'iter_%07g' $begin $step $end); do
    check_delete "$gcs_bucket/$iter" "$mdx_bucket/$iter"
done

# Lustre checkpoints from 13000 to 30000 with step 500
begin=13000
end=30000
step=500
gcs_bucket="gcs:llama-2-172b-lustre-checkpoints"
mdx_bucket="mdx-s3:llama-2-172b-checkpoints"
for iter in $(seq -f 'iter_%07g' $begin $step $end); do
    check_delete "$gcs_bucket/$iter" "$mdx_bucket/$iter"
done

