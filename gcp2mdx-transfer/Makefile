# A makefile to transfer data from GCS to mdx object storage (S3 compatible)

NUM_WORKERS := 512
RCLONE_GLOBAL_FLAGS := --verbose --config=rclone.conf
RCLONE_COPY_FLAGS := --transfers $(NUM_WORKERS) --checkers $(NUM_WORKERS) --checksum

SRC_BUCKET_NON_LUSTRE := gcs:llama-2-172b-checkpoints
SRC_BUCKET := gcs:llama-2-172b-lustre-checkpoints
DEST_BUCKET := mdx-s3:llama-2-172b-checkpoints

ifdef SLACK_WEBHOOK
	WATCH_FLAGS := --slack_webhook=${SLACK_WEBHOOK}
endif

# Default is dry run mode
dry_run := 1

# Dry run mode
TOUCH_FLAGS =
ifeq ($(dry_run),1)
	RCLONE_GLOBAL_FLAGS += --dry-run
	TOUCH_FLAGS += --no-create
endif

all : stamps/non_lustre_checkpoints stamps/checkpoints_13000_to_30000 stamps/checkpoints_31000_to_150000

stamps/non_lustre_checkpoints : stamps
	./watch.py ${WATCH_FLAGS} \
		rclone ${RCLONE_GLOBAL_FLAGS} copy \
		${RCLONE_COPY_FLAGS} \
		--include-from=include_500_to_30000.txt \
		--log-file=rclone_non_lustre_checkpoints.log \
		${SRC_BUCKET_NON_LUSTRE}/ ${DEST_BUCKET}/
	touch $(TOUCH_FLAGS) $@

stamps/checkpoints_13000_to_30000 : stamps
	./watch.py ${WATCH_FLAGS} \
		rclone ${RCLONE_GLOBAL_FLAGS} copy \
		${RCLONE_COPY_FLAGS} \
		--include-from=include_500_to_30000.txt \
		--log-file=rclone_checkpoints_13000_to_30000.log \
		${SRC_BUCKET}/ ${DEST_BUCKET}/
	touch $(TOUCH_FLAGS) $@

stamps/checkpoints_31000_to_150000 : stamps
	./watch.py ${WATCH_FLAGS} \
		rclone ${RCLONE_GLOBAL_FLAGS} copy \
		${RCLONE_COPY_FLAGS} \
		--include-from=include_31000_to_150000.txt \
		--log-file=rclone_checkpoints_31000_to_150000.log \
		${SRC_BUCKET}/ ${DEST_BUCKET}/
	touch $(TOUCH_FLAGS) $@

stamps:
	mkdir -p $@
